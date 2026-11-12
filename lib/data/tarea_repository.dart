import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/filtro_tareas.dart';
import '../models/tarea.dart';
import 'errores.dart';

/// Única clase que conoce Firestore. La interfaz nunca lo usa directamente.
class TareaRepository {
  TareaRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  /// Colección tipada: los documentos se convierten a [Tarea] automáticamente.
  CollectionReference<Tarea> get _tareas =>
      _db.collection('tareas').withConverter<Tarea>(
            fromFirestore: Tarea.fromFirestore,
            toFirestore: (tarea, _) => tarea.toFirestore(),
          );

  /// Construye la consulta a partir del filtro elegido por el usuario.
  /// Combinar igualdades con orderBy en otro campo puede requerir un
  /// índice compuesto (ver Clase 14, sección de índices).
  Query<Tarea> _construirConsulta(FiltroTareas filtro) {
    Query<Tarea> consulta = _tareas;
    if (filtro.materia != null) {
      consulta = consulta.where('materia', isEqualTo: filtro.materia);
    }
    if (filtro.soloPendientes) {
      consulta = consulta.where('completada', isEqualTo: false);
    }
    return consulta.orderBy('fechaLimite').limit(filtro.limite);
  }

  /// Lectura única (equivale a "pull to refresh").
  Future<List<Tarea>> obtener(FiltroTareas filtro) async {
    try {
      final snapshot = await _construirConsulta(filtro).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw RepositorioException(mensajeParaUsuario(e), codigo: e.code);
    }
  }

  /// Escucha en tiempo real: emite una lista nueva cada vez que cambian
  /// los datos que cumplen la consulta.
  Stream<List<Tarea>> observar(FiltroTareas filtro) {
    return _construirConsulta(filtro)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<Tarea?> obtenerPorId(String id) async {
    try {
      final doc = await _tareas.doc(id).get();
      return doc.exists ? doc.data() : null;
    } on FirebaseException catch (e) {
      throw RepositorioException(mensajeParaUsuario(e), codigo: e.code);
    }
  }

  /// Actualización parcial: solo se envían los campos que cambiaron.
  /// `update` falla con `not-found` si el documento no existe.
  ///
  /// OJO: con persistencia offline, la escritura se guarda localmente y el
  /// Future solo se completa cuando el servidor confirma. Por eso se usa
  /// timeout para no dejar al usuario esperando indefinidamente.
  Future<void> actualizar(String id, Map<String, dynamic> cambios) async {
    try {
      await _db
          .collection('tareas')
          .doc(id)
          .update({...cambios, 'actualizadaEn': FieldValue.serverTimestamp()})
          .timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      throw RepositorioException(mensajeParaUsuario(e), codigo: e.code);
    } on TimeoutException catch (e) {
      throw RepositorioException(mensajeParaUsuario(e), codigo: 'timeout');
    }
  }
}
