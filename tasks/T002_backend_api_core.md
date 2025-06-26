# 🛠️ T002 - Backend Laravel API Core

**Sprint**: 1 | **Points**: 13 | **Assigné**: Wissem | **Priorité**: CRITICAL

---

## 🎯 **Objectif**

Développer l'API REST Laravel avec l'authentification et les modèles de base pour LifeCompanion.

## 📋 **Acceptance Criteria**

- [ ] Modèles Eloquent: User, Device, EnvironmentalReading, ActivityClassification, Notification
- [ ] Controllers API avec CRUD complet pour chaque modèle
- [ ] Authentification Laravel Sanctum fonctionnelle
- [ ] Validation des requêtes avec Form Requests
- [ ] API Resources pour transformer les données
- [ ] Migrations et Seeders avec données de test
- [ ] Documentation API avec Swagger
- [ ] Tests unitaires et fonctionnels (>80% couverture)

---

## 🔧 **Prompts à Utiliser**

### **1. Configuration Laravel Sanctum**

```bash
# Prompt pour authentification API
Je développe une API Laravel 11 pour une application IoT.
J'ai besoin de configurer Laravel Sanctum pour :
- Authentification via tokens API
- Protection des routes API
- Gestion des sessions utilisateur
- Logout et révocation des tokens

Fournis-moi :
- Configuration complète de Sanctum
- Middleware de protection
- AuthController avec login/logout/register
- Gestion des erreurs d'authentification
- Tests pour l'authentification

Inclus des exemples de code complets.
```

### **2. Modèles Eloquent et Relations**

```bash
# Prompt pour modèles de données
Je créé une application IoT Laravel avec ces entités :

**User** (id, name, email, preferences, settings, created_at, updated_at)
**Device** (id, user_id, type, mac_address, mqtt_topic, is_active, created_at, updated_at)
**EnvironmentalReading** (id, device_id, measured_at, temperature, humidity, pressure, air_quality)
**ActivityClassification** (id, user_id, started_at, ended_at, activity_type, confidence, metadata)
**Notification** (id, user_id, title, message, type, status, sent_at, read_at)

J'ai besoin de :
- Modèles Eloquent avec relations
- Migrations optimisées pour TimescaleDB
- Scopes et accessors/mutators utiles
- Validation des données
- Seeders avec données réalistes

Relations :
- User → hasMany Devices, ActivityClassifications, Notifications
- Device → hasMany EnvironmentalReadings, belongsTo User
- EnvironmentalReading → belongsTo Device
- ActivityClassification, Notification → belongsTo User

Fournis le code complet pour chaque modèle.
```

### **3. Controllers API RESTful**

```bash
# Prompt pour controllers API
Je développe des controllers API Laravel pour une app IoT.
Entités : User, Device, EnvironmentalReading, ActivityClassification, Notification

Pour chaque controller, j'ai besoin de :
- Actions CRUD complètes (index, show, store, update, destroy)
- Validation avec Form Requests
- Pagination pour les listes
- Filtres et recherche
- API Resources pour formater les réponses
- Gestion d'erreurs propre
- Authorization policies

Spécificités :
- EnvironmentalReadingController : filtres par date, device, type
- ActivityClassificationController : statistiques par période
- NotificationController : mark as read, bulk operations
- DeviceController : activation/désactivation

Fournis le code complet avec exemples d'usage.
```

### **4. API Resources et Transformation**

```bash
# Prompt pour API Resources
Je veux créer des API Resources Laravel pour transformer mes données :

**UserResource** : masquer email dans certains contextes, inclure stats
**DeviceResource** : inclure last_reading, status, battery_level
**EnvironmentalReadingResource** : format timestamp, unités de mesure
**ActivityClassificationResource** : durée calculée, pourcentage confiance
**NotificationResource** : format dates, status_label

J'ai besoin de :
- Resources avec conditional attributes
- Resource Collections pour les listes
- Nested resources (Device avec readings)
- Pagination resources
- Meta-données dans les réponses

Fournis des examples concrets avec différents contextes d'usage.
```

---

## 📝 **Actions Détaillées**

### **Étape 1 : Configuration Base Laravel**

1. **Installer les dépendances nécessaires**

   ```bash
   composer require laravel/sanctum
   composer require --dev phpunit/phpunit
   composer require spatie/laravel-query-builder
   ```

2. **Publier les configurations**
   ```bash
   php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
   php artisan migrate
   ```

### **Étape 2 : Création des Modèles**

1. **Générer les modèles avec migrations**

   ```bash
   php artisan make:model User -m
   php artisan make:model Device -m
   php artisan make:model EnvironmentalReading -m
   php artisan make:model ActivityClassification -m
   php artisan make:model Notification -m
   ```

2. **Implémenter les relations Eloquent**
3. **Ajouter les validations et scopes**

### **Étape 3 : Controllers et Validation**

1. **Générer les controllers et requests**

   ```bash
   php artisan make:controller Api/AuthController
   php artisan make:controller Api/DeviceController --api
   php artisan make:controller Api/EnvironmentalReadingController --api
   php artisan make:controller Api/ActivityClassificationController --api
   php artisan make:controller Api/NotificationController --api
   php artisan make:request StoreDeviceRequest
   php artisan make:request UpdateDeviceRequest
   # ... répéter pour chaque modèle
   ```

2. **Implémenter la logique métier**
3. **Ajouter les API Resources**
   ```bash
   php artisan make:resource UserResource
   php artisan make:resource DeviceResource
   # ... répéter pour chaque modèle
   ```

### **Étape 4 : Routes et Middleware**

1. **Configurer les routes API dans `routes/api.php`**
2. **Appliquer les middleware d'authentification**
3. **Grouper les routes par version**

### **Étape 5 : Seeders et Données de Test**

1. **Créer les seeders**

   ```bash
   php artisan make:seeder UserSeeder
   php artisan make:seeder DeviceSeeder
   php artisan make:seeder EnvironmentalReadingSeeder
   ```

2. **Implémenter des données réalistes**
3. **Configurer DatabaseSeeder**

### **Étape 6 : Tests**

1. **Tests d'authentification**
2. **Tests des controllers API**
3. **Tests des modèles et relations**
4. **Tests d'intégration**

---

## 🧪 **Tests à Implémenter**

### **Tests d'Authentification**

```php
// AuthControllerTest.php
- test_user_can_register()
- test_user_can_login()
- test_user_can_logout()
- test_invalid_credentials_rejected()
- test_token_required_for_protected_routes()
```

### **Tests Controllers**

```php
// DeviceControllerTest.php
- test_user_can_list_own_devices()
- test_user_can_create_device()
- test_user_cannot_access_others_devices()
- test_device_validation_works()
```

### **Tests Modèles**

```php
// DeviceTest.php
- test_device_belongs_to_user()
- test_device_has_many_readings()
- test_device_scopes_work()
```

---

## 📊 **Structure des Données API**

### **Réponse Standard**

```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful",
  "meta": {
    "pagination": { ... },
    "filters": { ... }
  }
}
```

### **Réponse d'Erreur**

```json
{
  "success": false,
  "message": "Validation error",
  "errors": {
    "field": ["Error message"]
  }
}
```

---

## ✅ **Definition of Done**

- [ ] Tous les modèles créés avec relations correctes
- [ ] Tous les controllers API fonctionnels
- [ ] Authentification Sanctum opérationnelle
- [ ] Validation des données complète
- [ ] API Resources implémentées
- [ ] Tests unitaires et fonctionnels passants
- [ ] Documentation Swagger générée
- [ ] Seeders avec données réalistes
- [ ] Code reviewé et validé

---

## 🔗 **Dépendances**

- **Précédent**: T001 - Setup Environnement
- **Suivant**: T003 - Frontend Flutter Foundation, T004 - Base de Données

---

## 📚 **Ressources**

- [Laravel Sanctum Documentation](https://laravel.com/docs/11.x/sanctum)
- [Laravel API Resources](https://laravel.com/docs/11.x/eloquent-resources)
- [Laravel Validation](https://laravel.com/docs/11.x/validation)
- [PHPUnit Testing](https://phpunit.de/documentation.html)

---

_Tâche créée le 25 juin 2025 - LifeCompanion Project_
