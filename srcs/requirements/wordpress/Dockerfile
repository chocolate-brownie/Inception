FROM debian:bullseye

# Install PHP-FPM and MariaDB client (to talk to the DB)
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create the directory for PHP-FPM to run
RUN mkdir -p /run/php

# Copy the PHP-FPM configuration
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copy the setup script
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Expose port 9000
EXPOSE 9000

# Set the working directory to where WP files live
WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/setup.sh"]
