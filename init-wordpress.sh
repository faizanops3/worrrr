#!/bin/bash

# Wait for the database to be ready
echo "Waiting for the database to be ready..."
until mysql -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" -e "SHOW DATABASES;" &>/dev/null; do
    sleep 2
done
echo "Database is ready."

# Sync database URLs with environment variables
echo "Updating site URLs in the database..."
wp --allow-root --path=/var/www/html option update siteurl "${WP_HOME}"
wp --allow-root --path=/var/www/html option update home "${WP_HOME}"

# Fix mixed content issues
echo "Replacing old URLs in the database..."
wp --allow-root --path=/var/www/html search-replace "http://${WORDPRESS_DB_HOST}" "${WP_HOME}" --all-tables --quiet

echo "WordPress configuration completed successfully."
