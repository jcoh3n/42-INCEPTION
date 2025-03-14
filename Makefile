NAME = inception

# Répertoires de données - utiliser un chemin relatif ou un chemin où vous avez les droits
DATA_DIR = $(HOME)/data
WORDPRESS_DATA = $(DATA_DIR)/wordpress
MARIADB_DATA = $(DATA_DIR)/mariadb

# Configuration
DOCKER_COMPOSE = srcs/docker-compose.yml

# Couleurs pour l'affichage
GREEN = \033[0;32m
RED = \033[0;31m
BLUE = \033[0;34m
YELLOW = \033[0;33m
RESET = \033[0m

# Règles
all: prepare up

# Crée les répertoires nécessaires pour les volumes
prepare:
	@echo "$(BLUE)Création des répertoires pour les volumes...$(RESET)"
	@mkdir -p $(WORDPRESS_DATA)
	@mkdir -p $(MARIADB_DATA)
	@echo "$(GREEN)Répertoires créés avec succès.$(RESET)"

# Construit les images Docker
# build:
# 	@echo "$(BLUE)Construction des images Docker...$(RESET)"
# 	@docker-compose -f $(DOCKER_COMPOSE) build
# 	@echo "$(GREEN)Images Docker construites avec succès.$(RESET)"

# Démarre les conteneurs
up:
	@echo "$(BLUE)Démarrage des conteneurs...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) up --build
	@echo "$(GREEN)Conteneurs démarrés avec succès.$(RESET)"

# Arrête les conteneurs
down:
	@echo "$(BLUE)Arrêt des conteneurs...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) down
	@echo "$(GREEN)Conteneurs arrêtés avec succès.$(RESET)"

# Affiche le statut des conteneurs
status:
	@echo "$(BLUE)Statut des conteneurs:$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) ps

# Nettoie les conteneurs et les images
clean: down
	@echo "$(BLUE)Suppression des conteneurs et des images...$(RESET)"
	@docker system prune -af --volumes
	@echo "$(GREEN)Nettoyage terminé.$(RESET)"

# Nettoie tout, y compris les volumes (réinitialisation complète)
fclean: clean
	@echo "$(YELLOW)Suppression des répertoires de données...$(RESET)"
	@rm -rf $(WORDPRESS_DATA)
	@rm -rf $(MARIADB_DATA)
	@echo "$(RED)Attention: Toutes les données ont été supprimées.$(RESET)"

# Réinitialise et reconstruit le projet
re: fclean all

.PHONY: all prepare build up down status clean fclean re