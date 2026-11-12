import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tareau/data/tarea_repository.dart';
import 'package:tareau/models/filtro_tareas.dart';
import 'package:tareau/models/tarea.dart';
import 'package:tareau/state/tareas_controller.dart';
import 'package:tareau/ui/editar_tarea_page.dart';
import 'package:tareau/ui/lista_tareas_page.dart';

class FakeTareaRepository implements TareaRepository {
  final _streamController = StreamController<List<Tarea>>.broadcast();
  final List<Tarea> _datos = [];
  bool actualizarLlamado = false;

  void emitir(List<Tarea> lista) {
    _datos
      ..clear()
      ..addAll(lista);
    _streamController.add(List.unmodifiable(_datos));
  }

  @override
  Stream<List<Tarea>> observar(FiltroTareas filtro) => _streamController.stream;

  @override
  Future<List<Tarea>> obtener(FiltroTareas filtro) async => _datos;

  @override
  Future<Tarea?> obtenerPorId(String id) async {
    for (final t in _datos) {
      if (t.id == id) return t;
    }
    return null;
  }

  @override
  Future<void> actualizar(String id, Map<String, dynamic> cambios) async {
    actualizarLlamado = true;
  }

  void cerrar() => _streamController.close();
}

void main() {
  testWidgets('Muestra estado vacío cuando no hay tareas', (tester) async {
    final fakeRepo = FakeTareaRepository();
    final controller = TareasController(fakeRepo)..iniciar();

    await tester.pumpWidget(MaterialApp(home: ListaTareasPage(controller: controller)));
    fakeRepo.emitir([]);
    await tester.pumpAndSettle();

    expect(find.textContaining('No hay tareas que coincidan con el filtro'), findsOneWidget);

    controller.dispose();
    fakeRepo.cerrar();
  });

  testWidgets('Muestra tareas, navega a editar y valida título mínimo de 3 caracteres', (tester) async {
    final fakeRepo = FakeTareaRepository();
    final controller = TareasController(fakeRepo)..iniciar();
    final tareaPrueba = Tarea(
      id: 't1',
      titulo: 'Informe de laboratorio',
      materia: 'Bases de datos',
      prioridad: 1,
      completada: false,
      fechaLimite: DateTime(2026, 11, 25),
    );

    await tester.pumpWidget(MaterialApp(home: ListaTareasPage(controller: controller)));
    fakeRepo.emitir([tareaPrueba]);
    await tester.pumpAndSettle();

    expect(find.text('Informe de laboratorio'), findsOneWidget);

    // Tocar tarea para abrir pantalla de edición
    await tester.tap(find.text('Informe de laboratorio'));
    await tester.pumpAndSettle();
    expect(find.byType(EditarTareaPage), findsOneWidget);

    // Caso negativo: ingresar título inválido (< 3 caracteres) y guardar
    await tester.enterText(find.byType(TextFormField).first, 'Ab');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe al menos 3 caracteres.'), findsOneWidget);
    expect(fakeRepo.actualizarLlamado, isFalse);

    controller.dispose();
    fakeRepo.cerrar();
  });
}