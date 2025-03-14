FROM debian:bullseye
# Met à jour les paquets et installe les dépendances nécessaires
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    wget \
    php \
    php-fpm \
    php-mysql \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Télécharge et installe WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Télécharge et extrait WordPress
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www && \
    cd /var/www && \
    tar -xzf wordpress-6.0-fr_FR.tar.gz && \
    rm wordpress-6.0-fr_FR.tar.gz

# Configure les permissions
RUN chown -R www-data:www-data /var/www/wordpress

# Copie le script d'auto-configuration
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

# Configure php-fpm
RUN mkdir -p /run/php

# Définit le point d'entrée
ENTRYPOINT ["/usr/local/bin/auto_config.sh"]

# ENTRYPOINT ["sleep", "infinity"]