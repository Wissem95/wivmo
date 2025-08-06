#!/bin/bash

# LifeCompanion IoT Simulator - Script de démarrage
# Lance le simulateur et le serveur de health check

set -e

echo "🚀 Démarrage du simulateur LifeCompanion IoT..."

# Fonction pour attendre MQTT
wait_for_mqtt() {
    local max_attempts=30
    local attempt=1
    
    echo "⏳ Attente du broker MQTT ($MQTT_HOST:$MQTT_PORT)..."
    
    while ! nc -z "$MQTT_HOST" "$MQTT_PORT" >/dev/null 2>&1; do
        if [ $attempt -eq $max_attempts ]; then
            echo "❌ MQTT non disponible après $max_attempts tentatives"
            exit 1
        fi
        
        echo "🔄 Tentative $attempt/$max_attempts..."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "✅ Broker MQTT disponible !"
}

# Attendre que MQTT soit prêt
wait_for_mqtt

# Créer le répertoire de logs
mkdir -p /app/logs

echo "🏥 Démarrage du serveur de health check..."
# Démarrer le serveur de health check en arrière-plan
python health_server.py &
HEALTH_PID=$!

echo "📡 Démarrage du simulateur IoT..."
# Démarrer le simulateur principal
python simulator.py &
SIMULATOR_PID=$!

# Fonction de nettoyage
cleanup() {
    echo "🛑 Arrêt en cours..."
    kill $HEALTH_PID 2>/dev/null || true
    kill $SIMULATOR_PID 2>/dev/null || true
    wait
    echo "✅ Arrêt terminé"
}

# Capturer les signaux pour arrêt propre
trap cleanup SIGTERM SIGINT

echo "✅ Simulateur LifeCompanion IoT démarré"
echo "📊 Health check disponible sur http://localhost:8080/health"
echo "📈 Métriques disponibles sur http://localhost:8080/metrics"

# Attendre que les processus se terminent
wait $SIMULATOR_PID $HEALTH_PID 