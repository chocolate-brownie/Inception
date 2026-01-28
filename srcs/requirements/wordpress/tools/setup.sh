#!/bin/bash

# 1. PERMANENT FIX: Active Database Check
# Instead of sleeping 10 seconds, we ping the MariaDB service every 2 seconds.
# This ensures WordPress only starts when the database is truly ready.
echo "WordPress: Waiting for MariaDB at ${SQL_HOST}..."
while ! mariadb-admin ping -h"$SQL_HOST" --silent; do
    sleep 2
done
echo "WordPress: MariaDB is up and running!"

# 2. Check for Persistence
# We only install WordPress if wp-config.php is missing.
if [ -f /var/www/html/wp-config.php ]; then
    echo "WordPress: Already installed. Skipping setup to protect your posts."
else
    echo "WordPress: Starting fresh installation..."

    cd /var/www/html

    # 3. Ensure WP-CLI is available
    if [ ! -f /usr/local/bin/wp ]; then
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    # 4. Download and Configure
    # --force allows downloading even if the volume has files (like lost+found)
    wp core download --allow-root --force

    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=$SQL_HOST

    # 5. Core Installation with Port Fix
    # Adding :8443 here is what stops the 'Unable to Connect' redirect loop.
    wp core install --allow-root \
        --url=${DOMAIN_NAME}:8443 \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL

    # 6. Create regular user
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --allow-root

    # 7. Force SSL and Home URL settings
    wp config set FORCE_SSL_ADMIN true --raw --allow-root
    wp config set WP_HOME "https://${DOMAIN_NAME}:8443" --allow-root
    wp config set WP_SITEURL "https://${DOMAIN_NAME}:8443" --allow-root

    # 8. Set correct permissions
    # This ensures NGINX (www-data) can read the files your script just created.
    chown -R www-data:www-data /var/www/html
    
    echo "WordPress: Installation completed successfully!"
fi

# 9. Launch PHP-FPM
# The '-F' flag keeps the process in the foreground so the container stays 'Up'.
echo "WordPress: Launching PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
