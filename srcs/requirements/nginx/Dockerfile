# Base Image: Lightweight Alpine Linux for minimal container size
FROM alpine:3.20.6

# Install required packages:
# - nginx: Web server for serving WordPress content
# - openssl: For SSL certificate generation
RUN apk update && apk add nginx openssl

# Declare port 443 (HTTPS) to be used
# This documents that the container will use this port
EXPOSE 443

# Create directory for SSL certificate and private key
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate for HTTPS:
# -x509: Create a self-signed certificate (no CA needed)
# -nodes: No passphrase protection for the private key
# -out: Location to store the public certificate
# -keyout: Location to store the private key
# -subj: Subject information for the certificate (location/organization)
RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/public_certificate.crt \
    -keyout /etc/nginx/ssl/private.key \
    -subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=jtu.42.fr"

# Create unprivileged user for running nginx (security best practice):
# -D: Create user without a password
# -H: Don't create a home directory
# -s /sbin/nologin: No login shell
# -g www-data: Group name
# -G www-data: Additional group
RUN adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data

# Copy custom nginx configuration from host to container
# and set appropriate read permissions
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
RUN chmod 644 /etc/nginx/nginx.conf

# Start NGINX with specific parameters:
# -c: Specify configuration file path
# -g "daemon off;": Run in foreground (required for Docker)
CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]