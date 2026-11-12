import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tareau/data/tarea_repository.dart';
import 'package:tareau/models/filtro_tareas.dart';
import 'package:tareau/models/tarea.dart';
import 'package:tareau/state/tareas_controller.dart';
import 'package:tareau/ui/editar_tarea_page.dart';
import 'package:tareau/ui/lista_tareas_page.dart';

class FakeTareaRepository implements TareaRepository {
  @override
  Stream<List<Tarea>> observar(FiltroTareas filtro) => Stream.value([
        Tarea(
          id: 't1',
          titulo: 'Informe de laboratorio',
          materia: 'Bases de datos',
          prioridad: 1,
          completada: false,
          fechaLimite: DateTime(2026, 11, 20),
          notas: 'Incluir diagrama E-R',
        ),
      ]);

  @override
  Future<List<Tarea>> obtener(FiltroTareas filtro) async => [];

  @override
  Future<Tarea?> obtenerPorId(String id) async => null;

  @override
  Future<void> actualizar(String id, Map<String, dynamic> cambios) async {}
}

void main() {
  group('Pruebas Unitarias - Modelo Tarea y FiltroTareas', () {
    test('Tarea calcula correctamente la etiqueta de prioridad', () {
      final fecha = DateTime(2026, 11, 20);
      final alta = Tarea(
        titulo: 'Examen',
        materia: 'Móviles',
        prioridad: 1,
        completada: false,
        fechaLimite: fecha,
      );
      final media = Tarea(
        titulo: 'Quiz',
        materia: 'Redes',
        prioridad: 2,
        completada: false,
        fechaLimite: fecha,
      );
      final baja = Tarea(
        titulo: 'Lectura',
        materia: 'Bases de datos',
        prioridad: 3,
        completada: true,
        fechaLimite: fecha,
      );

      expect(alta.etiquetaPrioridad, 'Alta');
      expect(media.etiquetaPrioridad, 'Media');
      expect(baja.etiquetaPrioridad, 'Baja');
      expect(alta.toFirestore()['titulo'], 'Examen');
    });

    test('FiltroTareas aplica copyWith y limpia materia correctamente', () {
      const inicial = FiltroTareas();
      final filtrado = inicial.copyWith(materia: 'Móviles', soloPendientes: false);
      expect(filtrado.materia, 'Móviles');
      expect(filtrado.soloPendientes, false);

      final sinMateria = filtrado.copyWith(quitarMateria: true);
      expect(sinMateria.materia, isNull);
    });
  });

  group('Pruebas de Widget - Pantallas TareaU', () {
    testWidgets('ListaTareasPage muestra tareas emitidas por el repositorio',
        (WidgetTester tester) async {
      final controller = TareasController(FakeTareaRepository())..iniciar();

      await tester.pumpWidget(
        MaterialApp(
          home: ListaTareasPage(controller: controller),
        ),
      );
      await tester.pump();

      expect(find.text('TareaU'), findsOneWidget);
      expect(find.text('Informe de laboratorio'), findsOneWidget);
      expect(find.text('Pendientes'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('EditarTareaPage valida título menor a 3 caracteres',
        (WidgetTester tester) async {
      final controller = TareasController(FakeTareaRepository());
      final tarea = Tarea(
        id: 't1',
        titulo: 'Informe de laboratorio',
        materia: 'Bases de datos',
        prioridad: 1,
        completada: false,
        fechaLimite: DateTime(2026, 11, 20),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: EditarTareaPage(tarea: tarea, controller: controller),
        ),
      );

      // Borramos el título para dejar menos de 3 caracteres
      await tester.enterText(find.byType(TextFormField).first, 'AB');
      await tester.tap(find.text('Guardar cambios'));
      await tester.pump();

      expect(find.text('Escribe al menos 3 caracteres.'), findsOneWidget);

      controller.dispose();
    });
  });
}