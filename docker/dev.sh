#!/bin/bash
set -e

composer install
npm install

php-fpm -D

nginx

# check for .env
if [ ! -f .env ]; then
    echo "creating .env"
    cp .env.example .env
    
    # check for .env.docker and update the env vars
    if [ -f .env.docker ]; then
        echo "apply env vars from .env.docker"
        while IFS='=' read -r key value || [ -n "$key" ]; do
            if [[ ! $key =~ ^# && -n $key && -n $value ]]; then
                env_value="${!key}"
                if [ -z "$env_value" ]; then
                    sed -i "s|^$key=.*|$key=$value|" .env 2>/dev/null || echo "$key=$value" >> .env
                fi
            fi
        done < .env.docker
    fi
    
    # update database connection details if set as env vars
    if [ -n "$DB_HOST" ]; then
        sed -i "s/DB_HOST=.*/DB_HOST=$DB_HOST/" .env
    fi
    if [ -n "$DB_PORT" ]; then
        sed -i "s/DB_PORT=.*/DB_PORT=$DB_PORT/" .env
    fi
    if [ -n "$DB_DATABASE" ]; then
        sed -i "s/DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/" .env
    fi
    if [ -n "$DB_USERNAME" ]; then
        sed -i "s/DB_USERNAME=.*/DB_USERNAME=$DB_USERNAME/" .env
    fi
    if [ -n "$DB_PASSWORD" ]; then
        sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" .env
    fi
fi

# generate app key
if ! grep -q "APP_KEY=base64:.\+" .env; then
    php artisan key:generate --no-interaction
fi

#
# migrations
#

if [ "${RUN_MIGRATIONS:-false}" = "true" ]; then
    php artisan migrate --force --no-interaction
    
    if [ $? -ne 0 ]; then
        echo "db migration failed"
        # might be a non-critical error, so continue
    else
        echo "migrations completed successfully"
    fi
fi

#
# seeders
#

if [ "${RUN_SEEDERS:-false}" = "true" ]; then
    php artisan db:seed --force --no-interaction
    
    if [ $? -ne 0 ]; then
        echo "db seeders failed"
    else
        echo "seeders completed successfully"
    fi
fi

# create storage link if it doesn't exist
if [ ! -L /var/www/html/public/storage ]; then
    php artisan storage:link --no-interaction
fi

# fix permissions
chown -R www-data:www-data /var/www/html/storage
chown -R www-data:www-data /var/www/html/bootstrap/cache

echo "laravel init complete"

# start dev server
composer run dev