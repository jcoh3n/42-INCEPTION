#!/bin/bash
# Crée le dossier /run/php s'il n'existe pas pour éviter une erreur de PHP-FPM

sleep 10

if [ ! -d "/run/php" ]; then
  mkdir /run/php
fi

if [ -z "${DOMAIN_NAME}" ] || [ -z "${WORDPRESS_ADMIN_USER}" ] || [ -z "${WORDPRESS_ADMIN_PASSWORD}" ]; then
  echo "Error: Required environment variables are not set."
  exit 1
fi

# Se place dans le dossier WordPress
cd /var/www/wordpress

until mysql -h "mariadb" -u "$MARIADB_USER" -p"$MARIADB_USER_PASSWORD" -e "SHOW DATABASES;" > /dev/null 2>&1; do
	echo "Database is not ready. Retrying in 5 seconds..."
	sleep 5
done

echo "Database is ready"


if [ ! -f "/var/www/wordpress/wp-config.php" ]; then

  echo "WordPress is not installed. Installing..."
  wp core download --allow-root

  wp core config \
      --dbhost="$MARIADB_HOST" \
      --dbname="$MARIADB_NAME" \
      --dbuser="$MARIADB_USER" \
      --dbpass="$MARIADB_USER_PASSWORD" \
      --allow-root

  # Configure WordPress automatiquement
  wp core install --allow-root \
    --url="${WORDPRESS_URL}" \
    --title="${WORDPRESS_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email

  # Crée un deuxième utilisateur
  wp user create --allow-root \
    "${WORDPRESS_USER2}" \
    "${WORDPRESS_USER2_EMAIL}" \
    --role="author" \
    --user_pass="${WORDPRESS_USER2_PASSWORD}"
fi

echo "WordPress is installed"

# Démarre PHP-FPM (ajustez la version selon celle installée dans votre container)
# Essayez l'une de ces commandes en fonction de votre configuration

echo "starting wordpress"



exec php-fpm7.4 -F --allow-to-run-as-root
# OU si cela ne fonctionne pas, essayez:
# php-fpm7 -F
# OU
# php-fpm8 -F