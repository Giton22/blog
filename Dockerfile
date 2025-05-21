# php dependencies
FROM composer:2.7 as vendor

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-interaction --no-scripts --no-autoloader --no-dev

# npm dependencies, build
FROM node:20-alpine as frontend

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

COPY . .
COPY --from=vendor /app/vendor /app/vendor
RUN npm run build

FROM php:8.2-fpm-alpine

# system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    mysql-client \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    unzip \
    curl \
    netcat-openbsd \
    git

# php extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# copy configuration files
COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/html

# install composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# copy app
COPY --chown=www-data:www-data . .
COPY --from=vendor --chown=www-data:www-data /app/vendor /var/www/html/vendor
COPY --from=frontend --chown=www-data:www-data /app/public/build /var/www/html/public/build

# generate composer autoloader and optimize
RUN composer dump-autoload --optimize --no-dev

# create storage dir structure
RUN mkdir -p storage/app/public storage/framework/cache \
    storage/framework/sessions storage/framework/testing storage/framework/views bootstrap/cache

# permissions
RUN chown -R www-data:www-data \
    storage \
    bootstrap/cache

# copy entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]