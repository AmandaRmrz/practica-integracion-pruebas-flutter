const materiasDisponibles = ['Móviles', 'Bases de datos', 'Redes'];

/// Criterios de consulta que elige el usuario en la interfaz.
class FiltroTareas {
  const FiltroTareas({
    this.materia,
    this.soloPendientes = true,
    this.limite = 20,
  });

  /// null = todas las materias.
  final String? materia;
  final bool soloPendientes;
  final int limite;

  FiltroTareas copyWith({
    String? materia,
    bool quitarMateria = false,
    bool? soloPendientes,
    int? limite,
  }) {
    return FiltroTareas(
      materia: quitarMateria ? null : (materia ?? this.materia),
      soloPendientes: soloPendientes ?? this.soloPendientes,
      limite: limite ?? this.limite,
    );
  }
}
