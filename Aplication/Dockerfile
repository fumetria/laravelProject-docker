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

