#!/bin/bash

# Script de configuration automatique pour LifeCompanion
# Compatible avec macOS et Linux

set -e

echo "🎯 Configuration de LifeCompanion - Assistant Environnemental Personnel"
echo "=================================================================="

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonctions utilitaires
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Vérification des prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    # Vérifier Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker n'est pas installé. Veuillez l'installer d'abord."
        exit 1
    fi
    
    # Vérifier Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose n'est pas installé. Veuillez l'installer d'abord."
        exit 1
    fi
    
    # Vérifier PHP (optionnel pour développement local)
    if command -v php &> /dev/null; then
        PHP_VERSION=$(php -v | grep -oE 'PHP [0-9]+\.[0-9]+' | head -1)
        log_info "PHP détecté: $PHP_VERSION"
    else
        log_warning "PHP non détecté. Utilisation de Docker pour le backend."
    fi
    
    # Vérifier Composer (optionnel)
    if command -v composer &> /dev/null; then
        COMPOSER_VERSION=$(composer --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        log_info "Composer détecté: $COMPOSER_VERSION"
    else
        log_warning "Composer non détecté. Utilisation de Docker pour le backend."
    fi
    
    # Vérifier Flutter
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version | head -1)
        log_info "Flutter détecté: $FLUTTER_VERSION"
    else
        log_warning "Flutter non détecté. Installez Flutter pour le développement mobile."
    fi
    
    log_success "Vérification des prérequis terminée"
}

# Configuration du backend Laravel
setup_backend() {
    log_info "Configuration du backend Laravel..."
    
    if [ -d "backend" ]; then
        cd backend
        
        # Copier le fichier d'environnement
        if [ ! -f ".env" ]; then
            cp .env.example .env
            log_success ".env créé depuis .env.example"
        fi
        
        # Installation des dépendances avec Composer si disponible
        if command -v composer &> /dev/null; then
            log_info "Installation des dépendances PHP..."
            composer install --no-dev --optimize-autoloader
            
            # Génération de la clé d'application
            php artisan key:generate
            log_success "Clé d'application générée"
        else
            log_info "Composer non disponible, les dépendances seront installées via Docker"
        fi
        
        cd ..
    else
        log_error "Dossier backend non trouvé"
        exit 1
    fi
    
    log_success "Configuration du backend terminée"
}

# Configuration du frontend Flutter
setup_frontend() {
    log_info "Configuration du frontend Flutter..."
    
    if [ -d "mobile" ]; then
        cd mobile
        
        # Installation des dépendances Flutter si disponible
        if command -v flutter &> /dev/null; then
            log_info "Installation des dépendances Flutter..."
            flutter pub get
            
            # Génération des fichiers auto-générés
            log_info "Génération des fichiers auto-générés..."
            flutter packages pub run build_runner build --delete-conflicting-outputs
            
            log_success "Dépendances Flutter installées"
        else
            log_warning "Flutter non disponible, veuillez installer Flutter SDK"
        fi
        
        cd ..
    else
        log_error "Dossier mobile non trouvé"
        exit 1
    fi
    
    log_success "Configuration du frontend terminée"
}

# Configuration des services Docker
setup_docker() {
    log_info "Configuration des services Docker..."
    
    # Créer les dossiers nécessaires
    mkdir -p docker/postgres
    mkdir -p docker/mosquitto
    
    # Configuration PostgreSQL
    cat > docker/postgres/init.sql << 'EOF'
-- Script d'initialisation PostgreSQL pour LifeCompanion
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
CREATE EXTENSION IF NOT EXISTS postgis;

-- Création de l'utilisateur et de la base de données
-- (déjà créés par les variables d'environnement Docker)

-- Configuration TimescaleDB
SELECT default_version, comment FROM pg_available_extensions WHERE name = 'timescaledb';
EOF
    
    # Configuration Mosquitto MQTT
    cat > docker/mosquitto/mosquitto.conf << 'EOF'
# Configuration Mosquitto pour LifeCompanion
listener 1883
allow_anonymous true
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
log_type error
log_type warning
log_type notice
log_type information
connection_messages true
log_timestamp true

# WebSocket support
listener 9001
protocol websockets
EOF
    
    log_success "Configuration Docker terminée"
}

# Démarrage des services
start_services() {
    log_info "Démarrage des services Docker..."
    
    # Construire et démarrer les services
    docker-compose up -d --build
    
    # Attendre que les services soient prêts
    log_info "Attente du démarrage des services..."
    sleep 10
    
    # Vérifier l'état des services
    if docker-compose ps | grep -q "Up"; then
        log_success "Services Docker démarrés avec succès"
    else
        log_error "Erreur lors du démarrage des services Docker"
        docker-compose logs
        exit 1
    fi
}

# Initialisation de la base de données
init_database() {
    log_info "Initialisation de la base de données..."
    
    # Attendre que PostgreSQL soit prêt
    sleep 5
    
    # Exécuter les migrations via Docker
    docker-compose exec backend php artisan migrate:fresh --seed --force
    
    log_success "Base de données initialisée"
}

# Affichage des informations finales
show_final_info() {
    echo ""
    echo "🎉 Configuration de LifeCompanion terminée avec succès !"
    echo "========================================================="
    echo ""
    echo "📋 Services disponibles :"
    echo "  • Backend Laravel:     http://localhost:8000"
    echo "  • Base de données:     localhost:5432"
    echo "  • Redis:              localhost:6379"
    echo "  • MQTT Broker:        localhost:1883"
    echo "  • MQTT WebSocket:     localhost:9001"
    echo ""
    echo "🚀 Commandes utiles :"
    echo "  • Voir les logs:      docker-compose logs -f"
    echo "  • Arrêter:           docker-compose down"
    echo "  • Redémarrer:        docker-compose restart"
    echo "  • Shell backend:     docker-compose exec backend bash"
    echo ""
    echo "📱 Pour le frontend Flutter :"
    echo "  • cd mobile && flutter run"
    echo ""
    echo "📚 Documentation: voir README.md"
    echo ""
}

# Fonction principale
main() {
    # Vérifier si nous sommes dans le bon répertoire
    if [ ! -f "docker-compose.yml" ]; then
        log_error "Veuillez exécuter ce script depuis la racine du projet LifeCompanion"
        exit 1
    fi
    
    check_prerequisites
    setup_docker
    setup_backend
    setup_frontend
    start_services
    init_database
    show_final_info
}

# Gestion des arguments
case "${1:-}" in
    "backend")
        setup_backend
        ;;
    "frontend")
        setup_frontend
        ;;
    "docker")
        setup_docker
        start_services
        ;;
    "database")
        init_database
        ;;
    "clean")
        log_info "Nettoyage des services..."
        docker-compose down -v
        docker system prune -f
        log_success "Nettoyage terminé"
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [commande]"
        echo ""
        echo "Commandes disponibles:"
        echo "  backend    - Configure uniquement le backend"
        echo "  frontend   - Configure uniquement le frontend"
        echo "  docker     - Configure et démarre les services Docker"
        echo "  database   - Initialise la base de données"
        echo "  clean      - Nettoie tous les services Docker"
        echo "  help       - Affiche cette aide"
        echo ""
        echo "Sans argument, exécute la configuration complète."
        ;;
    *)
        main
        ;;
esac 