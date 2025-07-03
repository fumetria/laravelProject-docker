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

```Dotenv
MYSQL_ROOT_USER=root
MYSQL_ROOT_PASSWORD=example_password
MYSQL_HOST=database
MYSQL_DATABASE=library_db
MYSQL_USER=user
MYSQL_PASSWORD=example_password
MYSQL_PORT="3306"
APP_PORT="8000"
```

Una vez tengamos añadido nuestros datos procederemos a convertirlo en nuestro archivo .env:

```bash
cp .env.docker.example .env
```
Con este archivo *.env*, nuestro *docker-compose* cogera los datos para las variables que tenemos dentro.

Ahora vamos a crear nuestro archivo *.env* para nuestro proyecto laravel.
```bash
cd Aplication/
cp .env.project.example src/.env
```
Modificaremos los datos relacionados con nuestra base de datos y para que coincidan con nuestro archivo *.env* de nuestro contenedor de Docker,
```Dotenv
DB_CONNECTION=mysql
DB_HOST=database
DB_PORT=3306
DB_DATABASE=library_db
DB_USERNAME=your_user
DB_PASSWORD=your_password
```

### Arrancar contenedor en Docker

Para arrancar nuestro contenedor ejecutaremos el siguiente comando:

```bash
docker-compose up
```

#### Componentes

Nuestro contenedor de Docker se compone de varias partes, empezando por nuestro *docker-compose.yml*:
```yml
services:
  database:
    image: mysql:latest
    environment:
      - MYSQL_ROOT_USER=${MYSQL_ROOT_USER}
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
    ports:
      - ${MYSQL_PORT}:3306
    volumes:
      - db_volume:/var/lib/mysql
    networks:
      - app-network

  app:
    build:
      context: ./Aplication
    ports:
      - ${APP_PORT}:${APP_PORT}
    environment:
      DB_HOST: ${MYSQL_HOST}
      DB_NAME: ${MYSQL_DATABASE}
      DB_USER: ${MYSQL_USER}
      DB_PASSWORD: ${MYSQL_PASSWORD}
    networks:
      - app-network
    depends_on:
      - database
    command: [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=${APP_PORT}" ]
  
  adminMySQL_contenidor:
    image: phpmyadmin/phpmyadmin
    depends_on:
      - database
    ports:
      - "9200:80"
    environment:
      PMA_HOST: ${MYSQL_HOST}
    networks:
      - app-network

volumes:
  db_volume:

networks:
  app-network:
    driver: bridge
```
Dentro de Aplication tenemos nuestro Dockerfile que construirá nuestra aplicación de Laravel:

```Dockerfile

FROM php:8.4-alpine

RUN apk update &&  apk add bash \
    curl unzip libpng-dev oniguruma-dev libxml2-dev zlib npm netcat-openbsd
RUN docker-php-ext-install pdo pdo_mysql gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /project

COPY ./src /project

RUN composer install \
    && npm install \
    && npm run build \
    && php artisan key:generate

EXPOSE 8000
COPY entrypoint.sh /project/entrypoint.sh
RUN chmod +x /project/entrypoint.sh
ENTRYPOINT ["/project/entrypoint.sh"]
```

Acompañando a nuestro Dockerfile, tenemos un script que hará que nuestra aplicación espere hasta que nuestro servicio de mysql este en marcha para arrancar la aplicación.

```shell
#!/bin/bash

until nc -z database 3306; do
  echo "Esperando a MySQL..."
  sleep 2
done

#Eliminar estas lineas si no queremos poblar la base de datos
php artisan migrate --seed
php artisan storage:link
#------------------------------------------------------------

cp -r public/img/covers/ storage/app/public/covers/
cp -r public/img/authors/ storage/app/public/authors/

php artisan serve --host=0.0.0.0 --port=8000
```

En este script, mediante el comando *nc* de netcat, escuchamos el puerto de nuestra base de datos hasta que nos de conexión, una vez conectado, activamos nuestra aplicación.


