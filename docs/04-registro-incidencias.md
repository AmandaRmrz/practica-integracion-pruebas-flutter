# Registro de Incidencias — TareaU

## INC-001: Faltaba validar el campo de materia al editar una tarea
* **Severidad:** Media
* **Prioridad:** Alta
* **Origen:** Validación de UI / Formulario (`lib/ui/editar_tarea_page.dart`)
* **Estado:** Corregida y re-probada
* **Causa:** El formulario validaba la longitud del título (`>= 3` caracteres), pero el `DropdownButtonFormField` de materia no tenía un `validator` que asegurara que se enviara una materia válida.
* **Corrección:** Se agregó la función `validator` directamente en el campo desplegable de materia dentro de `EditarTareaPage` para exigir una opción válida antes de guardar.
* **Re-prueba:** Se ejecutó `flutter analyze` sin errores y se volvió a probar el formulario en el emulador (`evidencias/capturas-aplicacion/03-validacion-titulo.png`).

---

## INC-002: Error al listar y filtrar tareas por falta de índices compuestos en Firestore
* **Severidad:** Alta
* **Prioridad:** Crítica
* **Origen:** Base de datos en la nube / Consultas Firestore (`lib/data/tarea_repository.dart`)
* **Estado:** Corregida y re-probada
* **Causa:** Cloud Firestore exige índices compuestos cuando una consulta combina filtros de igualdad (`where`) con un ordenamiento (`orderBy`), devolviendo `FAILED_PRECONDITION` al abrir la lista, filtrar por materia con pendientes activos o filtrar por materia con el switch de pendientes apagado.
* **Corrección:** Se crearon y habilitaron tres índices compuestos en Firebase Console para la colección `tareas`:
  1. `completada` (Ascendente) + `fechaLimite` (Ascendente)
  2. `completada` (Ascendente) + `materia` (Ascendente) + `fechaLimite` (Ascendente)
  3. `materia` (Ascendente) + `fechaLimite` (Ascendente)
* **Re-prueba:** Tras el error inicial registrado en `evidencias/capturas-aplicacion/01-error-indice-firestore.png`, se habilitaron los índices (`evidencias/firebase/02-indice-compuesto.png`) y la app cargó las tareas filtradas tanto con el switch activo como apagado (`evidencias/capturas-aplicacion/02-filtro-y-vacio.png`).

---

## INC-003: Duplicación de tareas iniciales al reiniciar la aplicación
* **Severidad:** Baja
* **Prioridad:** Media
* **Origen:** Configuración de inicialización / Datos de prueba (`lib/main.dart`)
* **Estado:** Corregida y re-probada
* **Causa:** La función `sembrarDatos()` utiliza `.add()` generando IDs nuevos cada vez que arranca la aplicación o se hace *Hot Restart*, por lo que al dejarla activa en `main()` se duplicaban los 8 registros base en Firestore.
* **Corrección:** Se ejecutó la carga inicial una sola vez para poblar la colección `tareas`, se limpiaron los documentos repetidos en Firebase Console y se eliminó tanto `await sembrarDatos();` como su importación de `lib/main.dart`.
* **Re-prueba:** Se reinició la aplicación varias veces y se confirmó en Firebase Console que los documentos no se vuelven a duplicar (`evidencias/firebase/01-coleccion-tareas.png`).