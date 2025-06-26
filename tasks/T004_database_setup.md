# 🗄️ T004 - Base de Données & Migrations

**Sprint**: 1 | **Points**: 8 | **Assigné**: Wissem | **Priorité**: CRITICAL

---

## 🎯 **Objectif**

Configurer PostgreSQL avec TimescaleDB, créer le schéma de données optimisé pour les time-series et implémenter les migrations Laravel.

## 📋 **Acceptance Criteria**

- [ ] PostgreSQL 13+ configuré dans Docker
- [ ] Extension TimescaleDB activée et fonctionnelle
- [ ] Migrations Laravel complètes pour tous les modèles
- [ ] Hypertables configurées pour les données temporelles
- [ ] Index optimisés pour les requêtes IoT
- [ ] Seeders avec données réalistes (1000+ entrées)
- [ ] Configuration de connexion Laravel optimisée
- [ ] Backup et restore scripts fonctionnels

---

## 🔧 **Prompts à Utiliser**

### **1. Configuration PostgreSQL + TimescaleDB**

```bash
# Prompt pour TimescaleDB setup
Je configure une base de données pour une application IoT Laravel.
Données à stocker :
- **Lectures environnementales** : temperature, humidity, pressure (high frequency)
- **Classifications d'activités** : user_id, activity_type, timestamps
- **Utilisateurs et devices** : données standard relationnelles
- **Notifications** : messages, statuts, timestamps

J'ai besoin de :
- Configuration Docker PostgreSQL + TimescaleDB
- Setup initial database et extensions
- Configuration Laravel pour TimescaleDB
- Optimisations performance pour time-series
- Scripts de maintenance et backup

**Requirements** :
- Support 10,000+ readings/jour par device
- Requêtes rapides sur périodes (1h, 1j, 1sem, 1mois)
- Retention automatique des anciennes données
- Index optimisés pour les time-based queries

Fournis la configuration complète avec Docker et Laravel.
```

### **2. Migrations Laravel Optimisées**

```bash
# Prompt pour migrations time-series
Je crée des migrations Laravel pour une app IoT avec TimescaleDB.

**Tables principales** :
- **users** : id, name, email, preferences, settings, created_at, updated_at
- **devices** : id, user_id, type, mac_address, mqtt_topic, is_active, metadata, created_at, updated_at
- **environmental_readings** : id, device_id, measured_at, temperature, humidity, pressure, air_quality, battery_level
- **activity_classifications** : id, user_id, started_at, ended_at, activity_type, confidence_score, metadata
- **notifications** : id, user_id, title, message, type, status, sent_at, read_at, created_at

**Optimisations TimescaleDB** :
- Hypertables sur environmental_readings et activity_classifications
- Partitioning par temps (1 semaine)
- Index composites optimisés
- Retention policies automatiques
- Compression des anciennes données

J'ai besoin de :
- Migrations Laravel complètes
- Configuration des hypertables
- Index optimisés pour les requêtes fréquentes
- Policies de retention
- Contraintes de validation

Fournis les migrations avec optimisations TimescaleDB.
```

### **3. Seeders et Données de Test**

```bash
# Prompt pour seeders réalistes
Je veux créer des seeders Laravel pour une app IoT avec données réalistes.

**Données à générer** :
- **5 utilisateurs** avec différents profils
- **15 devices** (3 par utilisateur en moyenne)
- **50,000 environmental_readings** sur 30 jours
- **5,000 activity_classifications** avec patterns réalistes
- **500 notifications** avec différents types

**Patterns réalistes** :
- Lectures environnementales : variations journalières naturelles
- Activités : patterns humains (travail, transport, repos)
- Notifications : basées sur seuils dépassés
- Corrélation temporelle entre activités et environnement

J'ai besoin de :
- Seeders avec Factory pattern
- Données cohérentes temporellement
- Variety dans les types d'activités
- Realistic environmental variations
- Performance optimized seeding

Fournis les seeders complets avec Factory classes.
```

### **4. Configuration Performance Laravel**

```bash
# Prompt pour optimisation Laravel DB
Je configure Laravel pour une app IoT avec haute fréquence de données.

**Besoins performance** :
- Insertions en batch (1000+ readings/min)
- Requêtes rapides sur time-ranges
- Pagination efficace sur gros datasets
- Connection pooling optimisé
- Cache des requêtes fréquentes

**Configuration nécessaire** :
- Database connections multiples (read/write)
- Query builder optimisé pour TimescaleDB
- Cache Redis pour aggregations
- Lazy loading des relations
- Background jobs pour traitements lourds

J'ai besoin de :
- Configuration database.php optimisée
- Query scopes pour time-based queries
- Cache strategy pour data aggregation
- Queue configuration pour async processing
- Monitoring et profiling setup

Fournis la configuration complète avec exemples.
```

---

## 📝 **Actions Détaillées**

### **Étape 1 : Configuration Docker PostgreSQL**

1. **Créer le Dockerfile PostgreSQL + TimescaleDB**

   ```dockerfile
   FROM timescale/timescaledb:latest-pg13
   # Configuration optimisée
   ```

2. **Configurer docker-compose.yml**

   ```yaml
   postgres:
     image: timescale/timescaledb:latest-pg13
     environment:
       POSTGRES_DB: lifecompanion
       POSTGRES_USER: postgres
       POSTGRES_PASSWORD: secret
     volumes:
       - postgres_data:/var/lib/postgresql/data
       - ./docker/postgres:/docker-entrypoint-initdb.d
   ```

3. **Scripts d'initialisation DB**
   ```sql
   -- Activer TimescaleDB
   CREATE EXTENSION IF NOT EXISTS timescaledb;
   ```

### **Étape 2 : Configuration Laravel**

1. **Configurer database.php**
   ```php
   'connections' => [
       'pgsql' => [
           'driver' => 'pgsql',
           'host' => env('DB_HOST', '127.0.0.1'),
           'port' => env('DB_PORT', '5432'),
           'database' => env('DB_DATABASE', 'lifecompanion'),
           'username' => env('DB_USERNAME', 'postgres'),
           'password' => env('DB_PASSWORD', 'secret'),
           'charset' => 'utf8',
           'prefix' => '',
           'schema' => 'public',
           'sslmode' => 'prefer',
       ],
   ]
   ```

### **Étape 3 : Migrations**

1. **Créer les migrations principales**

   ```bash
   php artisan make:migration create_users_table
   php artisan make:migration create_devices_table
   php artisan make:migration create_environmental_readings_table
   php artisan make:migration create_activity_classifications_table
   php artisan make:migration create_notifications_table
   ```

2. **Implémenter les hypertables TimescaleDB**
3. **Ajouter les index optimisés**

### **Étape 4 : Seeders et Factories**

1. **Créer les factories**

   ```bash
   php artisan make:factory UserFactory
   php artisan make:factory DeviceFactory
   php artisan make:factory EnvironmentalReadingFactory
   ```

2. **Implémenter des données réalistes**
3. **Optimiser le seeding performance**

### **Étape 5 : Optimisations**

1. **Configuration connection pooling**
2. **Index composites**
3. **Policies de retention**

---

## 🗃️ **Schema de Base de Données**

### **Table: users**

```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NOT NULL,
    preferences JSONB DEFAULT '{}',
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

### **Table: devices**

```sql
CREATE TABLE devices (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    type VARCHAR(50) NOT NULL,
    mac_address VARCHAR(17) UNIQUE NOT NULL,
    mqtt_topic VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

### **Hypertable: environmental_readings**

```sql
CREATE TABLE environmental_readings (
    id BIGSERIAL,
    device_id BIGINT NOT NULL REFERENCES devices(id),
    measured_at TIMESTAMP NOT NULL,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    pressure DECIMAL(7,2),
    air_quality INTEGER,
    battery_level INTEGER
);

-- Convertir en hypertable
SELECT create_hypertable('environmental_readings', 'measured_at');
```

### **Hypertable: activity_classifications**

```sql
CREATE TABLE activity_classifications (
    id BIGSERIAL,
    user_id BIGINT NOT NULL REFERENCES users(id),
    started_at TIMESTAMP NOT NULL,
    ended_at TIMESTAMP,
    activity_type VARCHAR(50) NOT NULL,
    confidence_score DECIMAL(3,2),
    metadata JSONB DEFAULT '{}'
);

-- Convertir en hypertable
SELECT create_hypertable('activity_classifications', 'started_at');
```

### **Table: notifications**

```sql
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    message TEXT,
    type VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'unread',
    sent_at TIMESTAMP NOT NULL DEFAULT NOW(),
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

---

## 📊 **Index Optimisés**

### **Index pour Time-Series Queries**

```sql
-- Environmental readings
CREATE INDEX idx_environmental_device_time
ON environmental_readings (device_id, measured_at DESC);

CREATE INDEX idx_environmental_time_temp
ON environmental_readings (measured_at, temperature);

-- Activity classifications
CREATE INDEX idx_activity_user_time
ON activity_classifications (user_id, started_at DESC);

CREATE INDEX idx_activity_type_time
ON activity_classifications (activity_type, started_at);

-- Notifications
CREATE INDEX idx_notifications_user_status
ON notifications (user_id, status, sent_at DESC);
```

---

## 🔄 **Policies de Retention**

```sql
-- Garder 1 an de données environmental_readings
SELECT add_retention_policy('environmental_readings', INTERVAL '1 year');

-- Garder 2 ans de activity_classifications
SELECT add_retention_policy('activity_classifications', INTERVAL '2 years');

-- Compression après 1 mois
SELECT add_compression_policy('environmental_readings', INTERVAL '1 month');
```

---

## 🧪 **Tests à Implémenter**

### **Tests Migrations**

```php
// MigrationTest.php
- test_all_tables_created()
- test_hypertables_configured()
- test_indexes_exist()
- test_foreign_keys_work()
```

### **Tests Performance**

```php
// PerformanceTest.php
- test_bulk_insert_performance()
- test_time_range_query_speed()
- test_aggregation_queries()
```

### **Tests Seeders**

```php
// SeederTest.php
- test_seeders_create_realistic_data()
- test_data_relationships_valid()
- test_time_sequences_logical()
```

---

## ✅ **Definition of Done**

- [ ] PostgreSQL + TimescaleDB fonctionnel en Docker
- [ ] Toutes les migrations executées avec succès
- [ ] Hypertables configurées et optimisées
- [ ] Index créés et performance validée
- [ ] Seeders générés des données réalistes
- [ ] Policies de retention configurées
- [ ] Tests de base de données passants
- [ ] Configuration Laravel optimisée
- [ ] Scripts backup/restore fonctionnels

---

## 🔗 **Dépendances**

- **Précédent**: T001 - Setup Environnement
- **Suivant**: T002 - Backend API Core, T005 - IoT Communication

---

## 📚 **Ressources**

- [TimescaleDB Documentation](https://docs.timescale.com/)
- [Laravel Migrations](https://laravel.com/docs/11.x/migrations)
- [PostgreSQL Performance](https://www.postgresql.org/docs/13/performance-tips.html)
- [Laravel Database Testing](https://laravel.com/docs/11.x/database-testing)

---

_Tâche créée le 25 juin 2025 - LifeCompanion Project_
