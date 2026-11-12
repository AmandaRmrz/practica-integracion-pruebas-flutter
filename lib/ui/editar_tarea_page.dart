import 'package:flutter/material.dart';

import '../models/filtro_tareas.dart';
import '../models/tarea.dart';
import '../state/tareas_controller.dart';

class EditarTareaPage extends StatefulWidget {
  const EditarTareaPage({
    super.key,
    required this.tarea,
    required this.controller,
  });

  final Tarea tarea;
  final TareasController controller;

  @override
  State<EditarTareaPage> createState() => _EditarTareaPageState();
}

class _EditarTareaPageState extends State<EditarTareaPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _notasCtrl;
  late String _materia;
  late int _prioridad;
  late DateTime _fechaLimite;
  String? _errorGuardado;

@override
void initState() {
  super.initState();
  final t = widget.tarea;
  _tituloCtrl = TextEditingController(text: t.titulo);
  _notasCtrl = TextEditingController(text: t.notas);
  _materia = materiasDisponibles.contains(t.materia)
      ? t.materia
      : materiasDisponibles.first;
  _prioridad = t.prioridad;
  _fechaLimite = t.fechaLimite;
}

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fechaLimite,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (elegida != null) setState(() => _fechaLimite = elegida);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    // Actualización parcial: solo los campos que realmente cambiaron.
    final t = widget.tarea;
    final cambios = <String, dynamic>{};
    if (_tituloCtrl.text.trim() != t.titulo) {
      cambios['titulo'] = _tituloCtrl.text.trim();
    }
    if (_notasCtrl.text.trim() != t.notas) {
      cambios['notas'] = _notasCtrl.text.trim();
    }
    if (_materia != t.materia) cambios['materia'] = _materia;
    if (_prioridad != t.prioridad) cambios['prioridad'] = _prioridad;
    if (_fechaLimite != t.fechaLimite) {
      // El SDK de Firestore convierte DateTime a Timestamp al escribir.
      cambios['fechaLimite'] = _fechaLimite;
    }

    if (cambios.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No hay cambios que guardar.')));
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _errorGuardado = null);

    final error = await widget.controller.actualizarTarea(t.id!, cambios);
    if (!mounted) return;

    if (error == null) {
      navigator.pop();
      messenger.showSnackBar(const SnackBar(content: Text('Tarea actualizada.')));
    } else {
      // Se conserva lo que el usuario escribió y se muestra el motivo.
      setState(() => _errorGuardado = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) {
                final texto = v?.trim() ?? '';
                if (texto.length < 3) return 'Escribe al menos 3 caracteres.';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _materia,
              decoration: const InputDecoration(labelText: 'Materia'),
              items: [
                for (final m in materiasDisponibles)
                  DropdownMenuItem(value: m, child: Text(m)),
              ],
              onChanged: (v) => setState(() => _materia = v ?? _materia),
            ),
            const SizedBox(height: 16),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('Alta')),
                ButtonSegment(value: 2, label: Text('Media')),
                ButtonSegment(value: 3, label: Text('Baja')),
              ],
              selected: {_prioridad},
              onSelectionChanged: (s) => setState(() => _prioridad = s.first),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha límite'),
              subtitle: Text(
                '${_fechaLimite.day}/${_fechaLimite.month}/${_fechaLimite.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _elegirFecha,
            ),
            TextFormField(
              controller: _notasCtrl,
              decoration: const InputDecoration(labelText: 'Notas'),
              maxLines: 3,
              validator: (v) =>
                  (v ?? '').length > 200 ? 'Máximo 200 caracteres.' : null,
            ),
            if (_errorGuardado != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorGuardado!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) => FilledButton(
                onPressed: widget.controller.guardando ? null : _guardar,
                child: widget.controller.guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
