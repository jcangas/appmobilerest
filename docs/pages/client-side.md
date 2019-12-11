<style type="text/css"> h1 { counter-reset: h1counter 3}</style>

## Creacion del proyecto cliente

* Escoger plantilla Tabbed with Navigation
* Vistazo a los ficheros generados
* Configurar la salida del compilador
* Reorganización de los ficheros

## Interfaz de usuario con FireMonkey

* FireMonkey: TL;DR
* Creación de la interfaz
* Presentacion: Factor de forma y Estilos
* Importancia de UX profesional

## Completando la UX: LiveBinding

* Conceptos básicos de LB
* El componente `TPrototypeBindSource`

## Obteniendo datos del servidor REST

* Server Proxies
* Obteniendo datos en JSON:
  * Conectando con `TRESTClient`
  * Obtener un resource `TRESTRequest`
  * `TRESTResponse`: really, George?
* Si, también necesitas log en el cliente
  
## De JSON a models

* ¿Por qué quieres hacer esto?
* JSONUtils, client side vs

## Desarrollo multiplataforma

* Configuración del proyecto. Build groups
* Simuladores? Mejor Netflix :joy:
* Installar PAServer
* Conection profile
* SDK Manager
* Cuidado con la memoria
  
## Despliegue de la aplicación

* Provisioning
  * Desarrollo vs vendor store
  * Registro como desarrollador
  * Obtención de certificados y otras torturas
  
* Desplegando ficheros de aplicacion
  * Sandbox
  * Controlar rutas en la aplicación

## Notas sobre la arquitectura 

* Mejor extender a MVC + Patrones (Repository, UseCase, UoW)
* Atención a la coordinación de hilos
* Aprovechar multitarea: `unit System.Threading;`
* Tener buen Log
