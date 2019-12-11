<style type="text/css"> h1 { counter-reset: h1counter 2}</style>

## Creación del proyecto servidor

* DatasnapREST server wizard
* Escoger FM MainForm (facilita tener Log)
* Escoger "simplified disptacher"
* Vistazo a los ficheros generados
* Configurar la salida del compilador
* Reorganización de los ficheros
* Testeo con Postman
  
## La Base de Datos

* Scripts para crear la BD: migrations
* Scripts para alimentar la BD: DBSeeds
* FireDac Explorer. Conexión a datos con FireDac

## Servicios con DataSnap

* Moódulo de OrderService: `{$METHODINFO ON}`
* Registrar la factoria: `TDSServerCLass`
* Devolviendo JSON: Server.JSONUtils.pas. Ventajas
* Apuntes sobre Autenticación y Roles

## Control de la rutas

* El componente `TDSRESTWebDispcthcer`
* Propiedades `DSContext` y `RESTContext`
* Eventos `OnParseRequest` y `OnParsingRequest`
* Convenios REST y mapeo de rutas
  
## Notas técnicas sobre la arquitectura 

* Mejor extender a MVC + Patrones (Repository, UseCase, UoW)
* Atención a la coordinación de hilos
* Aprovechar multitarea: `unit System.Threading;`
* Tener buen Log
