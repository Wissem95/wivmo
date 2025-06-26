# 🐳 T008 - Docker & Déploiement

**Sprint**: 1 | **Points**: 5 | **Assigné**: Wissem | **Priorité**: MEDIUM

---

## 🎯 **Objectif**

Containeriser l'application complète avec Docker et configurer les environnements de déploiement pour dev, staging et production.

## 📋 **Acceptance Criteria**

- [ ] Dockerfiles optimisés pour Laravel et Flutter Web
- [ ] Docker Compose pour développement complet
- [ ] Configuration multi-environnements (dev/staging/prod)
- [ ] Scripts de déploiement automatisés
- [ ] Load balancer et reverse proxy configurés
- [ ] Monitoring et logging centralisés
- [ ] Backup automatisé des données
- [ ] Documentation de déploiement complète

---

## 🔧 **Prompts à Utiliser**

### **1. Dockerfiles Optimisés**

```bash
# Prompt pour Dockerfiles production
Je veux créer des Dockerfiles optimisés pour un projet Laravel/Flutter IoT.

**Services à containeriser** :
- **Laravel API** : PHP 8.2 + Nginx + optimisations production
- **Flutter Web** : build optimisé + nginx serving
- **PostgreSQL** : TimescaleDB avec données persistantes
- **Redis** : cache et queues avec persistance
- **MQTT Broker** : Mosquitto avec configuration sécurisée

**Optimisations requises** :
- **Multi-stage builds** pour réduire la taille
- **Security** : non-root users, minimal base images
- **Performance** : PHP-FPM optimisé, nginx caching
- **Monitoring** : health checks, metrics exposition

**Environnements** :
- **Development** : hot reload, debugging tools
- **Staging** : proche de production, monitoring
- **Production** : sécurisé, optimisé, scalable

J'ai besoin de :
- Dockerfiles multi-stage pour chaque service
- Configuration nginx optimisée
- Variables d'environnement sécurisées
- Health checks appropriés
- Documentation des images

Fournis des Dockerfiles complets avec optimisations.
```

### **2. Docker Compose Orchestration**

```bash
# Prompt pour Docker Compose
Je configure Docker Compose pour une stack complète Laravel/Flutter/IoT.

**Services architecture** :
```

Frontend (Flutter Web) → Load Balancer → Laravel API
↓
PostgreSQL + Redis + MQTT
↓
Monitoring Stack

```

**Services nécessaires** :
- **nginx-proxy** : reverse proxy + load balancing
- **laravel-api** : application backend (multiple instances)
- **flutter-web** : frontend web application
- **postgres** : base de données avec TimescaleDB
- **redis** : cache et queues
- **mosquitto** : MQTT broker
- **prometheus** : monitoring métrique
- **grafana** : dashboards
- **loki** : log aggregation

**Fonctionnalités** :
- Load balancing automatique
- Scaling horizontal des services
- Réseaux isolés pour sécurité
- Volumes persistants pour données
- Configuration par environnement

J'ai besoin de :
- docker-compose.yml pour dev/staging/prod
- Configuration réseau et volumes
- Variables d'environnement par env
- Health checks et dependencies
- Scripts de gestion (start/stop/scale)

Fournis la configuration complète Docker Compose.
```

### **3. Scripts de Déploiement**

```bash
# Prompt pour automatisation déploiement
Je veux automatiser le déploiement de mon application IoT Laravel/Flutter.

**Environnements cibles** :
- **Local Development** : Docker Compose simple
- **Staging Server** : VPS avec Docker Swarm ou docker-compose
- **Production** : Cloud (AWS/GCP) avec Kubernetes ou Docker Swarm

**Pipeline de déploiement** :
1. **Build & Test** : CI/CD avec GitHub Actions
2. **Image Creation** : Docker build + push to registry
3. **Database Migration** : automated schema updates
4. **Application Deployment** : zero-downtime deployment
5. **Health Checks** : verification post-deployment
6. **Rollback** : automatic rollback si failure

**Scripts nécessaires** :
- `deploy.sh` : déploiement principal
- `rollback.sh` : rollback automatique
- `backup.sh` : backup BDD et fichiers
- `scale.sh` : scaling horizontal
- `logs.sh` : agrégation de logs

**Configuration** :
- Secrets management (Docker secrets/Kubernetes secrets)
- Blue-green deployment ou rolling updates
- Database migration strategy
- Static files handling (CDN)

J'ai besoin de :
- Scripts bash robustes avec error handling
- Configuration par environnement
- Documentation step-by-step
- Monitoring et alerting
- Stratégie de rollback

Fournis les scripts complets avec gestion d'erreurs.
```

### **4. Monitoring et Observabilité**

```bash
# Prompt pour monitoring stack
Je configure une stack de monitoring complète pour mon app IoT.

**Métriques à surveiller** :
- **Application** : response time, error rate, throughput
- **Infrastructure** : CPU, memory, disk, network
- **Database** : query performance, connections, slow queries
- **MQTT** : message rate, connections, latency
- **Business** : active users, sensor data rate, alerts

**Stack monitoring** :
- **Prometheus** : collecte des métriques
- **Grafana** : dashboards et visualizations
- **Loki** : log aggregation
- **Jaeger** : distributed tracing
- **AlertManager** : alerting rules

**Dashboards requis** :
- Application performance (Laravel metrics)
- Infrastructure monitoring (node exporter)
- Database performance (PostgreSQL metrics)
- IoT metrics (MQTT, sensor data rates)
- Business metrics (users, activities)

**Alerting** :
- Critical errors (5xx responses > threshold)
- Performance degradation (latency > 2s)
- Infrastructure issues (disk space < 10%)
- Business alerts (no sensor data for 1h)

J'ai besoin de :
- Configuration Prometheus complète
- Dashboards Grafana prêts à l'emploi
- Rules d'alerting robustes
- Integration avec notification channels
- Documentation monitoring

Fournis une stack de monitoring complète.
```

---

## 📝 **Actions Détaillées**

### **Étape 1 : Dockerfiles Optimisés**

1. **Dockerfile Laravel API**

   ```dockerfile
   # Multi-stage build pour Laravel
   FROM php:8.2-fpm as builder
   # Build dependencies et optimizations

   FROM php:8.2-fpm as production
   # Runtime optimisé
   ```

2. **Dockerfile Flutter Web**

   ```dockerfile
   # Multi-stage pour Flutter
   FROM cirrusci/flutter:stable as builder
   # Build web app

   FROM nginx:alpine as production
   # Serve static files
   ```

### **Étape 2 : Docker Compose**

1. **Structure multi-environnements**

   ```
   docker/
   ├── docker-compose.yml (base)
   ├── docker-compose.dev.yml
   ├── docker-compose.staging.yml
   ├── docker-compose.prod.yml
   └── .env.example
   ```

2. **Configuration services**

### **Étape 3 : Scripts de Déploiement**

1. **Scripts principaux**
2. **Configuration CI/CD**
3. **Tests de déploiement**

### **Étape 4 : Monitoring**

1. **Configuration Prometheus**
2. **Dashboards Grafana**
3. **Alerting rules**

---

## 🐳 **Dockerfile Laravel - Exemple**

```dockerfile
# syntax=docker/dockerfile:1.4
FROM php:8.2-fpm as base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_pgsql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    opcache

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Configure PHP for production
COPY docker/php/php.ini /usr/local/etc/php/

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Builder stage
FROM base as builder

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

COPY . .
RUN composer dump-autoload --optimize

# Production stage
FROM base as production

# Create user for Laravel
RUN groupadd -g 1000 www && \
    useradd -u 1000 -ms /bin/bash -g www www

# Copy application
COPY --from=builder --chown=www:www /var/www /var/www

# Switch to non-root user
USER www

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:9000/health || exit 1

EXPOSE 9000

CMD ["php-fpm"]
```

---

## 🐳 **Docker Compose - Exemple**

```yaml
version: '3.8'

services:
  # Reverse Proxy
  nginx-proxy:
    image: nginx:alpine
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./docker/nginx/ssl:/etc/nginx/ssl
    depends_on:
      - laravel-api
      - flutter-web
    networks:
      - frontend

  # Laravel API
  laravel-api:
    build:
      context: ./backend
      dockerfile: Dockerfile
      target: production
    environment:
      - APP_ENV=${APP_ENV:-production}
      - DB_HOST=postgres
      - REDIS_HOST=redis
      - MQTT_HOST=mosquitto
    volumes:
      - storage_data:/var/www/storage
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - frontend
      - backend
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3

  # Flutter Web
  flutter-web:
    build:
      context: ./mobile
      dockerfile: Dockerfile
      target: production
    environment:
      - API_BASE_URL=https://api.lifecompanion.app
    networks:
      - frontend

  # Database
  postgres:
    image: timescale/timescaledb:latest-pg13
    environment:
      POSTGRES_DB: ${DB_DATABASE}
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./docker/postgres/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - backend
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U ${DB_USERNAME}']
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis
  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - backend
    healthcheck:
      test: ['CMD', 'redis-cli', 'ping']
      interval: 10s
      timeout: 5s
      retries: 5

  # MQTT Broker
  mosquitto:
    image: eclipse-mosquitto:2.0
    volumes:
      - ./docker/mosquitto:/mosquitto/config
      - mosquitto_data:/mosquitto/data
      - mosquitto_logs:/mosquitto/log
    ports:
      - '1883:1883'
      - '9001:9001'
    networks:
      - backend

  # Monitoring
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./docker/prometheus:/etc/prometheus
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
    ports:
      - '9090:9090'
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:latest
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}
    volumes:
      - grafana_data:/var/lib/grafana
      - ./docker/grafana/provisioning:/etc/grafana/provisioning
    ports:
      - '3000:3000'
    networks:
      - monitoring
    depends_on:
      - prometheus

volumes:
  postgres_data:
  redis_data:
  mosquitto_data:
  mosquitto_logs:
  storage_data:
  prometheus_data:
  grafana_data:

networks:
  frontend:
  backend:
  monitoring:
```

---

## 📜 **Script de Déploiement - Exemple**

```bash
#!/bin/bash

# deploy.sh - Script de déploiement LifeCompanion
set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV=${1:-staging}
VERSION=${2:-latest}

# Colors pour output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# Validation environnement
validate_environment() {
    if [[ ! "$ENV" =~ ^(dev|staging|prod)$ ]]; then
        error "Environnement invalide: $ENV. Utilisez: dev, staging, ou prod"
    fi

    if [[ ! -f ".env.$ENV" ]]; then
        error "Fichier .env.$ENV non trouvé"
    fi
}

# Backup base de données
backup_database() {
    log "Backup de la base de données..."

    BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    docker-compose -f docker-compose.$ENV.yml exec -T postgres \
        pg_dump -U lifecompanion lifecompanion > "$BACKUP_DIR/database.sql"

    log "Backup sauvegardé dans: $BACKUP_DIR"
}

# Build et push images
build_and_push() {
    log "Build des images Docker..."

    # Build Laravel API
    docker build -t lifecompanion/api:$VERSION ./backend

    # Build Flutter Web
    docker build -t lifecompanion/web:$VERSION ./mobile

    # Push vers registry si production
    if [[ "$ENV" == "prod" ]]; then
        log "Push vers registry..."
        docker push lifecompanion/api:$VERSION
        docker push lifecompanion/web:$VERSION
    fi
}

# Déploiement
deploy() {
    log "Déploiement vers $ENV..."

    # Copy environment file
    cp ".env.$ENV" .env

    # Pull latest changes si staging/prod
    if [[ "$ENV" != "dev" ]]; then
        git pull origin main
    fi

    # Stop services
    docker-compose -f docker-compose.$ENV.yml down

    # Start services
    docker-compose -f docker-compose.$ENV.yml up -d

    # Wait for services
    log "Attente du démarrage des services..."
    sleep 30
}

# Migrations base de données
run_migrations() {
    log "Exécution des migrations..."

    docker-compose -f docker-compose.$ENV.yml exec laravel-api \
        php artisan migrate --force
}

# Health checks
health_checks() {
    log "Vérification de la santé des services..."

    # Check API health
    for i in {1..30}; do
        if curl -f http://localhost/api/health >/dev/null 2>&1; then
            log "API health check: OK"
            break
        fi

        if [[ $i -eq 30 ]]; then
            error "API health check failed après 30 tentatives"
        fi

        sleep 2
    done

    # Check database connection
    docker-compose -f docker-compose.$ENV.yml exec laravel-api \
        php artisan tinker --execute="DB::connection()->getPdo();" || error "Database connection failed"

    log "Tous les health checks sont OK"
}

# Cleanup
cleanup() {
    log "Nettoyage..."

    # Remove unused images
    docker image prune -f

    # Remove old backups (keep last 10)
    ls -t backups/ | tail -n +11 | xargs -r rm -rf
}

# Rollback function
rollback() {
    warn "Rollback en cours..."

    # Get previous version
    PREVIOUS_VERSION=$(docker images --format "table {{.Repository}}:{{.Tag}}" | grep lifecompanion/api | sed -n '2p' | cut -d':' -f2)

    if [[ -z "$PREVIOUS_VERSION" ]]; then
        error "Aucune version précédente trouvée pour rollback"
    fi

    # Rollback to previous version
    ENV="$ENV" VERSION="$PREVIOUS_VERSION" deploy

    warn "Rollback vers version $PREVIOUS_VERSION terminé"
}

# Signal handlers
trap 'error "Déploiement interrompu"' INT TERM

# Main deployment process
main() {
    log "Début du déploiement LifeCompanion"
    log "Environnement: $ENV"
    log "Version: $VERSION"

    validate_environment

    if [[ "$ENV" != "dev" ]]; then
        backup_database
    fi

    build_and_push
    deploy
    run_migrations
    health_checks
    cleanup

    log "Déploiement terminé avec succès! 🎉"
    log "Application disponible sur: http://localhost"
}

# Help
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    echo "Usage: $0 [ENVIRONMENT] [VERSION]"
    echo ""
    echo "ENVIRONMENT: dev, staging, prod (default: staging)"
    echo "VERSION: version tag (default: latest)"
    echo ""
    echo "Examples:"
    echo "  $0 dev"
    echo "  $0 staging v1.2.0"
    echo "  $0 prod latest"
    echo ""
    echo "Pour rollback:"
    echo "  $0 [ENVIRONMENT] --rollback"
    exit 0
fi

# Rollback handling
if [[ "${2:-}" == "--rollback" ]]; then
    rollback
    exit 0
fi

# Run main function
main "$@"
```

---

## 📊 **Configuration Monitoring - Prometheus**

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - 'alert_rules.yml'

alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager:9093

scrape_configs:
  # Laravel API metrics
  - job_name: 'laravel-api'
    static_configs:
      - targets: ['laravel-api:9000']
    metrics_path: /metrics
    scrape_interval: 30s

  # PostgreSQL metrics
  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres-exporter:9187']

  # Redis metrics
  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']

  # MQTT metrics
  - job_name: 'mosquitto'
    static_configs:
      - targets: ['mosquitto-exporter:9234']

  # Node metrics
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
```

---

## ✅ **Definition of Done**

- [ ] Dockerfiles optimisés et multi-stage
- [ ] Docker Compose pour tous les environnements
- [ ] Scripts de déploiement robustes et testés
- [ ] Configuration monitoring complète
- [ ] Health checks pour tous les services
- [ ] Backup automatisé configuré
- [ ] Documentation déploiement à jour
- [ ] Tests de déploiement passants

---

## 🔗 **Dépendances**

- **Précédent**: T001 à T007 - Toutes les tâches fondamentales
- **Suivant**: Sprint 2 - Fonctionnalités avancées

---

## 📚 **Ressources**

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Prometheus Monitoring](https://prometheus.io/docs/)
- [Grafana Dashboards](https://grafana.com/docs/)

---

_Tâche créée le 25 juin 2025 - LifeCompanion Project_
