#!/bin/bash

# Wait for the database to be ready
echo "Waiting for the database to be ready..."
until mariadb -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" -e "SHOW DATABASES;" &>/dev/null; do
    echo "Database not ready. Retrying in 5 seconds..."
    sleep 5
done
echo "Database is ready."

# Download WordPress core files if not already present
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress core files..."
    wp --allow-root --path=/var/www/html core download
fi

# Proceed with WordPress initialization
wp --allow-root --path=/var/www/html core install \
    --url="${WP_HOME}" \
    --title="My WordPress Site" \
    --admin_user="admin" \
    --admin_password="strongpassword" \
    --admin_email="admin@example.com"

wp --allow-root --path=/var/www/html option update siteurl "${WP_HOME}"
wp --allow-root --path=/var/www/html option update home "${WP_HOME}"

echo "WordPress installation and configuration completed."
