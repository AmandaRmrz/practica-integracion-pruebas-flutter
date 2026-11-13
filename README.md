# TareaU

Aplicación móvil hecha en **Flutter** y conectada a **Firebase Cloud Firestore** para organizar y dar seguimiento a tareas de la universidad.

## Demo en video
* **Video de funcionamiento completo:** [Ver demostración en YouTube](https://youtu.be/TU_ENLACE_AQUI)

## Estructura del proyecto (`semana16-integracion`)
* `lib/` — Código fuente de la aplicación (`data/`, `models/`, `state/`, `ui/`).
* `test/` — Pruebas unitarias (`unit/`) y de widgets (`widget/`).
* `evidencias/` — Capturas de respaldo organizadas en:
  * `capturas-aplicacion/` — Flujos de la app en emulador y manejo de errores.
  * `firebase/` — Colección `tareas`, índices compuestos y cambios sincronizados en Firestore.
  * `pruebas-y-analisis/` — Resultados de `flutter analyze` y `flutter test`.
* `docs/` — Documentación completa de integración y pruebas:
  * [01 - Declaración de Alcance](docs/01-declaracion-alcance.md)
  * [02 - Mapa de Flujos Críticos](docs/02-mapa-flujos-criticos.md)
  * [03 - Plantilla y Resultados de Pruebas](docs/03-plantilla-pruebas.md)
  * [04 - Registro de Incidencias](docs/04-registro-incidencias.md)
  * [05 - Reflexión Final](docs/05-reflexion-final.md)

## Comandos para ejecutar y verificar
```bash
flutter pub get
flutter analyze
flutter test
flutter run