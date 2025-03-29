# Base Image: Lightweight Alpine Linux
FROM alpine:3.20.6

# Install MariaDB and client tools
RUN apk update && apk add mariadb mariadb-client

# Copy custom MariaDB config
COPY ./conf/mariadb_config /etc/my.cnf.d/mariadb_config
RUN chmod 644 /etc/my.cnf.d/mariadb_config

# Copy and make the startup script executable
COPY ./tools/mariadb-script.sh /usr/local/bin/mariadb-script.sh
RUN chmod +x /usr/local/bin/mariadb-script.sh

# Expose MariaDB default port (3306)
EXPOSE 3306

# Run the script on container startup
ENTRYPOINT ["mariadb-script.sh"]
