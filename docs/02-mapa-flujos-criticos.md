# Mapa de Flujos Críticos — TareaU

## Flujos principales que se probaron

| Flujo | Qué hace en la app | Por dónde pasa | Posible fallo |
| :--- | :--- | :--- | :--- |
| **1. Cargar tareas al abrir** | Muestra las tareas pendientes ordenadas por fecha límite. | `ListaTareasPage` → `TareaRepository` → Firestore | Si falta el índice en Firebase, no carga la lista y muestra aviso de error. |
| **2. Filtrar por materia y estado** | Filtra las tareas según la materia elegida con o sin el switch de pendientes. | Dropdown de materias + Switch → Firestore | Requiere índices compuestos distintos según si el switch de pendientes está activo o apagado. |
| **3. Editar y validar tarea** | Permite cambiar datos de una tarea revisando que sean válidos. | `ListaTareasPage` → `EditarTareaPage` → Firestore | Si no se valida bien el formulario, se pueden guardar datos incompletos. |
| **4. Guardar sin internet** | Intenta actualizar una tarea cuando el teléfono está en modo avión. | `EditarTareaPage` (sin red) → Firestore | La app podría quedarse cargando indefinidamente si no maneja el tiempo de espera. |

## Resumen del recorrido de los datos

```mermaid
flowchart TD
    A[Pantalla Principal<br/>ListaTareasPage] -->|Consulta stream| B[TareaRepository]
    B -->|Usa los 3 índices compuestos| C[(Cloud Firestore<br/>Colección: tareas)]
    
    A -->|Tocar una tarea| D[Pantalla de Edición<br/>EditarTareaPage]
    D --> E{¿Formulario válido?<br/>Título ≥ 3 letras y materia}
    
    E -->|No| F[Muestra error en rojo<br/>No guarda en la nube]
    E -->|Sí| G[Intenta actualizar en Firestore]
    
    G -->|Con internet| H[SnackBar: 'Tarea actualizada.']
    G -->|Sin internet / Modo avión| I[Muestra aviso de error de conexión]