#!/usr/bin/env python3
"""
LifeCompanion IoT Simulator
Simulateur de capteurs environnementaux réalistes

Génère des données pour :
- Température (°C)
- Humidité (%)
- Pression atmosphérique (hPa)
- CO2 (ppm)
- Luminosité (lux)
- Bruit (dB)
- Accéléromètre (x, y, z)
"""

import json
import time
import random
import math
import logging
import threading
from datetime import datetime, timedelta
from typing import Dict, Any, List
import signal
import sys
import os

import paho.mqtt.client as mqtt
import numpy as np
from faker import Faker
import colorlog

# Configuration du logger
def setup_logger():
    """Configure le logger avec couleurs"""
    handler = colorlog.StreamHandler()
    handler.setFormatter(colorlog.ColoredFormatter(
        '%(log_color)s%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    ))
    
    logger = colorlog.getLogger('LifeCompanion-IoT')
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    return logger

logger = setup_logger()
fake = Faker('fr_FR')

class EnvironmentalSensor:
    """Simulateur de capteur environnemental avec données réalistes"""
    
    def __init__(self, device_id: str, location: str = "Bureau"):
        self.device_id = device_id
        self.location = location
        self.start_time = datetime.now()
        
        # Valeurs de base pour variation réaliste
        self.base_temperature = 22.0  # °C
        self.base_humidity = 45.0     # %
        self.base_pressure = 1013.0   # hPa
        self.base_co2 = 400.0         # ppm
        self.base_light = 300.0       # lux
        self.base_noise = 35.0        # dB
        
        # Patterns journaliers
        self.is_day_pattern = True
        self.activity_level = 0.5  # 0-1 niveau d'activité
        
    def get_time_factor(self) -> float:
        """Calcule le facteur temporel pour les variations journalières"""
        now = datetime.now()
        hour = now.hour + now.minute / 60.0
        
        # Simulation cycle jour/nuit
        day_factor = math.sin((hour - 6) * math.pi / 12)
        return max(0.1, day_factor)
    
    def get_activity_factor(self) -> float:
        """Simule l'activité humaine"""
        hour = datetime.now().hour
        
        # Heures d'activité normale (bureau)
        if 8 <= hour <= 18:
            # Pic d'activité vers midi
            activity = 0.8 + 0.2 * math.sin((hour - 8) * math.pi / 10)
        elif 19 <= hour <= 22:
            # Soirée active
            activity = 0.6
        else:
            # Nuit calme
            activity = 0.1
            
        # Ajout de variation aléatoire
        activity += random.uniform(-0.1, 0.1)
        return max(0.0, min(1.0, activity))
    
    def generate_temperature(self) -> float:
        """Génère température réaliste avec variations journalières"""
        time_factor = self.get_time_factor()
        activity_factor = self.get_activity_factor()
        
        # Variation journalière : +/- 3°C
        daily_variation = 3.0 * time_factor
        
        # Variation due à l'activité : +1°C si activité
        activity_variation = 1.0 * activity_factor
        
        # Bruit aléatoire
        noise = random.uniform(-0.5, 0.5)
        
        temp = self.base_temperature + daily_variation + activity_variation + noise
        return round(temp, 1)
    
    def generate_humidity(self) -> float:
        """Génère humidité avec anti-corrélation à la température"""
        time_factor = self.get_time_factor()
        activity_factor = self.get_activity_factor()
        
        # Humidité diminue quand température augmente
        temp_correlation = -5.0 * time_factor
        
        # Activité augmente légèrement l'humidité (respiration)
        activity_variation = 3.0 * activity_factor
        
        # Variation saisonnière simulée
        seasonal = 5.0 * math.sin(datetime.now().timetuple().tm_yday * 2 * math.pi / 365)
        
        noise = random.uniform(-2.0, 2.0)
        
        humidity = self.base_humidity + temp_correlation + activity_variation + seasonal + noise
        return round(max(20.0, min(80.0, humidity)), 1)
    
    def generate_pressure(self) -> float:
        """Génère pression atmosphérique avec tendances météo"""
        # Simulation de fronts météo
        weather_trend = 10.0 * math.sin(time.time() / 3600 / 24 * math.pi / 3)  # Cycle 6 jours
        
        # Variation journalière subtile
        daily_variation = 2.0 * math.sin(datetime.now().hour * math.pi / 12)
        
        noise = random.uniform(-1.0, 1.0)
        
        pressure = self.base_pressure + weather_trend + daily_variation + noise
        return round(pressure, 1)
    
    def generate_co2(self) -> float:
        """Génère CO2 corrélé à l'activité"""
        activity_factor = self.get_activity_factor()
        
        # CO2 augmente fortement avec l'activité
        activity_co2 = 600.0 * activity_factor
        
        # Accumulation dans espace fermé
        time_since_start = (datetime.now() - self.start_time).total_seconds() / 3600
        accumulation = min(200.0, 50.0 * time_since_start * activity_factor)
        
        # Ventilation naturelle
        ventilation = -100.0 * (1 - activity_factor)
        
        noise = random.uniform(-20.0, 20.0)
        
        co2 = self.base_co2 + activity_co2 + accumulation + ventilation + noise
        return round(max(350.0, min(2000.0, co2)), 0)
    
    def generate_light(self) -> float:
        """Génère luminosité selon l'heure et activité"""
        time_factor = self.get_time_factor()
        activity_factor = self.get_activity_factor()
        
        # Lumière naturelle
        natural_light = 500.0 * time_factor
        
        # Éclairage artificiel
        artificial_light = 200.0 * activity_factor
        
        # Variation nuageuse
        cloud_factor = 0.7 + 0.3 * math.sin(time.time() / 1800 * math.pi)  # 30min cycle
        
        noise = random.uniform(-30.0, 30.0)
        
        light = (natural_light * cloud_factor + artificial_light + self.base_light) + noise
        return round(max(0.0, light), 0)
    
    def generate_noise(self) -> float:
        """Génère niveau sonore selon l'activité"""
        activity_factor = self.get_activity_factor()
        
        # Bruit de fond
        base_noise = self.base_noise
        
        # Bruit d'activité
        activity_noise = 25.0 * activity_factor
        
        # Événements ponctuels (passage, conversation)
        if random.random() < 0.1:  # 10% de chance
            event_noise = random.uniform(10.0, 30.0)
        else:
            event_noise = 0.0
        
        noise = random.uniform(-3.0, 3.0)
        
        total_noise = base_noise + activity_noise + event_noise + noise
        return round(max(25.0, min(85.0, total_noise)), 1)
    
    def generate_accelerometer(self) -> Dict[str, float]:
        """Génère données accéléromètre (mouvement utilisateur)"""
        activity_factor = self.get_activity_factor()
        
        # Mouvement de base (vibrations, micro-mouvements)
        base_movement = 0.02
        
        # Mouvement lié à l'activité
        activity_movement = 0.1 * activity_factor
        
        # Événement de mouvement
        if random.random() < activity_factor * 0.2:  # Plus de chance si actif
            movement_intensity = random.uniform(0.5, 2.0)
        else:
            movement_intensity = 0.0
        
        # Génération des 3 axes
        x = base_movement + activity_movement + movement_intensity * random.uniform(-1, 1)
        y = base_movement + activity_movement + movement_intensity * random.uniform(-1, 1)
        z = 9.81 + base_movement + movement_intensity * random.uniform(-0.5, 0.5)  # Gravité + mouvement
        
        return {
            'x': round(x, 3),
            'y': round(y, 3),
            'z': round(z, 3)
        }
    
    def generate_reading(self) -> Dict[str, Any]:
        """Génère une lecture complète du capteur"""
        accelerometer = self.generate_accelerometer()
        
        reading = {
            'device_id': self.device_id,
            'location': self.location,
            'timestamp': datetime.now().isoformat(),
            'environmental': {
                'temperature': self.generate_temperature(),
                'humidity': self.generate_humidity(),
                'pressure': self.generate_pressure(),
                'co2': self.generate_co2(),
                'light': self.generate_light(),
                'noise': self.generate_noise()
            },
            'accelerometer': accelerometer,
            'metadata': {
                'battery_level': random.randint(15, 100),
                'signal_strength': random.randint(60, 100),
                'status': 'active'
            }
        }
        
        return reading

class LifeCompanionSimulator:
    """Simulateur principal LifeCompanion"""
    
    def __init__(self):
        self.mqtt_host = os.getenv('MQTT_HOST', 'mqtt')
        self.mqtt_port = int(os.getenv('MQTT_PORT', 1883))
        self.interval = int(os.getenv('SIMULATION_INTERVAL', 10))
        
        self.client = mqtt.Client(client_id="lifecompanion_simulator")
        self.sensors: List[EnvironmentalSensor] = []
        self.running = False
        
        # Configuration MQTT
        self.client.on_connect = self.on_connect
        self.client.on_disconnect = self.on_disconnect
        self.client.on_message = self.on_message
        
        # Gestion des signaux
        signal.signal(signal.SIGINT, self.signal_handler)
        signal.signal(signal.SIGTERM, self.signal_handler)
        
        # Initialiser les capteurs
        self.init_sensors()
    
    def init_sensors(self):
        """Initialise les capteurs simulés"""
        sensor_configs = [
            {'device_id': 'ENV_001', 'location': 'Bureau Principal'},
            {'device_id': 'ENV_002', 'location': 'Chambre'},
            {'device_id': 'ENV_003', 'location': 'Salon'},
            {'device_id': 'ENV_004', 'location': 'Cuisine'},
        ]
        
        for config in sensor_configs:
            sensor = EnvironmentalSensor(**config)
            self.sensors.append(sensor)
            logger.info(f"Capteur initialisé: {config['device_id']} ({config['location']})")
    
    def on_connect(self, client, userdata, flags, rc):
        """Callback de connexion MQTT"""
        if rc == 0:
            logger.info(f"✅ Connecté au broker MQTT {self.mqtt_host}:{self.mqtt_port}")
            # S'abonner aux commandes
            client.subscribe("lifecompanion/commands/+")
        else:
            logger.error(f"❌ Échec connexion MQTT: {rc}")
    
    def on_disconnect(self, client, userdata, rc):
        """Callback de déconnexion MQTT"""
        logger.warning(f"⚠️  Déconnecté du broker MQTT: {rc}")
    
    def on_message(self, client, userdata, msg):
        """Traite les messages reçus"""
        try:
            topic = msg.topic
            payload = json.loads(msg.payload.decode())
            logger.info(f"📨 Message reçu sur {topic}: {payload}")
            
            # Traiter les commandes
            if "commands" in topic:
                self.handle_command(payload)
                
        except Exception as e:
            logger.error(f"Erreur traitement message: {e}")
    
    def handle_command(self, command: Dict[str, Any]):
        """Traite une commande reçue"""
        cmd_type = command.get('type')
        device_id = command.get('device_id')
        
        if cmd_type == 'restart_sensor':
            logger.info(f"🔄 Redémarrage capteur {device_id}")
        elif cmd_type == 'calibrate':
            logger.info(f"🎯 Calibration capteur {device_id}")
        elif cmd_type == 'update_interval':
            new_interval = command.get('interval', self.interval)
            logger.info(f"⏱️  Nouvel intervalle: {new_interval}s")
            self.interval = new_interval
    
    def publish_sensor_data(self):
        """Publie les données de tous les capteurs"""
        for sensor in self.sensors:
            try:
                reading = sensor.generate_reading()
                topic = f"lifecompanion/sensors/{sensor.device_id}/data"
                
                payload = json.dumps(reading, ensure_ascii=False)
                
                result = self.client.publish(topic, payload, qos=1)
                
                if result.rc == mqtt.MQTT_ERR_SUCCESS:
                    logger.info(f"📊 Données envoyées: {sensor.device_id} - "
                              f"T:{reading['environmental']['temperature']}°C, "
                              f"H:{reading['environmental']['humidity']}%, "
                              f"CO2:{reading['environmental']['co2']}ppm")
                else:
                    logger.error(f"❌ Échec envoi données {sensor.device_id}: {result.rc}")
                    
            except Exception as e:
                logger.error(f"Erreur publication capteur {sensor.device_id}: {e}")
    
    def publish_device_status(self):
        """Publie le statut des devices"""
        for sensor in self.sensors:
            status = {
                'device_id': sensor.device_id,
                'status': 'online',
                'last_seen': datetime.now().isoformat(),
                'uptime': (datetime.now() - sensor.start_time).total_seconds(),
                'location': sensor.location
            }
            
            topic = f"lifecompanion/status/{sensor.device_id}"
            payload = json.dumps(status)
            
            self.client.publish(topic, payload, qos=1)
    
    def connect_mqtt(self):
        """Connexion au broker MQTT avec retry"""
        max_retries = 10
        retry_count = 0
        
        while retry_count < max_retries and not self.running:
            try:
                logger.info(f"🔄 Tentative de connexion MQTT ({retry_count + 1}/{max_retries})...")
                self.client.connect(self.mqtt_host, self.mqtt_port, 60)
                self.client.loop_start()
                
                # Attendre la connexion
                time.sleep(2)
                
                if self.client.is_connected():
                    return True
                    
            except Exception as e:
                logger.error(f"Erreur connexion MQTT: {e}")
                retry_count += 1
                time.sleep(5)
        
        return False
    
    def run(self):
        """Boucle principale du simulateur"""
        logger.info("🚀 Démarrage du simulateur LifeCompanion IoT")
        
        if not self.connect_mqtt():
            logger.error("❌ Impossible de se connecter au broker MQTT")
            return
        
        self.running = True
        
        # Publier le statut initial
        self.publish_device_status()
        
        try:
            while self.running:
                start_time = time.time()
                
                # Publier les données des capteurs
                self.publish_sensor_data()
                
                # Publier le statut toutes les 5 minutes
                if int(time.time()) % 300 == 0:
                    self.publish_device_status()
                
                # Attendre l'intervalle suivant
                elapsed = time.time() - start_time
                sleep_time = max(0, self.interval - elapsed)
                
                if sleep_time > 0:
                    time.sleep(sleep_time)
                    
        except Exception as e:
            logger.error(f"Erreur dans la boucle principale: {e}")
        finally:
            self.stop()
    
    def stop(self):
        """Arrêt propre du simulateur"""
        logger.info("🛑 Arrêt du simulateur...")
        self.running = False
        
        # Publier statut hors ligne
        for sensor in self.sensors:
            status = {
                'device_id': sensor.device_id,
                'status': 'offline',
                'last_seen': datetime.now().isoformat()
            }
            topic = f"lifecompanion/status/{sensor.device_id}"
            self.client.publish(topic, json.dumps(status), qos=1)
        
        self.client.loop_stop()
        self.client.disconnect()
        logger.info("✅ Simulateur arrêté proprement")
    
    def signal_handler(self, signum, frame):
        """Gestionnaire de signaux"""
        logger.info(f"Signal {signum} reçu, arrêt en cours...")
        self.stop()
        sys.exit(0)

if __name__ == "__main__":
    simulator = LifeCompanionSimulator()
    simulator.run() 