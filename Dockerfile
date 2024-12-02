FROM wordpress:latest

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Install MariaDB client
RUN apt-get update \
    && apt-get install -y mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the initialization script
COPY init-wordpress.sh /usr/local/bin/init-wordpress.sh

# Set entrypoint script permissions
RUN chmod +x /usr/local/bin/init-wordpress.sh

# Run the initialization script on container startup
CMD ["bash", "/usr/local/bin/init-wordpress.sh"]
