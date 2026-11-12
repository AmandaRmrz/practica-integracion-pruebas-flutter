import 'package:cloud_firestore/cloud_firestore.dart';

/// Carga datos de prueba con un WriteBatch (una sola operación atómica).
/// Ejecutar UNA vez en desarrollo y luego quitar la llamada.
Future<void> sembrarDatos() async {
  final db = FirebaseFirestore.instance;
  final ahora = DateTime.now();
  Timestamp enDias(int d) => Timestamp.fromDate(ahora.add(Duration(days: d)));

  final datos = <Map<String, dynamic>>[
    {'titulo': 'Informe de laboratorio', 'materia': 'Bases de datos', 'prioridad': 1, 'completada': false, 'fechaLimite': enDias(1), 'notas': 'Incluir diagrama E-R'},
    {'titulo': 'Quiz de Streams', 'materia': 'Móviles', 'prioridad': 2, 'completada': false, 'fechaLimite': enDias(2), 'notas': ''},
    {'titulo': 'Subir avance del proyecto', 'materia': 'Móviles', 'prioridad': 1, 'completada': false, 'fechaLimite': enDias(3), 'notas': 'Repositorio + capturas'},
    {'titulo': 'Lectura capítulo 5', 'materia': 'Redes', 'prioridad': 3, 'completada': false, 'fechaLimite': enDias(5), 'notas': ''},
    {'titulo': 'Práctica de consultas SQL', 'materia': 'Bases de datos', 'prioridad': 2, 'completada': true, 'fechaLimite': enDias(-1), 'notas': ''},
    {'titulo': 'Configurar rutas en el router', 'materia': 'Redes', 'prioridad': 2, 'completada': false, 'fechaLimite': enDias(7), 'notas': 'Packet Tracer'},
    {'titulo': 'Prototipo de pantallas', 'materia': 'Móviles', 'prioridad': 3, 'completada': true, 'fechaLimite': enDias(-3), 'notas': ''},
    {'titulo': 'Resumen de normalización', 'materia': 'Bases de datos', 'prioridad': 3, 'completada': false, 'fechaLimite': enDias(10), 'notas': ''},
  ];

  final batch = db.batch();
  for (final tarea in datos) {
    final ref = db.collection('tareas').doc(); // ID automático
    batch.set(ref, {
      ...tarea,
      'creadaEn': FieldValue.serverTimestamp(),
      'actualizadaEn': FieldValue.serverTimestamp(),
    });
  }
  await batch.commit();
}
