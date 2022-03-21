#!/bin/bash
rm -rf /var/www/html/composer.lock
composer update --ignore-platform-reqs --no-interaction --no-cache --optimize-autoloader
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf