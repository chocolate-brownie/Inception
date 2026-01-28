#!/bin/bash

# Ensure the runtime directory exists for the socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# 1. Check if the database is already initialized (Persistence check)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB: First time setup. Initializing database..."
    
    # Initialize the basic system tables
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # 2. Create a temporary SQL file with all setup commands
    cat << EOF > /tmp/init_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # 3. Apply configuration using the correct path for Debian Bullseye
    echo "MariaDB: Applying configuration..."
    /usr/sbin/mariadbd --user=mysql --bootstrap < /tmp/init_db.sql
    rm -f /tmp/init_db.sql
    echo "MariaDB: Configuration applied successfully!"
else
    echo "MariaDB: Volume already contains data. Skipping initialization."
fi

# 4. Start MariaDB in the foreground
echo "MariaDB: Starting daemon..."
exec /usr/bin/mysqld_safe --datadir=/var/lib/mysql
