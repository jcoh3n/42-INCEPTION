#!/bin/bash

# Crée le dossier /run/php s'il n'existe pas pour éviter une erreur de PHP-FPM
if [ ! -d "/run/php" ]; then
    mkdir /run/php
fi

if [ -z "${DOMAIN_NAME}" ] || [ -z "${WORDPRESS_ADMIN_USER}" ] || [ -z "${WORDPRESS_ADMIN_PASSWORD}" ]; then
    echo "Error: Required environment variables are not set."
    exit 1
fi

# Se place dans le dossier WordPress
cd /var/www/wordpress

# Configure WordPress automatiquement
wp core install \
    --url="${WORDPRESS_URL}" \
    --title="${WORDPRESS_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email
    --allow-root

# Crée un deuxième utilisateur
wp user create \
    "${WORDPRESS_USER2}" \
    "${WORDPRESS_USER2_EMAIL}" \
    --role="author" \
    --user_pass="${WORDPRESS_USER2_PASSWORD}"
    --allow-root

# Démarre PHP-FPM
php-fpm7.3 -F