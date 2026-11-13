# Plantilla y Resultados de Pruebas — TareaU

## 1. Resumen de Ejecución
* **Total de casos ejecutados:** 11 casos (3 automatizados + 8 funcionales/integración)
* **Casos aprobados:** 11 / 11 (**100 % aprobado** tras corregir las incidencias)

## 2. Pruebas Automatizadas y Revisión Estática

| ID | Módulo | Descripción | Datos de entrada | Resultado esperado | Resultado obtenido | Evidencia |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **CP-01** | Código | Análisis estático del proyecto sin alertas | Ejecución de `flutter analyze` en el proyecto | 0 errores y 0 advertencias de código o imports. | `No issues found!` | `evidencias/pruebas-y-analisis/02-flutter-analyze-limpio.png` |
| **CP-02** | Modelo | Pruebas unitarias del modelo `Tarea` (`fromMap`, `toMap`, vencidas) | Ejecución de `flutter test test/unit/tarea_test.dart` | Convierte mapas/timestamps correctamente y detecta tareas vencidas. | `All tests passed!` | `evidencias/pruebas-y-analisis/02-flutter-test.png` |
| **CP-03** | Interfaz | Pruebas de widgets de `ListaTareasPage` (lista y estado vacío) | Ejecución de `flutter test test/widget/lista_tareas_test.dart` | Renderiza tarjetas con prioridad o muestra vista vacía según datos. | `All tests passed!` | `evidencias/pruebas-y-analisis/03-regresion-verde.png` |

## 3. Pruebas Funcionales y de Integración (Emulador + Firebase)

| ID | Módulo | Descripción | Datos de entrada | Resultado esperado | Resultado obtenido | Evidencia |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **CP-04** | Datos | Carga inicial de tareas pendientes desde Firestore | Colección `tareas` con 8 documentos, `Pendientes = true` | Mostrar las tareas pendientes ordenadas por fecha límite. | Cargaron los registros correctamente desde la colección `tareas`. | `evidencias/firebase/01-coleccion-tareas.png`<br>`evidencias/capturas-aplicacion/01-lista-principal.png` |
| **CP-05** | Datos | Filtrado combinado por materia y estado pendiente (activo/apagado) | Dropdown `materia = "Móviles"`, switch `Pendientes` en `true` y `false` | Filtrar por materia en ambos estados sin errores de consulta compuesta. | Funcionó en ambos estados tras habilitar los 3 índices compuestos en Firebase. | `evidencias/firebase/02-indice-compuesto.png`<br>`evidencias/capturas-aplicacion/02-filtro-y-vacio.png` |
| **CP-06** | Estados | Visualización de estado vacío al filtrar sin coincidencias | Materia sin tareas pendientes + `Pendientes = true` | Mostrar aviso claro cuando una combinación no tiene tareas. | Se mostró el estado vacío sin errores en pantalla. | `evidencias/capturas-aplicacion/02-filtro-y-vacio.png` |
| **CP-07** | Validación | Validación de título menor a 3 caracteres (`"Ab"`) | `titulo = "Ab"` (2 caracteres), `materia = "Redes"` | Bloquear guardado y mostrar mensaje de error en el campo. | Mostró `"Escribe al menos 3 caracteres."` y no envió datos. | `evidencias/capturas-aplicacion/03-validacion-titulo.png` |
| **CP-08** | Validación | Validación de selección obligatoria de materia al editar | `titulo = "Proyecto final"`, `materia = null` | Impedir guardar si el selector de materia no tiene valor válido. | El formulario validó correctamente el campo `materia`. | `evidencias/capturas-aplicacion/03-validacion-titulo.png` |
| **CP-09** | Datos | Edición de tarea con datos válidos y notificación SnackBar | `titulo = "Entrega laboratorio"`, `prioridad = "Alta"` | Guardar cambios en Firestore y mostrar `"Tarea actualizada."`. | Se actualizó en la app y apareció el aviso inferior. | `evidencias/capturas-aplicacion/04-tarea-actualizada.png` |
| **CP-10** | Persistencia | Sincronización en tiempo real en Firebase Console | Documento editado en `CP-09` consultado en Firestore | Reflejar en la nube los cambios guardados desde el emulador. | El documento se actualizó al instante en Firestore. | `evidencias/firebase/03-tarea-actualizada-firestore.png` |
| **CP-11** | Estados | Intento de guardado sin conexión a internet (Modo avión) | Emulador en **Modo avión** + pulsar **Guardar cambios** | Avisar fallo de red o tiempo agotado sin cerrar la app. | Mostró la alerta de error de conexión correctamente. | `evidencias/capturas-aplicacion/05-error-conexion.png` |