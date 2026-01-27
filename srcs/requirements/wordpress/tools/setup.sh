#!/bin/bash

# Wait for MariaDB to be ready
sleep 10

# Download WP-CLI if not present
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

cd /var/www/html

# Download WordPress core
wp core download --allow-root --path=/var/www/html

# Create wp-config.php using .env variables
wp config create --allow-root \
    --dbname=$SQL_DATABASE \
    --dbuser=$SQL_USER \
    --dbpass=$SQL_PASSWORD \
    --dbhost=$SQL_HOST \
    --path=/var/www/html

# Install WordPress and create the Admin user
wp core install --allow-root \
    --url=$DOMAIN_NAME \
    --title=$WP_TITLE \
    --admin_user=$WP_ADMIN_USER \
    --admin_password=$WP_ADMIN_PASSWORD \
    --admin_email=$WP_ADMIN_EMAIL \
    --path=/var/www/html

# Create the second mandatory (regular) user
wp user create $WP_USER $WP_USER_EMAIL \
    --user_pass=$WP_USER_PASSWORD \
    --role=author \
    --allow-root \
    --path=/var/www/html

# Start PHP-FPM in the foreground
exec /usr/sbin/php-fpm7.4 -F
