import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tareau/data/errores.dart';
import 'package:tareau/models/filtro_tareas.dart';
import 'package:tareau/models/tarea.dart';

void main() {
  group('Pruebas unitarias de TareaU', () {
    test('etiquetaPrioridad devuelve Alta, Media o Baja según el número', () {
      final base = DateTime(2026, 11, 20);
      final alta = Tarea(titulo: 'T1', materia: 'Móviles', prioridad: 1, completada: false, fechaLimite: base);
      final media = Tarea(titulo: 'T2', materia: 'Móviles', prioridad: 2, completada: false, fechaLimite: base);
      final baja = Tarea(titulo: 'T3', materia: 'Móviles', prioridad: 3, completada: false, fechaLimite: base);

      expect(alta.etiquetaPrioridad, 'Alta');
      expect(media.etiquetaPrioridad, 'Media');
      expect(baja.etiquetaPrioridad, 'Baja');
    });

    test('FiltroTareas.copyWith actualiza filtros y permite limpiar materia', () {
      const inicial = FiltroTareas();
      expect(inicial.materia, isNull);
      expect(inicial.soloPendientes, isTrue);

      final conMateria = inicial.copyWith(materia: 'Redes', soloPendientes: false);
      expect(conMateria.materia, 'Redes');
      expect(conMateria.soloPendientes, isFalse);

      final sinMateria = conMateria.copyWith(quitarMateria: true);
      expect(sinMateria.materia, isNull);
      expect(sinMateria.soloPendientes, isFalse);
    });

    test('mensajeParaUsuario traduce TimeoutException y FirebaseException', () {
      final msgTimeout = mensajeParaUsuario(TimeoutException('tiempo agotado'));
      expect(msgTimeout, contains('tardó demasiado'));

      final msgPermiso = mensajeParaUsuario(
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
      );
      expect(msgPermiso, 'No tienes permiso para realizar esta acción.');

      final msgIndice = mensajeParaUsuario(
        FirebaseException(plugin: 'cloud_firestore', code: 'failed-precondition'),
      );
      expect(msgIndice, contains('índice'));
    });
  });
}