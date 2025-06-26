# 🎯 LifeCompanion - Assistant Environnemental Personnel

> **LifeCompanion** est un assistant environnemental personnel portable qui analyse en temps réel les conditions de votre environnement et fournit des insights intelligents sur votre bien-être et vos déplacements quotidiens.

## 🏗️ Architecture Technique

### Stack Technologique

**Backend - Laravel**

- **Framework**: Laravel 11
- **Base de données**: PostgreSQL + TimescaleDB
- **Authentification**: Laravel Sanctum
- **Temps réel**: Laravel WebSockets + MQTT
- **Cache/Queues**: Redis
- **Monitoring**: Laravel Telescope

**Frontend - Flutter**

- **Framework**: Flutter 3.24+
- **État**: Bloc Pattern + Cubit
- **HTTP**: Dio Client
- **Base locale**: SQLite (sqflite)
- **Temps réel**: WebSocket + MQTT
- **Notifications**: Flutter Local Notifications

**IoT & Communication**

- **Protocole**: MQTT (Mosquitto)
- **Hardware**: Raspberry Pi + Capteurs Ruuvi
- **Classification**: Python + ML

## 📂 Structure du Projet

```
LifeCompanion/
├── backend/                    # Laravel API Backend
│   ├── app/
│   │   ├── Http/Controllers/
│   │   ├── Models/
│   │   ├── Services/
│   │   └── Jobs/
│   ├── database/
│   │   ├── migrations/
│   │   └── seeders/
│   └── routes/
├── mobile/                     # Flutter Mobile App
│   ├── lib/
│   │   ├── blocs/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── services/
│   │   └── ui/
│   └── pubspec.yaml
├── iot/                        # Raspberry Pi Scripts
│   ├── sensors/
│   ├── mqtt/
│   └── classification/
├── docker/                     # Configuration Docker
└── docs/                       # Documentation
```

## 🚀 Fonctionnalités Clés

### 1. **Monitoring Environnemental Intelligent**

- Mesure continue des conditions (température, humidité, pression)
- Score de confort instantané personnalisé
- Historique des environnements traversés

### 2. **Détection et Classification d'Activités**

- **Statique**: Travail, repos, attente
- **Marche**: Déplacement à pied, intensité
- **Transport**: Bus, voiture, train (via patterns de vibration)
- **Activité Intense**: Sport, manipulation d'objets

### 3. **Assistant Conversationnel**

- Notifications intelligentes en temps réel
- Réponses aux questions sur l'historique
- Recommandations personnalisées

### 4. **Visualisation et Analytics**

- Timeline interactive de la journée
- Cartographie des déplacements avec overlay environnemental
- Graphiques de corrélation activité/confort

## 🔧 Installation et Configuration

### Prérequis

- PHP 8.2+
- Composer
- Node.js 18+
- Flutter SDK 3.24+
- PostgreSQL 13+
- Redis 6+
- Docker & Docker Compose

### Backend Laravel

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve
```

### Frontend Flutter

```bash
cd mobile
flutter pub get
flutter run
```

### IoT (Raspberry Pi)

```bash
cd iot
pip install -r requirements.txt
python sensors/ruuvi_reader.py
```

### Docker (Développement)

```bash
docker-compose up -d
```

## 📊 Modèles de Données

### Backend (Laravel)

- **User**: Utilisateurs de l'application
- **Device**: Appareils IoT connectés
- **EnvironmentalReading**: Mesures environnementales
- **ActivityClassification**: Classifications d'activités
- **Notification**: Notifications intelligentes

### Frontend (Flutter)

- **EnvironmentalData**: Données environnementales locales
- **ActivityLog**: Journal des activités
- **UserPreferences**: Préférences utilisateur
- **DeviceSettings**: Configuration des appareils

## 🎭 Scénarios d'Usage

### Scénario 1: Journée Type d'Étudiant

```
8h00 - Réveil, LifeCompanion détecte environnement "chambre" (22°C, 45% humidité)
8h30 - Mouvement détecté → "Transport" (vibrations régulières)
9h00 - Statique → "Salle de cours" (25°C, 60% humidité)
      → Notification : "Température élevée détectée, hydratation recommandée"
12h00 - Marche → "Déplacement cafétéria"
14h00 - Statique → "Bibliothèque" (21°C, 40% humidité)
       → "Conditions optimales pour le travail !"
```

### Scénario 2: Analyse Hebdomadaire

```
Interface LifeCompanion :
"Cette semaine, vous avez passé 60% de votre temps dans des conditions
de confort optimal. Votre meilleur environnement : Bibliothèque universitaire
(21°C, 42% humidité). Recommandation : Évitez la salle B102 entre 14h-16h
(surchauffe récurrente)."
```

## 🗓️ Planning de Développement

### Phase 1: Foundation (Jour 1-2)

- ✅ Configuration initiale Laravel + Flutter
- ✅ Base de données et migrations
- ✅ Architecture de base et modèles

### Phase 2: Core Features (Jour 2-3)

- ⏳ API REST Laravel complète
- ⏳ Interface Flutter basique
- ⏳ Communication MQTT

### Phase 3: Advanced Features (Jour 3-4)

- ⏳ Classification d'activités
- ⏳ Notifications intelligentes
- ⏳ Visualisations avancées

### Phase 4: Polish & Demo (Jour 4-5)

- ⏳ Tests et optimisations
- ⏳ Documentation finale
- ⏳ Préparation démonstration

## 🧪 Tests

### Backend

```bash
php artisan test
```

### Frontend

```bash
flutter test
```

## 📚 Documentation API

L'API REST est documentée avec Swagger et accessible à `/api/documentation` en mode développement.

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Commit les changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Équipe

- **Développeur Principal**: Votre nom
- **Architecture**: Stack Laravel + Flutter
- **IoT**: Raspberry Pi + Capteurs Ruuvi

---

> **Note**: Ce projet a été développé dans le cadre d'un projet étudiant, démontrant l'intégration de technologies modernes pour créer un assistant personnel intelligent.
