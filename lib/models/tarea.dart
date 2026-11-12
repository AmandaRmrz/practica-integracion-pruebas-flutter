import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo Dart de un documento de la colección `tareas`.
class Tarea {
  const Tarea({
    this.id,
    required this.titulo,
    required this.materia,
    required this.prioridad,
    required this.completada,
    required this.fechaLimite,
    this.notas = '',
  });

  /// ID del documento en Firestore (null si aún no se ha guardado).
  final String? id;
  final String titulo;
  final String materia;

  /// 1 = alta, 2 = media, 3 = baja. Se guarda como número para poder ordenar.
  final int prioridad;
  final bool completada;
  final DateTime fechaLimite;
  final String notas;

  /// Firma compatible con `withConverter<Tarea>(fromFirestore: ...)`.
  factory Tarea.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return Tarea(
      id: snapshot.id,
      titulo: data['titulo'] as String? ?? 'Sin título',
      materia: data['materia'] as String? ?? 'Sin materia',
      prioridad: (data['prioridad'] as num?)?.toInt() ?? 2,
      completada: data['completada'] as bool? ?? false,
      fechaLimite:
          (data['fechaLimite'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notas: data['notas'] as String? ?? '',
    );
  }

  /// Se usa al crear documentos con el converter (no incluye el id).
  Map<String, dynamic> toFirestore() => {
        'titulo': titulo,
        'materia': materia,
        'prioridad': prioridad,
        'completada': completada,
        'fechaLimite': Timestamp.fromDate(fechaLimite),
        'notas': notas,
        'creadaEn': FieldValue.serverTimestamp(),
        'actualizadaEn': FieldValue.serverTimestamp(),
      };

  String get etiquetaPrioridad => switch (prioridad) {
        1 => 'Alta',
        3 => 'Baja',
        _ => 'Media',
      };
}
