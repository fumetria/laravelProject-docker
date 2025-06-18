#!/bin/bash

until nc -z database 3306; do
  echo "Esperando a MySQL..."
  sleep 2
done

php artisan migrate:fresh --seed
php artisan storage:link
cp -r public/img/covers/ storage/app/public/covers/
cp -r public/img/authors/ storage/app/public/authors/

php artisan serve --host=0.0.0.0 --port=8000
