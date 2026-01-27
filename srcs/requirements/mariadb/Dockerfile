# Use the required Debian version
FROM debian:bullseye

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Copy the configuration and the setup script
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/setup.sh /usr/local/bin/setup.sh

# Give execution permissions and create the runtime directory
RUN chmod +x /usr/local/bin/setup.sh && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

# Expose the MariaDB default port
EXPOSE 3306

# Run the setup script
ENTRYPOINT ["/usr/local/bin/setup.sh"]
