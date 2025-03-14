#!/bin/bash

# Vérifier si les variables d'environnement sont définies
if [ -z "$MARIADB_NAME" ] || [ -z "$MARIADB_USER" ] || [ -z "$MARIADB_USER_PASSWORD" ] || [ -z "$MARIADB_ROOT_PASSWORD" ]; then
    echo "Erreur: Variables d'environnement requises non définies"
    exit 1
fi

# Initialiser les répertoires requis
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 777 /var/run/mysqld

# Démarrer MariaDB en arrière-plan pour la configuration initiale
service mariadb start

# Attendre que le serveur démarre
until mysqladmin ping -h localhost --silent; do
    echo "En attente du démarrage de MariaDB..."
    sleep 1
done

# Création de la base de données et des utilisateurs
# mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
# mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
# mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
# mysql -e "ALTER USER root@localhost IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
# mysql -e "FLUSH PRIVILEGES;"


echo "FLUSH PRIVILEGES;" | mysql -u root

echo "DROP USER IF EXISTS '$MARIADB_USER'@'%';" | mysql -u root

echo "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';" | mysql -u root

echo "GRANT ALL PRIVILEGES ON *.* TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';" | mysql -u root

echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';" | mysql -u root

echo "CREATE DATABASE IF NOT EXISTS $MARIADB_NAME;" | mysql -u root

echo "FLUSH PRIVILEGES;" | mysql -u root


# Arrêter MariaDB pour pouvoir le redémarrer avec la bonne commande
mysqladmin -u root -p${MARIADB_ROOT_PASSWORD} shutdown

# Démarrer MariaDB avec la commande correcte pour qu'il reste au premier plan
exec mysqld_safe