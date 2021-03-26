#!/bin/bash
rm -rf /var/www/html/composer.lock
composer update --no-interaction --no-cache --optimize-autoloader
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf