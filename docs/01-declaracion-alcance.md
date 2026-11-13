# Declaración de Alcance — Proyecto TareaU

| Módulo / servicio | ¿Aplica? | Observación |
| :--- | :---: | :--- |
| Autenticación | ☐ | No se implementa inicio de sesión ni registro de usuarios en esta app. |
| Base de datos (Firestore / Realtime DB) | ☑ | Sí aplica. Se usa Cloud Firestore (colección `tareas`) para listar, filtrar y actualizar tareas en tiempo real. |
| Almacenamiento (Storage) | ☐ | No se suben archivos ni imágenes a Firebase Storage. |
| Notificaciones push (FCM) | ☐ | No se utilizan notificaciones push en este proyecto. |
| API REST externa | ☐ | Todos los datos se consumen directamente desde Cloud Firestore sin servicios REST externos. |
| Otros (Analytics, Crashlytics, Remote Config...) | ☐ | No se configuraron servicios adicionales fuera de Cloud Firestore. |