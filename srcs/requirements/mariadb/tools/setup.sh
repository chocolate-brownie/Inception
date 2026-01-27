#!/bin/bash

# Start MariaDB in the background temporarily to set up the database
service mariadb start

# Wait for it to wake up
sleep 5

# Create the database and the user defined in your .env
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Set the root password (mandatory for security)
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Refresh privileges and shut down the temporary background service
mysql -e "FLUSH PRIVILEGES;"
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

# Start MariaDB in the foreground (daemon off) to keep the container alive
exec mysqld_safe
