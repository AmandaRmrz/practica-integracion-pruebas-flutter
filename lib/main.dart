import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/tarea_repository.dart';
import 'state/tareas_controller.dart';
import 'ui/lista_tareas_page.dart';
// Generado por `flutterfire configure` (visto en la semana 13).
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TareaUApp());
}

class TareaUApp extends StatefulWidget {
  const TareaUApp({super.key});

  @override
  State<TareaUApp> createState() => _TareaUAppState();
}

class _TareaUAppState extends State<TareaUApp> {
  late final TareasController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TareasController(TareaRepository())..iniciar();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TareaU',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: ListaTareasPage(controller: _controller),
    );
  }
}
