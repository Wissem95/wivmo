#!/usr/bin/env python3
"""
LifeCompanion IoT Simulator - Health Check Server
Serveur HTTP simple pour les health checks Docker
"""

import json
import threading
import time
from datetime import datetime
from flask import Flask, jsonify
import logging

# Configuration du logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

class HealthChecker:
    """Gestionnaire de santé du simulateur"""
    
    def __init__(self):
        self.start_time = datetime.now()
        self.last_mqtt_publish = None
        self.mqtt_connected = False
        self.sensors_count = 4
        self.error_count = 0
        
    def update_mqtt_status(self, connected: bool):
        """Met à jour le statut MQTT"""
        self.mqtt_connected = connected
        if connected:
            self.last_mqtt_publish = datetime.now()
    
    def increment_error(self):
        """Incrémente le compteur d'erreurs"""
        self.error_count += 1
    
    def get_status(self) -> dict:
        """Retourne le statut de santé"""
        uptime = (datetime.now() - self.start_time).total_seconds()
        
        # Vérifier si MQTT est récemment actif
        mqtt_healthy = self.mqtt_connected
        if self.last_mqtt_publish:
            time_since_publish = (datetime.now() - self.last_mqtt_publish).total_seconds()
            mqtt_healthy = mqtt_healthy and time_since_publish < 60  # 1 minute max
        
        # Statut global
        overall_healthy = mqtt_healthy and self.error_count < 10
        
        return {
            'status': 'healthy' if overall_healthy else 'unhealthy',
            'timestamp': datetime.now().isoformat(),
            'uptime_seconds': round(uptime, 2),
            'services': {
                'mqtt': {
                    'connected': self.mqtt_connected,
                    'last_publish': self.last_mqtt_publish.isoformat() if self.last_mqtt_publish else None,
                    'healthy': mqtt_healthy
                },
                'sensors': {
                    'count': self.sensors_count,
                    'active': self.sensors_count if mqtt_healthy else 0
                }
            },
            'metrics': {
                'error_count': self.error_count,
                'error_rate': round(self.error_count / max(uptime / 60, 1), 2)  # erreurs par minute
            }
        }

# Instance globale du health checker
health_checker = HealthChecker()

@app.route('/health')
def health():
    """Endpoint de health check"""
    status = health_checker.get_status()
    
    # Retourner 200 si healthy, 503 si unhealthy
    status_code = 200 if status['status'] == 'healthy' else 503
    
    return jsonify(status), status_code

@app.route('/metrics')
def metrics():
    """Endpoint pour métriques détaillées"""
    status = health_checker.get_status()
    
    # Format Prometheus-like pour monitoring
    uptime = status['uptime_seconds']
    error_count = status['metrics']['error_count']
    mqtt_connected = 1 if status['services']['mqtt']['connected'] else 0
    
    metrics_text = f"""# HELP lifecompanion_iot_uptime_seconds Uptime du simulateur IoT
# TYPE lifecompanion_iot_uptime_seconds counter
lifecompanion_iot_uptime_seconds {uptime}

# HELP lifecompanion_iot_errors_total Nombre total d'erreurs
# TYPE lifecompanion_iot_errors_total counter
lifecompanion_iot_errors_total {error_count}

# HELP lifecompanion_iot_mqtt_connected Statut connexion MQTT
# TYPE lifecompanion_iot_mqtt_connected gauge
lifecompanion_iot_mqtt_connected {mqtt_connected}

# HELP lifecompanion_iot_sensors_active Nombre de capteurs actifs
# TYPE lifecompanion_iot_sensors_active gauge
lifecompanion_iot_sensors_active {status['services']['sensors']['active']}
"""
    
    return metrics_text, 200, {'Content-Type': 'text/plain; version=0.0.4; charset=utf-8'}

@app.route('/status')
def status():
    """Endpoint de statut détaillé"""
    return jsonify(health_checker.get_status())

@app.route('/')
def index():
    """Page d'accueil"""
    return jsonify({
        'service': 'LifeCompanion IoT Simulator',
        'version': '1.0.0',
        'description': 'Simulateur de capteurs environnementaux',
        'endpoints': {
            'health': '/health',
            'metrics': '/metrics',
            'status': '/status'
        }
    })

def run_health_server():
    """Lance le serveur de health check"""
    logger.info("🏥 Démarrage du serveur de health check sur le port 8080")
    app.run(host='0.0.0.0', port=8080, debug=False, use_reloader=False)

if __name__ == '__main__':
    run_health_server() 