# 🏗️ Architecture LifeCompanion - Laravel + Flutter

## 📋 Vue d'Ensemble

**LifeCompanion** utilise une architecture moderne découplée avec **Laravel** pour le backend et **Flutter** pour le frontend mobile, optimisée pour l'IoT et les données en temps réel.

## 🎯 Choix Technologiques

### ✅ Pourquoi Laravel + Flutter ?

#### **Laravel (Backend)**

- **Écosystème riche** : Eloquent ORM, Queues, WebSockets, MQTT
- **Performance** : Cache Redis, optimization des requêtes
- **Sécurité** : Sanctum pour l'API, validation robuste
- **Time Series** : Support PostgreSQL + TimescaleDB
- **Temps réel** : WebSockets natifs, MQTT intégré

#### **Flutter (Frontend)**

- **Cross-platform** : iOS, Android, Web avec un seul code
- **Performance native** : Compilation AOT
- **État robuste** : Bloc Pattern pour la gestion d'état
- **Offline-first** : SQLite local, synchronisation automatique
- **IoT friendly** : MQTT, WebSocket, notifications temps réel

## 🏛️ Architecture Générale

```
┌─────────────────────────────────────────────────────────────────┐
│                         LifeCompanion                           │
├─────────────────┬─────────────────┬─────────────────────────────┤
│   Frontend      │    Backend      │         IoT Layer           │
│   (Flutter)     │    (Laravel)    │      (Raspberry Pi)         │
├─────────────────┼─────────────────┼─────────────────────────────┤
│ • UI/UX Mobile  │ • API REST      │ • Capteurs Ruuvi           │
│ • Bloc Pattern  │ • WebSockets    │ • Classification ML         │
│ • SQLite Local  │ • MQTT Broker   │ • MQTT Publisher            │
│ • Notifications │ • PostgreSQL    │ • Scripts Python           │
│ • Charts/Graphs │ • TimescaleDB   │ • GPIO Management           │
│ • Offline Mode  │ • Redis Cache   │ • Accéléromètre            │
└─────────────────┴─────────────────┴─────────────────────────────┘
```

## 🔗 Communication Inter-Services

### **1. API REST (HTTP/HTTPS)**

```
Flutter ←→ Laravel API
• Authentification (Sanctum)
• CRUD operations
• Synchronisation données
• Upload/Download
```

### **2. WebSockets (Temps Réel)**

```
Flutter ←→ Laravel WebSocket
• Notifications instantanées
• Mises à jour temps réel
• Chat/Messages
• État des appareils
```

### **3. MQTT (IoT)**

```
Raspberry Pi → MQTT Broker ← Laravel ← Flutter
• Données capteurs
• Commandes appareils
• Alertes automatiques
• Télémétrie
```

## 📊 Modèle de Données

### **Backend Laravel (PostgreSQL + TimescaleDB)**

```sql
-- Utilisateurs et authentification
users (id, name, email, preferences, settings)
├── devices (id, user_id, type, mac_address, mqtt_topic)
├── environmental_readings (device_id, measured_at, temperature, humidity, pressure)
├── activity_classifications (user_id, started_at, activity_type, confidence)
└── notifications (user_id, title, message, type, status)

-- Hypertables TimescaleDB
environmental_readings → partitionnée par measured_at
activity_classifications → partitionnée par started_at
```

### **Frontend Flutter (SQLite)**

```dart
// Tables locales pour mode offline
- environmental_data (sync_status, local_id)
- activity_logs (is_synced, created_at)
- user_preferences (key, value)
- device_settings (device_id, settings)
- cached_notifications (id, read_status)
```

## 🔧 Architecture Backend (Laravel)

### **Structure des Dossiers**

```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/          # Controllers API REST
│   │   │   ├── AuthController.php
│   │   │   ├── DeviceController.php
│   │   │   ├── EnvironmentalController.php
│   │   │   └── ActivityController.php
│   │   ├── Requests/                 # Validation requests
│   │   └── Resources/                # API Resources (transformers)
│   ├── Models/                       # Eloquent Models
│   │   ├── User.php
│   │   ├── Device.php
│   │   ├── EnvironmentalReading.php
│   │   └── ActivityClassification.php
│   ├── Services/                     # Business Logic
│   │   ├── MqttService.php
│   │   ├── ActivityClassificationService.php
│   │   ├── ComfortScoreService.php
│   │   └── NotificationService.php
│   ├── Jobs/                         # Background Jobs
│   │   ├── ProcessSensorData.php
│   │   ├── ClassifyActivity.php
│   │   └── SendNotification.php
│   └── Events/                       # Events système
│       ├── SensorDataReceived.php
│       └── ActivityDetected.php
├── database/
│   ├── migrations/                   # Migrations base de données
│   └── seeders/                      # Données de test
├── routes/
│   ├── api.php                       # Routes API
│   └── websockets.php                # Routes WebSocket
└── config/
    ├── mqtt.php                      # Configuration MQTT
    └── timescaledb.php               # Configuration TimescaleDB
```

### **Services Principaux**

#### **1. MqttService (Communication IoT)**

```php
<?php

class MqttService
{
    public function publishSensorData(array $data): void
    public function subscribeToTopics(): void
    public function handleDeviceMessage(string $topic, array $payload): void
    public function sendCommandToDevice(string $deviceId, array $command): void
}
```

#### **2. ActivityClassificationService (IA)**

```php
<?php

class ActivityClassificationService
{
    public function classifyFromAccelerometer(array $readings): string
    public function calculateConfidenceScore(array $features): float
    public function trainModel(array $trainingData): void
    public function detectActivityChange(array $sequence): ?ActivityClassification
}
```

#### **3. ComfortScoreService (Algorithmes)**

```php
<?php

class ComfortScoreService
{
    public function calculateComfortScore(float $temp, float $humidity): float
    public function getPersonalizedThresholds(User $user): array
    public function generateComfortRecommendations(array $readings): array
    public function analyzeEnvironmentalTrends(array $history): array
}
```

## 📱 Architecture Frontend (Flutter)

### **Structure des Dossiers**

```
mobile/lib/
├── blocs/                            # État Management (Bloc Pattern)
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── environmental/
│   │   ├── environmental_bloc.dart
│   │   ├── environmental_event.dart
│   │   └── environmental_state.dart
│   ├── activity/
│   └── notification/
├── models/                           # Modèles de données
│   ├── user.dart
│   ├── device.dart
│   ├── environmental_reading.dart
│   └── activity_classification.dart
├── repositories/                     # Couche d'accès aux données
│   ├── api_repository.dart
│   ├── local_database_repository.dart
│   └── mqtt_repository.dart
├── services/                         # Services métier
│   ├── api_service.dart              # HTTP Client
│   ├── database_service.dart         # SQLite
│   ├── mqtt_service.dart             # MQTT Client
│   ├── notification_service.dart     # Notifications
│   └── sync_service.dart             # Synchronisation
├── ui/                               # Interface utilisateur
│   ├── pages/
│   │   ├── home/
│   │   ├── environmental/
│   │   ├── activity/
│   │   └── settings/
│   ├── widgets/                      # Composants réutilisables
│   └── themes/                       # Thèmes et styles
└── utils/                            # Utilitaires
    ├── constants.dart
    ├── helpers.dart
    └── extensions.dart
```

### **Gestion d'État (Bloc Pattern)**

```dart
// Exemple: EnvironmentalBloc
class EnvironmentalBloc extends Bloc<EnvironmentalEvent, EnvironmentalState> {
  final ApiRepository apiRepository;
  final LocalDatabaseRepository localRepository;
  final MqttRepository mqttRepository;

  EnvironmentalBloc({
    required this.apiRepository,
    required this.localRepository,
    required this.mqttRepository,
  }) : super(EnvironmentalInitial()) {
    // Écoute des événements MQTT en temps réel
    mqttRepository.environmentalStream.listen((data) {
      add(EnvironmentalDataReceived(data));
    });
  }

  @override
  Stream<EnvironmentalState> mapEventToState(EnvironmentalEvent event) async* {
    // Gestion des événements et transitions d'état
  }
}
```

## 🔄 Flux de Données

### **1. Collecte de Données (IoT → Backend)**

```
Capteur Ruuvi → Raspberry Pi → MQTT → Laravel → PostgreSQL
                                ↓
                        Traitement temps réel
                                ↓
                         WebSocket → Flutter
```

### **2. Classification d'Activité**

```
Accéléromètre → Buffer données → Algorithme ML → Classification
                    ↓                    ↓
            Stockage local        Envoi résultat → Notification
```

### **3. Synchronisation Offline/Online**

```
Mode Offline: Flutter → SQLite local
             ↓
Mode Online:  SQLite → API Laravel → PostgreSQL
                              ↓
                      Résolution conflits
```

## ⚡ Optimisations Performance

### **Backend Laravel**

- **Database Query Optimization**

  ```php
  // Index optimisés pour time series
  // Pagination cursor-based pour gros datasets
  // Eager loading pour éviter N+1 queries
  ```

- **Cache Strategy**

  ```php
  // Redis pour cache applicatif
  // Cache des API responses
  // Cache des requêtes complexes
  ```

- **Background Processing**
  ```php
  // Queues Redis pour traitement asynchrone
  // Jobs pour classification ML
  // Batch processing pour import données
  ```

### **Frontend Flutter**

- **State Management**

  ```dart
  // HydratedBloc pour persistance d'état
  // Lazy loading des données
  // Optimistic updates
  ```

- **Database Performance**

  ```dart
  // Index SQLite optimisés
  // Batch operations
  // Pagination locale
  ```

- **Network Optimization**
  ```dart
  // Dio interceptors pour retry automatique
  // Compression des requêtes
  // Cache HTTP intelligent
  ```

## 🔒 Sécurité

### **Backend**

- **API Security**: Laravel Sanctum, CORS configuré
- **Database**: Requêtes préparées, validation stricte
- **MQTT**: TLS encryption, authentification par certificats

### **Frontend**

- **Storage**: Flutter Secure Storage pour tokens
- **Network**: Certificate pinning, validation SSL
- **Local DB**: Encryption SQLite si données sensibles

## 📈 Monitoring & Logging

### **Backend Monitoring**

```php
// Laravel Telescope pour debugging
// Logs structurés (JSON)
// Métriques Prometheus
// Health checks automatiques
```

### **Frontend Analytics**

```dart
// Crash reporting (Firebase Crashlytics)
// Performance monitoring
// User analytics (anonymisées)
// Logs locaux rotatifs
```

## 🚀 Déploiement

### **Environnements**

1. **Development**: Docker Compose local
2. **Staging**: Docker Swarm ou Kubernetes
3. **Production**: Cloud (AWS/GCP) avec auto-scaling

### **CI/CD Pipeline**

```yaml
# Exemple GitHub Actions
- Linting et tests automatiques
- Build Docker images
- Déploiement automatique staging
- Tests d'intégration
- Déploiement production (manuel)
```

---

Cette architecture Laravel + Flutter offre **scalabilité**, **performance** et **maintenabilité** pour LifeCompanion, tout en restant simple à comprendre et développer ! 🎯
