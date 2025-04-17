#!/bin/sh

# ======================================================================
# MariaDB Initialization Script for Docker Container
# This script handles first-time setup and persistent restarts
# ======================================================================

echo "==> Setting up MariaDB directory..."
# Set proper permissions on database directory (755 = owner:rwx, group:r-x, others:r-x)
chmod -R 755 /var/lib/mysql

# Create directory for the Unix socket file that MariaDB uses for local connections
mkdir -p /run/mysqld

# Set mysql user as owner of the database and socket directories
# This is a security best practice to avoid running database as root
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Check if this is the first time the container is running
# If the mysql system database doesn't exist, we need to initialize MariaDB
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "==> Initializing MariaDB system tables..."
    # Create system tables and initial database structure
    # --basedir: MariaDB installation directory
    # --user: Run as mysql user (security)
    # --datadir: Where database files are stored (mapped to persistent volume)
    mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql >/dev/null

    echo "==> Creating WordPress database and user..."
    # Bootstrap mode enables running SQL commands during initialization
    # This avoids the need to start/stop the server temporarily
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD";
CREATE DATABASE $WORDPRESS_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER $WORDPRESS_DATABASE_USER@'%' IDENTIFIED BY "$WORDPRESS_DATABASE_PASSWORD";
GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE_NAME.* TO $WORDPRESS_DATABASE_USER@'%';
FLUSH PRIVILEGES;
EOF

else
    # On container restarts, the database is already initialized
    # Skip initialization to preserve existing data
    echo "==> MariaDB is already installed. Database and users are configured."
fi

echo "==> Starting MariaDB server..."
# Start MariaDB with custom configuration and replace this shell process
# Using exec ensures proper signal handling (container can be stopped cleanly)
exec mysqld --defaults-file=/etc/my.cnf.d/mariadb.cnf
