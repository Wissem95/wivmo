# 🚀 Guide d'Installation LifeCompanion

Ce guide vous accompagne dans l'installation et la configuration complète de **LifeCompanion**, votre assistant environnemental personnel.

## 📋 Prérequis

### Systèmes supportés

- **macOS** 10.15+
- **Linux** (Ubuntu 20.04+, Debian 11+)
- **Windows** 10+ (avec WSL2 recommandé)

### Logiciels requis

#### 🐳 Docker & Docker Compose (Obligatoire)

```bash
# macOS (avec Homebrew)
brew install docker docker-compose

# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose

# Ou télécharger Docker Desktop
# https://www.docker.com/products/docker-desktop
```

#### 🐘 PHP 8.2+ (Optionnel - pour développement local)

```bash
# macOS
brew install php@8.2 composer

# Ubuntu/Debian
sudo apt install php8.2 php8.2-{cli,fpm,mysql,pgsql,sqlite3,curl,gd,mbstring,xml,zip} composer
```

#### 📱 Flutter SDK (Obligatoire pour mobile)

```bash
# Installation Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Vérifier l'installation
flutter doctor
```

#### 🔗 Outils supplémentaires

```bash
# Node.js (pour outils de build)
# macOS
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## 🛠️ Installation Automatique (Recommandée)

### 1. Cloner le projet

```bash
git clone https://github.com/votre-username/LifeCompanion.git
cd LifeCompanion
```

### 2. Rendre le script exécutable

```bash
chmod +x scripts/setup.sh
```

### 3. Lancer l'installation automatique

```bash
./scripts/setup.sh
```

Le script va automatiquement :

- ✅ Vérifier les prérequis
- ✅ Configurer Docker et les services
- ✅ Installer les dépendances Laravel
- ✅ Installer les dépendances Flutter
- ✅ Démarrer tous les services
- ✅ Initialiser la base de données

### 4. Vérifier l'installation

Après l'exécution du script, vous devriez voir :

```
🎉 Configuration de LifeCompanion terminée avec succès !
=========================================================

📋 Services disponibles :
  • Backend Laravel:     http://localhost:8000
  • Base de données:     localhost:5432
  • Redis:              localhost:6379
  • MQTT Broker:        localhost:1883
  • MQTT WebSocket:     localhost:9001
```

## 🔧 Installation Manuelle

Si vous préférez une installation manuelle ou rencontrez des problèmes :

### 1. Configuration Docker

```bash
# Créer les dossiers nécessaires
mkdir -p docker/{postgres,mosquitto}

# Démarrer les services de base
docker-compose up -d postgres redis mqtt

# Vérifier que les services sont actifs
docker-compose ps
```

### 2. Configuration Backend Laravel

```bash
cd backend

# Copier et éditer le fichier d'environnement
cp .env.example .env

# Installer les dépendances
composer install

# Générer la clé d'application
php artisan key:generate

# Exécuter les migrations
php artisan migrate:fresh --seed

# Démarrer le serveur (si développement local)
php artisan serve
```

### 3. Configuration Frontend Flutter

```bash
cd mobile

# Installer les dépendances
flutter pub get

# Générer les fichiers auto-générés
flutter packages pub run build_runner build --delete-conflicting-outputs

# Lancer l'application (avec un émulateur/device connecté)
flutter run
```

### 4. Configuration IoT (Raspberry Pi)

```bash
cd iot

# Installer les dépendances Python
pip install -r requirements.txt

# Configurer les variables d'environnement
cp .env.example .env

# Tester la connexion MQTT
python sensors/mqtt_test.py
```

## 🧪 Vérification de l'Installation

### Tests Backend

```bash
cd backend
php artisan test
```

### Tests Frontend

```bash
cd mobile
flutter test
```

### Test des services Docker

```bash
# Vérifier tous les services
docker-compose ps

# Tester la connexion à la base de données
docker-compose exec postgres psql -U lifecompanion -d lifecompanion -c "\dt"

# Tester Redis
docker-compose exec redis redis-cli ping

# Tester MQTT
docker-compose exec mqtt mosquitto_pub -h localhost -t test -m "Hello LifeCompanion"
```

## 🐛 Dépannage

### Problèmes courants

#### Port déjà utilisé

```bash
# Vérifier les ports utilisés
lsof -i :8000  # Backend Laravel
lsof -i :5432  # PostgreSQL
lsof -i :6379  # Redis
lsof -i :1883  # MQTT

# Modifier les ports dans docker-compose.yml si nécessaire
```

#### Erreurs de permissions Docker

```bash
# Ajouter votre utilisateur au groupe docker
sudo usermod -aG docker $USER

# Redémarrer votre session
newgrp docker
```

#### Erreurs Flutter

```bash
# Nettoyer le cache Flutter
flutter clean
flutter pub get

# Vérifier la configuration
flutter doctor
```

#### Erreurs Laravel

```bash
# Nettoyer le cache Laravel
php artisan cache:clear
php artisan config:clear
php artisan route:clear

# Réinstaller les dépendances
rm -rf vendor
composer install
```

### Logs de débogage

```bash
# Logs de tous les services
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs -f backend
docker-compose logs -f postgres

# Logs en temps réel
docker-compose logs --tail=50 -f
```

## 🔄 Mise à jour

### Mise à jour du code

```bash
# Sauvegarder les modifications locales
git stash

# Récupérer les dernières modifications
git pull origin main

# Restaurer les modifications si nécessaire
git stash pop

# Relancer l'installation
./scripts/setup.sh
```

### Mise à jour des dépendances

```bash
# Backend
cd backend && composer update

# Frontend
cd mobile && flutter pub upgrade

# Docker
docker-compose pull
docker-compose up -d --build
```

## 🚀 Démarrage Rapide après Installation

```bash
# Démarrer tous les services
docker-compose up -d

# Lancer le frontend mobile
cd mobile && flutter run

# Accéder au backend
open http://localhost:8000
```

## 📞 Support

Si vous rencontrez des problèmes :

1. **Consultez les logs** : `docker-compose logs -f`
2. **Vérifiez les prérequis** : `./scripts/setup.sh help`
3. **Consultez la documentation** : `README.md`
4. **Créez une issue** : [GitHub Issues](https://github.com/votre-username/LifeCompanion/issues)

---

> **Note** : Cette installation configure un environnement de développement complet. Pour un déploiement en production, consultez le guide de déploiement séparé.
