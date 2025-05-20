#!/bin/bash
set -e

php-fpm -D

nginx

npm i && npm run dev -- --host