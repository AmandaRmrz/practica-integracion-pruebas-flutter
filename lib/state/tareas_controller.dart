import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/errores.dart';
import '../data/tarea_repository.dart';
import '../models/filtro_tareas.dart';
import '../models/tarea.dart';

enum EstadoVista { cargando, exito, vacio, error }

/// Lógica de aplicación: conecta el repositorio (Firebase) con la interfaz.
class TareasController extends ChangeNotifier {
  TareasController(this._repositorio);

  final TareaRepository _repositorio;
  StreamSubscription<List<Tarea>>? _suscripcion;

  EstadoVista estado = EstadoVista.cargando;
  List<Tarea> tareas = const [];
  String? mensajeError;
  bool guardando = false;

  FiltroTareas _filtro = const FiltroTareas();
  FiltroTareas get filtro => _filtro;

  void iniciar() => _suscribir();

  void aplicarFiltro(FiltroTareas nuevo) {
    _filtro = nuevo;
    _suscribir();
  }

  /// Un stream de Firestore termina cuando emite un error, por eso
  /// "reintentar" significa volver a suscribirse.
  void reintentar() => _suscribir();

  void _suscribir() {
    _suscripcion?.cancel(); // evita escuchas duplicadas
    estado = EstadoVista.cargando;
    mensajeError = null;
    notifyListeners();

    _suscripcion = _repositorio.observar(_filtro).listen(
      (lista) {
        tareas = lista;
        estado = lista.isEmpty ? EstadoVista.vacio : EstadoVista.exito;
        notifyListeners();
      },
      onError: (Object error) {
        mensajeError = mensajeParaUsuario(error);
        estado = EstadoVista.error;
        notifyListeners();
      },
    );
  }

  /// Devuelve null si todo salió bien, o el mensaje de error para mostrar.
  Future<String?> actualizarTarea(
    String id,
    Map<String, dynamic> cambios,
  ) async {
    guardando = true;
    notifyListeners();
    try {
      await _repositorio.actualizar(id, cambios);
      return null; // la lista se refresca sola gracias al stream
    } on RepositorioException catch (e) {
      return e.mensaje;
    } finally {
      guardando = false;
      notifyListeners();
    }
  }

  Future<String?> alternarCompletada(Tarea tarea) =>
      actualizarTarea(tarea.id!, {'completada': !tarea.completada});

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
