# Use Alpine Linux as the base image for a lightweight container
FROM alpine:3.20.6

# Install required packages:
# - mariadb-client: For database interaction
# - php83 and extensions: Required for running WordPress
# - wget: For downloading WordPress files
RUN apk update && apk add mariadb-client \
    php83 \
    php83-fpm \
    php83-phar \
    php83-curl \
    php83-mysqli \
    php83-iconv \
    php83-json \
    wget

# Copy the custom PHP-FPM configuration file
# This file configures PHP-FPM to work with WordPress
COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

# Create necessary directories for WordPress
# - /var/www/wp: Temporary directory for WordPress setup
# - /var/www/html: Final directory where WordPress will be served
RUN mkdir -p /var/www/wp /var/www/html

# Copy the WordPress initialization script to the container
# This script handles downloading, configuring, and setting up WordPress
COPY ./tools/wordpress-script.sh /usr/local/bin/wordpress-script.sh

# Make the WordPress initialization script executable
RUN chmod +x /usr/local/bin/wordpress-script.sh

# Create an unprivileged user for running PHP-FPM (security best practice)
# -D: Create user without a password
# -H: Don't create a home directory
# -s /sbin/nologin: No login shell
# -g www-data: Group name
# -G www-data: Additional group
RUN adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data

# Expose port 9000 for PHP-FPM
# This is the port NGINX will use to communicate with PHP-FPM
EXPOSE 9000

# Set the WordPress initialization script as the container's entrypoint
# This script will run when the container starts
CMD ["wordpress-script.sh"]