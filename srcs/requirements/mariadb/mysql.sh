#!/bin/bash

# Vérifier si les variables d'environnement sont définies
if [ -z "$MARIADB_NAME" ] || [ -z "$MARIADB_USER" ] || [ -z "$MARIADB_USER_PASSWORD" ] || [ -z "$MARIADB_ROOT_PASSWORD" ]; then
    echo "Erreur: Variables d'environnement requises non définies"
    exit 1
fi

exec mysqld_safe &

# Attendre que le serveur démarre
until mysqladmin ping --silent; do
    echo "En attente du démarrage de MariaDB..."
    sleep 1
done

# Création de la base de données et des utilisateurs
mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${MARIADB_NAME}\`;"
mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS \`${MARIADB_USER}\`@'localhost' IDENTIFIED BY '${MARIADB_USER_PASSWORD}';"
mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON \`${MARIADB_NAME}\`.* TO \`${MARIADB_USER}\`@'%';"
mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "ALTER USER root@localhost IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';"
mysql -u root -p${MARIADB_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"


# echo "FLUSH PRIVILEGES;" | mysql -u root

# echo "DROP USER IF EXISTS '$MARIADB_USER'@'%';" | mysql -u root

# echo "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';" | mysql -u root

# echo "GRANT ALL PRIVILEGES ON *.* TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';" | mysql -u root
# echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';" | mysql -u root

# echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';" | mysql -u root

# echo "CREATE DATABASE IF NOT EXISTS $MARIADB_NAME;" | mysql -u root

# echo "FLUSH PRIVILEGES;" | mysql -u root


# Arrêter MariaDB pour pouvoir le redémarrer avec la bonne commande
mysqladmin -u root -p${MARIADB_ROOT_PASSWORD} shutdown

echo "MariaDB database and user were created successfully! "

# Démarrer MariaDB avec la commande correcte pour qu'il reste au premier plan
exec mysqld_safe