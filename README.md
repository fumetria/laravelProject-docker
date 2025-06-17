# Library App + Docker

## Introducción
El siguiente proyecto ha sido creado con el fin de entender el funcionamiento del framework Laravel junto con el kit Laravel Jetstream (Inertia + Vue) y como base datos usaremos mySQL.
<p align="center">
  <a href="https://skillicons.dev">
    <img src="https://skillicons.dev/icons?i=docker,laravel,vue,mysql,tailwind&theme=light" />
  </a>
</p> 

En este repositorio vamos a crear un contenedor de Docker donde alojaremos todas las dependencias necesarias para poder arrancar-lo con todo el proyecto de Library App ([Link a proyecto](https://github.com/fumetria/laravelProject.git)).

## ¿Qué es Library App?

Library App es un aplicación para la gestión de una biblioteca. Esta enfocada en tener un sistema organizado con los libros de los que se dispone, gestionar los préstamos y devoluciones de libros y dar un servicio de consulta para los usuarios que busquen la ubicación de algún libro que quieran alquilar.

## Instalación

### Pasos previos

Lo primero de todo, debemos descargarnos el proyecto Library App en nuestro proyecto, con lo cual vamos a la carpeta *Aplication*  y introducimos el siguiente comando:
```bash
git clone https://github.com/fumetria/laravelProject.git /src
```

Ahora, volvemos a nuestra directorio raíz para modificar *.env.docker.example* donde introduciremos los datos de las variables de nuestro servicio de *mysql*:

```bash
MYSQL_ROOT_USER=root
MYSQL_ROOT_PASSWORD=example_password
MYSQL_HOST=database
MYSQL_DATABASE=library_db
MYSQL_USER=user
MYSQL_PASSWORD=example_password
MYSQL_PORT="3306:3306"
APP_PORT="8000:8000"
```

Una vez tengamos añadido nuestros datos procederemos a convertirlo en nuestro archivo .env:

```bash
cp .env.docker.example .env
```

Con este archivo *.env*, nuestro *docker-compose* cogera los datos para las variables que tenemos dentro.
