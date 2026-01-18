# Use Debian Bullseye (Penultimate stable version)
FROM debian:bullseye

# Install NGINX and OpenSSL
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Copy custom NGINX configuration
COPY conf/nginx.conf /etc/nginx/sites-available/default

# Copy the setup script and make it executable
COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Expose ONLY port 443
EXPOSE 443

# Run the setup script to generate SSL and start NGINX
CMD ["/usr/local/bin/setup.sh"]
