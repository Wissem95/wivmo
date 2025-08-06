#!/bin/bash

# LifeCompanion Backend Start Script
# Script de démarrage avec initialisation complète

set -e

echo "🚀 Démarrage LifeCompanion Backend..."

# Fonction pour attendre qu'un service soit prêt
wait_for_service() {
    local host=$1
    local port=$2
    local service_name=$3
    local max_attempts=30
    local attempt=1
    
    echo "⏳ Attente de $service_name ($host:$port)..."
    
    while ! nc -z "$host" "$port" >/dev/null 2>&1; do
        if [ $attempt -eq $max_attempts ]; then
            echo "❌ Échec: $service_name non disponible après $max_attempts tentatives"
            exit 1
        fi
        
        echo "🔄 Tentative $attempt/$max_attempts..."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "✅ $service_name est prêt !"
}

# Attendre que PostgreSQL soit prêt
wait_for_service "${DB_HOST:-postgres}" "${DB_PORT:-5432}" "PostgreSQL"

# Attendre que Redis soit prêt
wait_for_service "${REDIS_HOST:-redis}" "${REDIS_PORT:-6379}" "Redis"

# Attendre que MQTT soit prêt
wait_for_service "${MQTT_HOST:-mqtt}" "${MQTT_PORT:-1883}" "MQTT Broker"

echo "📦 Optimisation Composer..."
composer dump-autoload --optimize --classmap-authoritative

# Créer le fichier .env si il n'existe pas
if [ ! -f .env ]; then
    echo "📝 Création du fichier .env..."
    cp .env.example .env
    php artisan key:generate --ansi
fi

echo "🔐 Génération de la clé d'application..."
php artisan key:generate --ansi --force

# Cache de configuration pour les performances
echo "⚡ Optimisation des caches Laravel..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Migration et seed de la base de données
echo "🗄️  Configuration de la base de données..."
php artisan migrate --force --seed

# Créer le lien symbolique pour le stockage
echo "🔗 Création du lien symbolique storage..."
php artisan storage:link

# Nettoyage des caches
echo "🧹 Nettoyage des caches..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Installation de Telescope (monitoring)
echo "🔭 Configuration Telescope..."
php artisan telescope:install --force
php artisan telescope:publish --force

# Configuration des permissions
echo "🔒 Configuration des permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
chmod -R 775 /var/www/html/storage
chmod -R 775 /var/www/html/bootstrap/cache

# Créer les répertoires de logs nécessaires
mkdir -p /var/log/supervisor
mkdir -p /var/www/html/storage/logs

# Vérification de la santé de l'application
echo "🏥 Vérification de la santé de l'application..."
if php artisan health:check; then
    echo "✅ Application en bonne santé !"
else
    echo "⚠️  Problèmes détectés, mais on continue..."
fi

echo "🎯 LifeCompanion Backend prêt !"
echo "📊 Monitoring disponible sur : http://localhost:8000/telescope"
echo "📚 Documentation API : http://localhost:8000/docs"
echo "🔌 WebSockets : ws://localhost:6001"

# Démarrer Supervisor
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 