# 🏃‍♂️ Sprint 1 - Kickoff LifeCompanion

_Duration: 2 semaines (24 juin - 8 juillet 2025)_

## 🎯 **Objectifs du Sprint**

### 📋 **Sprint Goal**

Mettre en place l'architecture de base de LifeCompanion avec :

- Backend Laravel fonctionnel (API + Base de données)
- Frontend Flutter avec écrans de base
- Communication IoT de base (simulation)
- Pipeline de développement opérationnel

### 📊 **Métriques de Succès**

- [ ] API Laravel avec 5 endpoints fonctionnels
- [ ] App Flutter avec 3 écrans principaux
- [ ] Base de données avec données de test
- [ ] Docker compose opérationnel
- [ ] Tests unitaires de base (>60% couverture)

---

## 👥 **Équipe & Rôles**

| Rôle                      | Responsable | Tâches Principales                   |
| ------------------------- | ----------- | ------------------------------------ |
| **🏗️ Architecte/Lead**    | Wissem      | Architecture, coordination, review   |
| **⚙️ Backend Developer**  | Wissem      | Laravel API, base de données, IoT    |
| **📱 Frontend Developer** | Wissem      | Flutter app, UI/UX, state management |
| **🔌 IoT Developer**      | Wissem      | Raspberry Pi, capteurs, MQTT         |

---

## 📅 **Planning Sprint (2 semaines)**

### **Semaine 1 : Foundation**

- **Jour 1-2** : Setup environnement & architecture
- **Jour 3-4** : Backend API core
- **Jour 5** : Frontend base + intégration

### **Semaine 2 : Integration**

- **Jour 6-7** : IoT layer & communication
- **Jour 8-9** : Tests & optimisation
- **Jour 10** : Demo & documentation

---

## 📋 **Backlog Sprint**

### 🔥 **CRITICAL (Must Have)**

#### **T001 - Setup Environnement de Développement**

- **Points**: 5
- **Assigné**: Wissem
- **Description**: Configuration initiale du projet
- **Deliverables**:
  - Docker compose fonctionnel
  - Repositories git configurés
  - CI/CD pipeline de base
- **Prompt File**: [`tasks/T001_setup_environment.md`](tasks/T001_setup_environment.md)

#### **T002 - Backend Laravel API Core**

- **Points**: 13
- **Assigné**: Wissem
- **Description**: API REST de base avec authentification
- **Deliverables**:
  - Models User, Device, EnvironmentalReading
  - Controllers API avec CRUD
  - Authentication Sanctum
  - Migrations & Seeders
- **Prompt File**: [`tasks/T002_backend_api_core.md`](tasks/T002_backend_api_core.md)

#### **T003 - Frontend Flutter Foundation**

- **Points**: 13
- **Assigné**: Wissem
- **Description**: App Flutter avec architecture Bloc
- **Deliverables**:
  - Structure de dossiers optimisée
  - Bloc pattern setup
  - Écrans Home, Dashboard, Settings
  - Navigation et routing
- **Prompt File**: [`tasks/T003_frontend_flutter_foundation.md`](tasks/T003_frontend_flutter_foundation.md)

#### **T004 - Base de Données & Migrations**

- **Points**: 8
- **Assigné**: Wissem
- **Description**: Schema DB avec TimescaleDB
- **Deliverables**:
  - Migrations complètes
  - Seeders avec données test
  - Configuration TimescaleDB
  - Index optimisés
- **Prompt File**: [`tasks/T004_database_setup.md`](tasks/T004_database_setup.md)

### 🔥 **HIGH (Should Have)**

#### **T005 - IoT Communication Layer**

- **Points**: 8
- **Assigné**: Wissem
- **Description**: MQTT broker et simulation capteurs
- **Deliverables**:
  - MQTT broker configuré
  - Simulateur de capteurs Python
  - Laravel MQTT integration
  - Flutter MQTT client
- **Prompt File**: [`tasks/T005_iot_communication.md`](tasks/T005_iot_communication.md)

#### **T006 - API Integration Flutter**

- **Points**: 8
- **Assigné**: Wissem
- **Description**: Intégration API dans Flutter app
- **Deliverables**:
  - HTTP client avec Dio
  - Repository pattern
  - Error handling
  - Loading states
- **Prompt File**: [`tasks/T006_api_integration_flutter.md`](tasks/T006_api_integration_flutter.md)

### 🟡 **MEDIUM (Could Have)**

#### **T007 - Tests Unitaires**

- **Points**: 5
- **Assigné**: Wissem
- **Description**: Tests de base backend et frontend
- **Deliverables**:
  - Tests Laravel (Feature + Unit)
  - Tests Flutter (Widget + Unit)
  - Configuration CI/CD pour tests
- **Prompt File**: [`tasks/T007_unit_tests.md`](tasks/T007_unit_tests.md)

#### **T008 - Docker & Déploiement**

- **Points**: 5
- **Assigné**: Wissem
- **Description**: Containerisation et déploiement
- **Deliverables**:
  - Dockerfiles optimisés
  - Docker-compose pour prod
  - Scripts de déploiement
- **Prompt File**: [`tasks/T008_docker_deployment.md`](tasks/T008_docker_deployment.md)

---

## 📊 **Burndown Chart**

| Jour    | Points Restants | Tâches Complétées |
| ------- | --------------- | ----------------- |
| Jour 1  | 65              | -                 |
| Jour 2  | 60              | T001              |
| Jour 3  | 47              | T002              |
| Jour 4  | 34              | T003              |
| Jour 5  | 26              | T004              |
| Jour 6  | 18              | T005              |
| Jour 7  | 10              | T006              |
| Jour 8  | 5               | T007              |
| Jour 9  | 0               | T008              |
| Jour 10 | 0               | Review & Demo     |

---

## 🔄 **Ceremonies Sprint**

### **Daily Standups** (15min - 9h00)

- **Hier**: Qu'est-ce qui a été fait ?
- **Aujourd'hui**: Qu'est-ce qui va être fait ?
- **Blockers**: Y a-t-il des obstacles ?

### **Sprint Review** (2h - Vendredi semaine 2)

- Demo des fonctionnalités développées
- Feedback stakeholders
- Mise à jour du product backlog

### **Sprint Retrospective** (1h - Vendredi semaine 2)

- **Start**: Quoi commencer à faire ?
- **Stop**: Quoi arrêter de faire ?
- **Continue**: Quoi continuer à faire ?

---

## 🛠️ **Outils & Technologies**

### **Développement**

- **Backend**: Laravel 11 + PostgreSQL + TimescaleDB + Redis
- **Frontend**: Flutter 3.24+ + Bloc Pattern
- **IoT**: Python + MQTT + Raspberry Pi (simulé)
- **Containerisation**: Docker + Docker Compose

### **Collaboration**

- **Code**: Git + GitHub
- **Communication**: Discord/Slack
- **Documentation**: Markdown + GitHub Wiki
- **Planning**: GitHub Projects

### **CI/CD**

- **Pipeline**: GitHub Actions
- **Tests**: PHPUnit + Flutter Test
- **Quality**: ESLint, Prettier, PHPStan

---

## 📝 **Definition of Done**

### **Backend (Laravel)**

- [ ] Code respectant PSR-12
- [ ] Tests unitaires et fonctionnels
- [ ] Documentation API (Swagger)
- [ ] Validation des données
- [ ] Gestion d'erreurs complète

### **Frontend (Flutter)**

- [ ] Code respectant les conventions Dart
- [ ] Tests widget et unitaires
- [ ] Responsive design
- [ ] Gestion d'état avec Bloc
- [ ] Gestion d'erreurs et loading states

### **IoT**

- [ ] Code Python documenté
- [ ] Simulation de capteurs fonctionnelle
- [ ] Communication MQTT stable
- [ ] Gestion des erreurs de connexion

### **Général**

- [ ] Code reviewé et approuvé
- [ ] Documentation mise à jour
- [ ] Tests passant en CI/CD
- [ ] Déployé en environnement de test

---

## 🚨 **Risques & Mitigation**

| Risque                          | Impact | Probabilité | Mitigation                               |
| ------------------------------- | ------ | ----------- | ---------------------------------------- |
| **Complexité TimescaleDB**      | High   | Medium      | Documentation + tests simples d'abord    |
| **Intégration Flutter/Laravel** | Medium | Low         | Développement en parallèle + tests early |
| **Performance MQTT**            | Medium | Low         | Simulation + tests de charge             |
| **Scope creep**                 | High   | Medium      | Definition of Done stricte               |

---

## 📚 **Ressources & Documentation**

### **Documentation Technique**

- [Architecture Guide](ARCHITECTURE.md)
- [API Documentation](docs/api.md)
- [Flutter Style Guide](docs/flutter-style.md)
- [Database Schema](docs/database.md)

### **MCP Resources**

- Laravel Documentation via MCP
- Flutter Documentation via MCP
- TimescaleDB Documentation via MCP
- MQTT Protocol Documentation via MCP

---

## ✅ **Checklist de Démarrage**

### **Avant de Commencer**

- [ ] Lire l'ARCHITECTURE.md complètement
- [ ] Setup environnement de développement
- [ ] Cloner les repositories
- [ ] Installer les dépendances
- [ ] Lancer les tests de base

### **Premier Jour**

- [ ] Standup meeting 9h00
- [ ] Assigner les tâches définitivement
- [ ] Commencer T001 - Setup Environnement
- [ ] Créer les branches de développement
- [ ] Setup communication quotidienne

---

_Sprint créé le 24 juin 2025 - LifeCompanion Project_
