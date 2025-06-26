# 🔌 T005 - IoT Communication Layer

**Sprint**: 1 | **Points**: 8 | **Assigné**: Wissem | **Priorité**: HIGH

---

## 🎯 **Objectif**

Mettre en place la communication IoT avec MQTT broker, simulateur de capteurs et intégration Laravel/Flutter.

## 📋 **Acceptance Criteria**

- [ ] MQTT Broker (Mosquitto) configuré et fonctionnel
- [ ] Simulateur de capteurs Python avec données réalistes
- [ ] Service Laravel MQTT pour recevoir/traiter les données
- [ ] Client MQTT Flutter pour temps réel
- [ ] Topics MQTT organisés et sécurisés
- [ ] Gestion des erreurs et reconnexions automatiques
- [ ] Logs et monitoring des communications
- [ ] Tests d'intégration communication end-to-end

---

## 🔧 **Prompts à Utiliser**

### **1. Configuration MQTT Broker**

```bash
# Prompt pour MQTT Broker setup
Je configure un MQTT broker pour une application IoT Laravel/Flutter.

**Architecture de communication** :
- **Capteurs** → MQTT → **Laravel Backend** → **WebSocket** → **Flutter**
- **Flutter** → **Laravel** → **MQTT** → **Devices** (commandes)

**Topics structure** :
- `lifecompanion/sensors/{device_id}/environmental` (lectures capteurs)
- `lifecompanion/sensors/{device_id}/activity` (données accéléromètre)
- `lifecompanion/devices/{device_id}/commands` (commandes vers devices)
- `lifecompanion/devices/{device_id}/status` (statut devices)
- `lifecompanion/system/health` (monitoring système)

**Besoins de sécurité** :
- Authentification par certificats ou username/password
- TLS encryption pour production
- ACL (Access Control Lists) par device
- Rate limiting pour éviter spam

J'ai besoin de :
- Configuration Mosquitto complète avec Docker
- Setup TLS et authentification
- ACL configuration
- Monitoring et logging
- Scripts de maintenance

Fournis la configuration complète avec exemples.
```

### **2. Simulateur de Capteurs Python**

```bash
# Prompt pour simulateur IoT
Je crée un simulateur de capteurs IoT en Python pour tester mon app.

**Capteurs à simuler** :
- **Ruuvi tags** : température, humidité, pression, batterie
- **Accéléromètre** : données pour classification d'activité
- **Multiple devices** : 5-10 capteurs simultanés

**Patterns réalistes** :
- **Variations journalières** : température 18-25°C, humidité 40-70%
- **Activités humaines** : statique, marche, transport
- **Événements** : notifications sur seuils dépassés
- **Dégradation batterie** : simulation progressive

**Fonctionnalités** :
- Publication MQTT automatique (30s intervals)
- Simulation de pannes/reconnexions
- Configuration via fichier JSON
- Logs détaillés des envois
- Interface web simple pour monitoring

J'ai besoin de :
- Script Python avec paho-mqtt
- Générateurs de données réalistes
- Configuration flexible
- Error handling et retry logic
- Documentation d'usage

Fournis le code complet avec examples de données.
```

### **3. Service Laravel MQTT**

```bash
# Prompt pour Laravel MQTT integration
Je veux intégrer MQTT dans Laravel pour recevoir et traiter les données IoT.

**Fonctionnalités requises** :
- **MqttService** : connexion, subscription, publication
- **Background workers** : processing des messages entrants
- **Event dispatching** : événements pour nouveaux données
- **Queues** : traitement asynchrone des données volumineuses
- **Validation** : validation des payloads MQTT

**Architecture** :
```

MQTT Broker → Laravel Worker → Events → Listeners → Database
↓
WebSocket → Flutter

```

**Services nécessaires** :
- MqttService (connexion et comm)
- SensorDataProcessor (traitement données)
- ActivityClassifier (classification temps réel)
- NotificationDispatcher (alertes automatiques)

J'ai besoin de :
- Package PHP MQTT (ReactPHP/pawl-mqtt)
- Service classes complètes
- Queue jobs pour processing
- Event/Listener system
- Tests unitaires et intégration

Fournis l'implémentation complète avec exemples.
```

### **4. Client MQTT Flutter**

```bash
# Prompt pour Flutter MQTT client
Je développe un client MQTT Flutter pour recevoir des données IoT temps réel.

**Fonctionnalités** :
- **Connexion MQTT** : auto-reconnect, état de connexion
- **Subscriptions** : topics spécifiques par utilisateur
- **Real-time updates** : mise à jour UI automatique
- **Offline handling** : buffer local si pas de connexion
- **State management** : intégration avec Bloc pattern

**Topics à écouter** :
- Données environnementales en temps réel
- Notifications system
- Statut des devices
- Commandes de synchronisation

**UI Integration** :
- Live indicators dans dashboard
- Notifications push automatiques
- Charts updating en temps réel
- Connection status dans UI

J'ai besoin de :
- Package mqtt_client Flutter
- Service class pour MQTT
- Bloc integration pour state management
- UI components pour real-time data
- Error handling et reconnection logic

Fournis l'implémentation complète avec exemples UI.
```

---

## 📝 **Actions Détaillées**

### **Étape 1 : Setup MQTT Broker**

1. **Configurer Mosquitto avec Docker**

   ```yaml
   # docker-compose.yml
   mosquitto:
     image: eclipse-mosquitto:2.0
     ports:
       - '1883:1883'
       - '9001:9001'
     volumes:
       - ./docker/mosquitto:/mosquitto/config
       - mosquitto_data:/mosquitto/data
       - mosquitto_logs:/mosquitto/log
   ```

2. **Configuration Mosquitto**

   ```conf
   # mosquitto.conf
   listener 1883
   allow_anonymous false
   password_file /mosquitto/config/passwords
   acl_file /mosquitto/config/acl
   ```

3. **Créer utilisateurs et ACL**

### **Étape 2 : Simulateur Python**

1. **Structure du projet simulateur**

   ```
   iot_simulator/
   ├── main.py
   ├── sensors/
   │   ├── ruuvi_simulator.py
   │   ├── accelerometer_simulator.py
   │   └── device_manager.py
   ├── config/
   │   └── devices.json
   └── requirements.txt
   ```

2. **Installer dépendances Python**

   ```bash
   pip install paho-mqtt numpy pandas schedule
   ```

3. **Implémenter les simulateurs**

### **Étape 3 : Laravel MQTT Service**

1. **Installer package MQTT**

   ```bash
   composer require php-mqtt/client
   ```

2. **Créer les services**

   ```bash
   php artisan make:service MqttService
   php artisan make:job ProcessSensorData
   php artisan make:event SensorDataReceived
   ```

3. **Configuration et implementation**

### **Étape 4 : Flutter MQTT Client**

1. **Ajouter dépendance Flutter**

   ```yaml
   # pubspec.yaml
   dependencies:
     mqtt_client: ^10.0.0
   ```

2. **Créer les services et blocs**

   ```bash
   # Services et Blocs Flutter
   lib/services/mqtt_service.dart
   lib/blocs/mqtt/mqtt_bloc.dart
   ```

3. **Intégration UI**

### **Étape 5 : Tests et Monitoring**

1. **Tests de communication**
2. **Monitoring et logs**
3. **Performance testing**

---

## 🗂️ **Structure Topics MQTT**

### **Topics Sensors → Backend**

```
lifecompanion/sensors/{device_id}/environmental
└── Payload: {
    "device_id": "ruuvi_001",
    "timestamp": "2025-06-25T10:30:00Z",
    "temperature": 22.5,
    "humidity": 45.2,
    "pressure": 1013.25,
    "battery": 85
}

lifecompanion/sensors/{device_id}/activity
└── Payload: {
    "device_id": "accel_001",
    "timestamp": "2025-06-25T10:30:00Z",
    "x": 0.15,
    "y": 0.02,
    "z": 9.81,
    "activity_hint": "stationary"
}
```

### **Topics Backend → Devices**

```
lifecompanion/devices/{device_id}/commands
└── Payload: {
    "command": "set_interval",
    "interval": 30,
    "timestamp": "2025-06-25T10:30:00Z"
}

lifecompanion/system/health
└── Payload: {
    "status": "healthy",
    "active_devices": 12,
    "last_update": "2025-06-25T10:30:00Z"
}
```

---

## 🐍 **Simulateur Python - Exemple**

### **Device Simulator Class**

```python
import json
import time
import random
from datetime import datetime
from paho.mqtt import client as mqtt_client

class RuuviSimulator:
    def __init__(self, device_id, mqtt_client):
        self.device_id = device_id
        self.client = mqtt_client
        self.base_temp = 22.0
        self.base_humidity = 50.0

    def generate_reading(self):
        # Simulation réaliste avec variations
        temp_variation = random.uniform(-2, 2)
        humidity_variation = random.uniform(-5, 5)

        return {
            "device_id": self.device_id,
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "temperature": round(self.base_temp + temp_variation, 2),
            "humidity": round(self.base_humidity + humidity_variation, 2),
            "pressure": round(random.uniform(1010, 1020), 2),
            "battery": random.randint(20, 100)
        }

    def publish_reading(self):
        reading = self.generate_reading()
        topic = f"lifecompanion/sensors/{self.device_id}/environmental"
        self.client.publish(topic, json.dumps(reading))
```

---

## ⚡ **Laravel MQTT Service - Exemple**

### **MqttService Class**

```php
<?php

namespace App\Services;

use PhpMqtt\Client\MqttClient;
use PhpMqtt\Client\ConnectionSettings;
use App\Jobs\ProcessSensorData;
use Illuminate\Support\Facades\Log;

class MqttService
{
    private MqttClient $client;

    public function __construct()
    {
        $this->client = new MqttClient(
            config('mqtt.host'),
            config('mqtt.port'),
            config('mqtt.client_id')
        );
    }

    public function connect(): void
    {
        $connectionSettings = new ConnectionSettings();
        $connectionSettings->setUsername(config('mqtt.username'));
        $connectionSettings->setPassword(config('mqtt.password'));

        $this->client->connect($connectionSettings);

        // Subscribe to sensor data
        $this->client->subscribe(
            'lifecompanion/sensors/+/environmental',
            [$this, 'handleSensorData']
        );
    }

    public function handleSensorData(string $topic, string $message): void
    {
        try {
            $data = json_decode($message, true);
            ProcessSensorData::dispatch($topic, $data);
        } catch (\Exception $e) {
            Log::error('MQTT message processing failed', [
                'topic' => $topic,
                'message' => $message,
                'error' => $e->getMessage()
            ]);
        }
    }
}
```

---

## 📱 **Flutter MQTT Service - Exemple**

### **MqttService Class**

```dart
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;
  final String server;
  final int port;
  final String clientId;

  MqttService({
    required this.server,
    required this.port,
    required this.clientId,
  });

  Future<void> connect() async {
    client = MqttServerClient(server, clientId);
    client.port = port;
    client.keepAlivePeriod = 60;
    client.autoReconnect = true;

    try {
      await client.connect();
      print('MQTT Client Connected');

      // Subscribe to user-specific topics
      client.subscribe(
        'lifecompanion/sensors/+/environmental',
        MqttQos.atLeastOnce,
      );

      // Listen to messages
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          message.payload.message,
        );

        _handleMessage(c[0].topic, payload);
      });

    } catch (e) {
      print('MQTT Connection failed: $e');
    }
  }

  void _handleMessage(String topic, String payload) {
    try {
      final data = json.decode(payload);
      // Dispatch to appropriate Bloc
      if (topic.contains('/environmental')) {
        // Send to EnvironmentalBloc
      }
    } catch (e) {
      print('Error parsing MQTT message: $e');
    }
  }
}
```

---

## 🧪 **Tests à Implémenter**

### **Tests Simulateur Python**

```python
# test_simulator.py
- test_ruuvi_data_format()
- test_accelerometer_data_format()
- test_mqtt_publish_success()
- test_device_reconnection()
```

### **Tests Laravel MQTT**

```php
// MqttServiceTest.php
- test_mqtt_connection()
- test_sensor_data_processing()
- test_invalid_message_handling()
- test_queue_job_dispatching()
```

### **Tests Flutter MQTT**

```dart
// mqtt_service_test.dart
- test_mqtt_connection()
- test_message_parsing()
- test_bloc_integration()
- test_reconnection_logic()
```

---

## ✅ **Definition of Done**

- [ ] MQTT Broker opérationnel avec sécurité
- [ ] Simulateur Python génère données réalistes
- [ ] Laravel reçoit et traite les données MQTT
- [ ] Flutter affiche données temps réel
- [ ] Topics organisés et documentés
- [ ] Gestion d'erreurs et reconnexions
- [ ] Tests d'intégration passants
- [ ] Monitoring et logs fonctionnels
- [ ] Documentation technique complète

---

## 🔗 **Dépendances**

- **Précédent**: T001 - Setup Environnement, T004 - Database Setup
- **Suivant**: T006 - API Integration Flutter, T002 - Backend API Core

---

## 📚 **Ressources**

- [Eclipse Mosquitto Documentation](https://mosquitto.org/documentation/)
- [Paho MQTT Python](https://eclipse.dev/paho/index.php?page=clients/python/index.php)
- [PHP MQTT Client](https://github.com/php-mqtt/client)
- [Flutter MQTT Client](https://pub.dev/packages/mqtt_client)

---

_Tâche créée le 25 juin 2025 - LifeCompanion Project_
