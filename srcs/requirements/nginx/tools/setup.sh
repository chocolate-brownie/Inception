#!/bin/bash

# This is the Start-up Routine. Every time the container starts, this script 
# runs to generate a fresh security certificate and then turns the NGINX server "On".


# Create the folder for the SSL certificates
mkdir -p /etc/nginx/ssl

# Generate the self-signed certificate
# -nodes: keeps the private key unencrypted so NGINX can start automatically
openssl req -x509 -nodes -out /etc/nginx/ssl/mgodawat.crt -keyout /etc/nginx/ssl/mgodawat.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=mgodawat.42.fr"

# Start NGINX in the foreground to keep the container running
nginx -g "daemon off;"
