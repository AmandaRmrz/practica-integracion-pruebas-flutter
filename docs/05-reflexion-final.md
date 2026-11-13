# Reflexión Final — Proyecto TareaU

**¿Qué prueba habría evitado mi error más costoso?**

El error que más tiempo me quitó fue que la app dejara de cargar las tareas y los filtros por materia al faltarle los índices compuestos en Firestore (`INC-002`). Si hubiera hecho desde el inicio una prueba rápida de integración conectada a la base de datos real (o al emulador local de Firebase) justo cuando escribí la consulta con `where` y `orderBy`, me habría saltado el error `FAILED_PRECONDITION` al instante, sin tener que esperar a probar toda la pantalla en el emulador. Correr esa prueba básica cada vez que tocaba las consultas me habría ahorrado estar revisando el código de la interfaz buscando un fallo que en realidad estaba en la configuración de Firebase.

## Qué aprendí con esta práctica
Al conectar la aplicación con Cloud Firestore me di cuenta de que aunque el código compile bien en Flutter, al trabajar con consultas reales en la nube aparecen detalles como los índices compuestos de Firebase (`INC-002`), que son obligatorios cuando se filtran datos y se ordenan al mismo tiempo.

También vi lo útil que es tener pruebas unitarias y de widgets antes de probar en el emulador, porque permiten verificar rápido si los modelos y las pantallas responden bien sin tener que estar metiendo datos a mano cada vez que se cambia algo.

## Sobre el orden del repositorio
Mantener todo separado por carpetas (`test/`, `evidencias/`, `docs/`) dentro de la rama `semana16-integracion` ayuda bastante a no perderse entre el código de la app, las capturas de pantalla y los reportes de errores que se fueron corrigiendo.

## Qué se podría mejorar después
* Agregar pruebas automáticas de integración usando los emuladores locales de Firebase para no depender de tener internet al probar.
* Mejorar el manejo visual cuando se pierde la conexión para avisar desde la pantalla principal que la app está trabajando sin red.