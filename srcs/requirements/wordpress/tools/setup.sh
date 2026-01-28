#!/bin/bash

# Wait for MariaDB
sleep 10

# Check if wp-config.php exists. If yes, skip installation to protect data.
if [ -f /var/www/html/wp-config.php ]; then
    echo "WordPress already installed."
else
    # Download WP-CLI
    if [ ! -f /usr/local/bin/wp ]; then
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    cd /var/www/html

    wp core download --allow-root

    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=$SQL_HOST

    # CRITICAL FIX: Add :8443 to the URL
    wp core install --allow-root \
        --url=${DOMAIN_NAME}:8443 \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL

    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --allow-root
fi

# Start PHP-FPM
exec /usr/sbin/php-fpm7.4 -F
