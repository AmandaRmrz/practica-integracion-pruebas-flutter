import 'package:flutter/material.dart';

import '../models/filtro_tareas.dart';
import '../models/tarea.dart';
import '../state/tareas_controller.dart';
import 'editar_tarea_page.dart';

class ListaTareasPage extends StatelessWidget {
  const ListaTareasPage({super.key, required this.controller});

  final TareasController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TareaU')),
      body: Column(
        children: [
          _BarraFiltros(controller: controller),
          Expanded(
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) => switch (controller.estado) {
                EstadoVista.cargando =>
                  const Center(child: CircularProgressIndicator()),
                EstadoVista.error => _VistaError(
                    mensaje: controller.mensajeError ?? 'Error desconocido',
                    onReintentar: controller.reintentar,
                  ),
                EstadoVista.vacio => const _VistaVacia(),
                EstadoVista.exito => _ListaExitosa(controller: controller),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BarraFiltros extends StatelessWidget {
  const _BarraFiltros({required this.controller});
  final TareasController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final filtro = controller.filtro;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: filtro.materia,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Todas las materias'),
                    ),
                    for (final m in materiasDisponibles)
                      DropdownMenuItem<String?>(value: m, child: Text(m)),
                  ],
                  onChanged: (valor) => controller.aplicarFiltro(
                    valor == null
                        ? filtro.copyWith(quitarMateria: true)
                        : filtro.copyWith(materia: valor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text('Pendientes'),
              Switch(
                value: filtro.soloPendientes,
                onChanged: (v) =>
                    controller.aplicarFiltro(filtro.copyWith(soloPendientes: v)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ListaExitosa extends StatelessWidget {
  const _ListaExitosa({required this.controller});
  final TareasController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: controller.tareas.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final tarea = controller.tareas[index];
        return _TareaTile(tarea: tarea, controller: controller);
      },
    );
  }
}

class _TareaTile extends StatelessWidget {
  const _TareaTile({required this.tarea, required this.controller});
  final Tarea tarea;
  final TareasController controller;

  @override
  Widget build(BuildContext context) {
    final f = tarea.fechaLimite;
    final fecha =
        '${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')}/${f.year}';
    return ListTile(
      leading: Checkbox(
        value: tarea.completada,
        onChanged: (_) async {
          final messenger = ScaffoldMessenger.of(context);
          final error = await controller.alternarCompletada(tarea);
          if (error != null) {
            messenger.showSnackBar(SnackBar(content: Text(error)));
          }
        },
      ),
      title: Text(
        tarea.titulo,
        style: TextStyle(
          decoration: tarea.completada ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        '${tarea.materia} · Prioridad ${tarea.etiquetaPrioridad} · Vence $fecha',
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => EditarTareaPage(tarea: tarea, controller: controller),
        ),
      ),
    );
  }
}

class _VistaVacia extends StatelessWidget {
  const _VistaVacia();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No hay tareas que coincidan con el filtro.\n'
          'Prueba cambiar de materia o desactivar "Pendientes".',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _VistaError extends StatelessWidget {
  const _VistaError({required this.mensaje, required this.onReintentar});
  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onReintentar, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
