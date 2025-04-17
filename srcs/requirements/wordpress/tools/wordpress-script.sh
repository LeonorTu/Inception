#!/bin/sh

# ======================================================================
# WordPress Initialization Script for Docker Container
# This script sets up WordPress, configures it, and ensures it is ready
# to run with the provided environment variables.
# ======================================================================

echo "==> Setting up WordPress..."
# Increase PHP memory limit to 512M for better performance with WordPress
echo "memory_limit = 512M" >> /etc/php83/php.ini

# Change to the WordPress directory where files will be installed
cd /var/www/html

echo "==> Downloading WordPress client (WP-CLI) and renaming wp-cli.phar to wp..."
# Download WP-CLI (WordPress Command Line Interface) for managing WordPress
# Rename the downloaded file to 'wp' and move it to /usr/local/bin for global access
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp || { echo "Failed to download wp-cli.phar"; exit 1; }

# Make the WP-CLI executable
chmod +x /usr/local/bin/wp

echo "==> Checking if MariaDB is running before proceeding with WordPress setup..."
# Wait for MariaDB to be ready before proceeding
# Uses the mariadb-admin tool to ping the database server
mariadb-admin ping --protocol=tcp --host=mariadb -u $WORDPRESS_DATABASE_USER --password=$WORDPRESS_DATABASE_USER_PASSWORD --wait=300

# Check if WordPress is already configured (wp-config.php exists)
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "==> Downloading, Installing, Configuring WordPress files (core essentials)..."
    # Download the WordPress core files
    wp core download --allow-root

    # Create the WordPress configuration file (wp-config.php)
    # Uses environment variables for database credentials
    wp config create \
        --dbname=$WORDPRESS_DATABASE_NAME \
        --dbuser=$WORDPRESS_DATABASE_USER \
        --dbpass=$WORDPRESS_DATABASE_USER_PASSWORD \
        --dbhost=mariadb \
        --force

    # Install WordPress with the provided site details
    # Sets up the admin user and skips sending an email
    wp core install --url="$DOMAIN_NAME" --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --allow-root \
        --skip-email \
        --path=/var/www/html

    echo "==> Creating a WordPress user..."
    # Create a regular WordPress user with the provided credentials
    wp user create \
        --allow-root \
        $WORDPRESS_USER $WORDPRESS_USER_EMAIL \
        --user_pass=$WORDPRESS_USER_PASSWORD
else
    # If WordPress is already configured, skip the setup
    echo "==> WordPress is already downloaded, installed, and configured."
fi

# Set ownership of WordPress files to the www-data user and group
# This ensures proper permissions for the web server
chown -R www-data:www-data /var/www/html

# Set permissions for WordPress files and directories
# 755: Owner can read/write/execute, others can read/execute
chmod -R 755 /var/www/html/

echo "==> Running PHP-FPM in the foreground (to prevent the container from stopping)..."
# Start PHP-FPM in the foreground to keep the container running
php-fpm83 -F