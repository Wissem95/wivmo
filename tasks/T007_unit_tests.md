# 🧪 T007 - Tests Unitaires

**Sprint**: 1 | **Points**: 5 | **Assigné**: Wissem | **Priorité**: MEDIUM

---

## 🎯 **Objectif**

Mettre en place une suite de tests unitaires et d'intégration complète pour le backend Laravel et le frontend Flutter.

## 📋 **Acceptance Criteria**

- [ ] Tests Laravel : Feature tests + Unit tests (>80% couverture)
- [ ] Tests Flutter : Widget tests + Unit tests (>80% couverture)
- [ ] Configuration CI/CD pour tests automatiques
- [ ] Tests d'API avec Postman/Newman
- [ ] Tests de performance de base
- [ ] Mock des services externes (MQTT, DB)
- [ ] Documentation des tests et conventions

---

## 🔧 **Prompts à Utiliser**

### **1. Tests Laravel Backend**

```bash
# Prompt pour tests Laravel
Je veux créer une suite de tests complète pour mon API Laravel IoT.

**Entités à tester** :
- **AuthController** : login, logout, register, refresh token
- **DeviceController** : CRUD, activation, validation
- **EnvironmentalReadingController** : CRUD, filters, pagination
- **ActivityClassificationController** : CRUD, statistics
- **NotificationController** : CRUD, mark read, bulk operations

**Types de tests nécessaires** :
- **Feature Tests** : endpoints API avec authentification
- **Unit Tests** : modèles, services, jobs
- **Integration Tests** : MQTT, database, cache
- **Performance Tests** : charge, time-series queries

**Mocking requis** :
- MQTT broker connections
- External API calls
- Time-dependent functions
- File system operations

**Structure souhaitée** :
```

tests/
├── Feature/
│ ├── Auth/
│ ├── Api/
│ └── Integration/
├── Unit/
│ ├── Models/
│ ├── Services/
│ └── Jobs/
└── Performance/

```

J'ai besoin de :
- Configuration PHPUnit optimisée
- Database testing avec transactions
- Factories pour données test
- Mocks et stubs appropriés
- Assertions custom pour IoT data

Fournis une structure complète avec exemples concrets.
```

### **2. Tests Flutter Frontend**

```bash
# Prompt pour tests Flutter
Je développe des tests Flutter pour une app IoT avec Bloc pattern.

**Composants à tester** :
- **Blocs** : AuthBloc, EnvironmentalBloc, ActivityBloc, NotificationBloc
- **Widgets** : LoginScreen, Dashboard, EnvironmentalCard, ActivityTimeline
- **Services** : ApiService, MqttService, DatabaseService
- **Repositories** : tous les repositories avec cache/sync
- **Models** : serialization/deserialization

**Types de tests** :
- **Unit Tests** : Blocs, Services, Models, Utils
- **Widget Tests** : UI components, user interactions
- **Integration Tests** : navigation, API calls
- **Golden Tests** : screenshots pour UI consistency

**Mocking strategy** :
- HTTP calls avec Dio
- MQTT connections
- SQLite database
- Secure storage
- Platform-specific code

**Structure recommandée** :
```

test/
├── unit/
│ ├── blocs/
│ ├── services/
│ ├── repositories/
│ └── models/
├── widget/
├── integration/
└── goldens/

```

J'ai besoin de :
- Configuration test environment
- Mocks et fixtures robustes
- Test utilities pour Bloc testing
- Widget testing helpers
- Performance testing setup

Fournis l'implémentation complète avec exemples.
```

### **3. Tests d'API avec Postman**

```bash
# Prompt pour tests API automatisés
Je veux créer une suite de tests API automatisés pour mon backend Laravel IoT.

**Collections Postman nécessaires** :
- **Authentication** : register, login, logout, refresh, protected routes
- **Devices Management** : CRUD operations, validation, authorization
- **Environmental Data** : create readings, filters, aggregations, time-series
- **Activity Classification** : CRUD, statistics, batch operations
- **Notifications** : list, create, mark read, bulk operations

**Scenarios de test** :
- Happy path pour tous les endpoints
- Error handling (400, 401, 403, 404, 422, 500)
- Data validation edge cases
- Performance sous charge
- Rate limiting

**Environnements** :
- Local development
- Staging
- Production (tests non-destructifs)

**Automation** :
- Newman CLI pour CI/CD
- Tests en parallèle
- Reporting détaillé
- Integration avec GitHub Actions

J'ai besoin de :
- Collections Postman structurées
- Variables d'environnement configurées
- Scripts pré/post-request
- Assertions robustes
- Documentation d'usage

Fournis les collections complètes avec configuration Newman.
```

### **4. Configuration CI/CD pour Tests**

```bash
# Prompt pour CI/CD testing
Je configure un pipeline CI/CD pour tester automatiquement mon projet Laravel/Flutter.

**Pipeline structure** :
- **Backend Tests** : PHPUnit, Code coverage, Static analysis
- **Frontend Tests** : Flutter test, Widget tests, Integration tests
- **API Tests** : Newman/Postman automation
- **Performance Tests** : Load testing, Database performance
- **Code Quality** : ESLint, PHPStan, Flutter analyze

**Environnements** :
- **PR Checks** : tests obligatoires avant merge
- **Staging Deploy** : tests complets après merge
- **Production Deploy** : smoke tests + rollback capability

**Tools integration** :
- GitHub Actions workflows
- Docker containers pour isolation
- Parallel job execution
- Test result reporting
- Coverage reporting

**Notifications** :
- Slack/Discord integration
- Email reports pour failures
- GitHub PR status checks
- Performance regression alerts

J'ai besoin de :
- Workflows GitHub Actions complets
- Docker configurations pour tests
- Scripts de setup et teardown
- Reporting et notifications
- Optimization pour vitesse d'execution

Fournis la configuration complète avec exemples de workflows.
```

---

## 📝 **Actions Détaillées**

### **Étape 1 : Configuration Tests Laravel**

1. **Setup PHPUnit configuration**

   ```xml
   <!-- phpunit.xml -->
   <?xml version="1.0" encoding="UTF-8"?>
   <phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="vendor/phpunit/phpunit/phpunit.xsd"
            bootstrap="vendor/autoload.php"
            colors="true">
       <testsuites>
           <testsuite name="Feature">
               <directory suffix="Test.php">./tests/Feature</directory>
           </testsuite>
           <testsuite name="Unit">
               <directory suffix="Test.php">./tests/Unit</directory>
           </testsuite>
       </testsuites>
       <coverage>
           <include>
               <directory suffix=".php">./app</directory>
           </include>
       </coverage>
   </phpunit>
   ```

2. **Créer les tests de base**
   ```bash
   php artisan make:test AuthControllerTest --unit
   php artisan make:test DeviceControllerTest
   php artisan make:test EnvironmentalReadingTest --unit
   ```

### **Étape 2 : Configuration Tests Flutter**

1. **Setup test dependencies**

   ```yaml
   dev_dependencies:
     flutter_test:
       sdk: flutter
     mockito: ^5.4.2
     bloc_test: ^9.1.4
     network_image_mock: ^2.1.1
   ```

2. **Créer structure tests**
   ```
   test/
   ├── unit/
   ├── widget/
   ├── integration/
   └── test_helpers/
   ```

### **Étape 3 : Tests API Postman**

1. **Créer collections Postman**
2. **Configurer Newman CLI**
3. **Scripts d'automation**

### **Étape 4 : CI/CD Configuration**

1. **GitHub Actions workflows**
2. **Docker test environments**
3. **Reporting integration**

---

## 🧪 **Exemples de Tests Laravel**

### **Feature Test - AuthController**

```php
<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class AuthControllerTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    public function test_user_can_register()
    {
        $userData = [
            'name' => $this->faker->name,
            'email' => $this->faker->email,
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ];

        $response = $this->postJson('/api/auth/register', $userData);

        $response->assertStatus(201)
                 ->assertJsonStructure([
                     'data' => ['id', 'name', 'email'],
                     'access_token',
                     'token_type'
                 ]);

        $this->assertDatabaseHas('users', [
            'email' => $userData['email'],
        ]);
    }

    public function test_user_can_login()
    {
        $user = User::factory()->create([
            'password' => bcrypt('password123'),
        ]);

        $response = $this->postJson('/api/auth/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertStatus(200)
                 ->assertJsonStructure([
                     'access_token',
                     'token_type',
                     'expires_in'
                 ]);
    }

    public function test_login_fails_with_invalid_credentials()
    {
        $response = $this->postJson('/api/auth/login', [
            'email' => 'invalid@email.com',
            'password' => 'wrongpassword',
        ]);

        $response->assertStatus(401)
                 ->assertJson([
                     'message' => 'Invalid credentials'
                 ]);
    }
}
```

### **Unit Test - EnvironmentalReading Model**

```php
<?php

namespace Tests\Unit\Models;

use App\Models\EnvironmentalReading;
use App\Models\Device;
use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;

class EnvironmentalReadingTest extends TestCase
{
    use RefreshDatabase;

    public function test_belongs_to_device()
    {
        $device = Device::factory()->create();
        $reading = EnvironmentalReading::factory()->create([
            'device_id' => $device->id,
        ]);

        $this->assertInstanceOf(Device::class, $reading->device);
        $this->assertEquals($device->id, $reading->device->id);
    }

    public function test_comfort_score_calculation()
    {
        $reading = EnvironmentalReading::factory()->create([
            'temperature' => 22.0,
            'humidity' => 50.0,
        ]);

        $comfortScore = $reading->calculateComfortScore();

        $this->assertIsFloat($comfortScore);
        $this->assertGreaterThanOrEqual(0, $comfortScore);
        $this->assertLessThanOrEqual(100, $comfortScore);
    }

    public function test_is_within_comfort_range()
    {
        $comfortableReading = EnvironmentalReading::factory()->create([
            'temperature' => 22.0,
            'humidity' => 50.0,
        ]);

        $uncomfortableReading = EnvironmentalReading::factory()->create([
            'temperature' => 35.0,
            'humidity' => 90.0,
        ]);

        $this->assertTrue($comfortableReading->isWithinComfortRange());
        $this->assertFalse($uncomfortableReading->isWithinComfortRange());
    }
}
```

---

## 🧪 **Exemples de Tests Flutter**

### **Bloc Test - AuthBloc**

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(mockAuthRepository.login(any, any))
            .thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLoginRequested('test@email.com', 'password')),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(mockUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(mockAuthRepository.login(any, any))
            .thenThrow(Exception('Invalid credentials'));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLoginRequested('test@email.com', 'wrong')),
      expect: () => [
        AuthLoading(),
        AuthError('Invalid credentials'),
      ],
    );
  });
}
```

### **Widget Test - LoginScreen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
    });

    testWidgets('renders login form correctly', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: LoginScreen(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('validates email input', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: LoginScreen(),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(
        find.byKey(Key('email_field')),
        'invalid-email'
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('shows loading indicator when authenticating', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: LoginScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

---

## 📊 **Collection Postman - Auth Tests**

```json
{
  "info": {
    "name": "LifeCompanion API - Auth Tests",
    "description": "Tests d'authentification pour l'API LifeCompanion"
  },
  "item": [
    {
      "name": "User Registration",
      "event": [
        {
          "listen": "test",
          "script": {
            "exec": [
              "pm.test('Status code is 201', function () {",
              "    pm.response.to.have.status(201);",
              "});",
              "",
              "pm.test('Response has access token', function () {",
              "    var jsonData = pm.response.json();",
              "    pm.expect(jsonData).to.have.property('access_token');",
              "    pm.environment.set('access_token', jsonData.access_token);",
              "});",
              "",
              "pm.test('User data is correct', function () {",
              "    var jsonData = pm.response.json();",
              "    pm.expect(jsonData.data.email).to.eql(pm.environment.get('test_email'));",
              "});"
            ]
          }
        }
      ],
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"name\": \"{{test_name}}\",\n  \"email\": \"{{test_email}}\",\n  \"password\": \"{{test_password}}\",\n  \"password_confirmation\": \"{{test_password}}\"\n}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "{{base_url}}/api/auth/register",
          "host": ["{{base_url}}"],
          "path": ["api", "auth", "register"]
        }
      }
    },
    {
      "name": "User Login",
      "event": [
        {
          "listen": "test",
          "script": {
            "exec": [
              "pm.test('Status code is 200', function () {",
              "    pm.response.to.have.status(200);",
              "});",
              "",
              "pm.test('Access token received', function () {",
              "    var jsonData = pm.response.json();",
              "    pm.expect(jsonData.access_token).to.be.a('string');",
              "    pm.environment.set('access_token', jsonData.access_token);",
              "});"
            ]
          }
        }
      ],
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"email\": \"{{test_email}}\",\n  \"password\": \"{{test_password}}\"\n}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "{{base_url}}/api/auth/login",
          "host": ["{{base_url}}"],
          "path": ["api", "auth", "login"]
        }
      }
    }
  ]
}
```

---

## ⚙️ **GitHub Actions Workflow**

```yaml
name: LifeCompanion CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  laravel-tests:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: timescale/timescaledb:latest-pg13
        env:
          POSTGRES_PASSWORD: secret
          POSTGRES_DB: lifecompanion_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v3

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: pdo, pdo_pgsql

      - name: Install Dependencies
        run: |
          cd backend
          composer install --no-progress --prefer-dist --optimize-autoloader

      - name: Copy Environment File
        run: |
          cd backend
          cp .env.testing .env

      - name: Generate Application Key
        run: |
          cd backend
          php artisan key:generate

      - name: Run Migrations
        run: |
          cd backend
          php artisan migrate --force

      - name: Run Tests
        run: |
          cd backend
          vendor/bin/phpunit --coverage-clover coverage.xml

      - name: Upload Coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./backend/coverage.xml

  flutter-tests:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'

      - name: Install Dependencies
        run: |
          cd mobile
          flutter pub get

      - name: Run Tests
        run: |
          cd mobile
          flutter test --coverage

      - name: Upload Coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./mobile/coverage/lcov.info

  api-tests:
    runs-on: ubuntu-latest
    needs: laravel-tests

    steps:
      - uses: actions/checkout@v3

      - name: Install Newman
        run: npm install -g newman

      - name: Run API Tests
        run: |
          newman run tests/postman/LifeCompanion_API.postman_collection.json \
            -e tests/postman/environments/ci.postman_environment.json \
            --reporters cli,htmlextra \
            --reporter-htmlextra-export newman-report.html

      - name: Upload Test Report
        uses: actions/upload-artifact@v3
        with:
          name: newman-report
          path: newman-report.html
```

---

## ✅ **Definition of Done**

- [ ] Tests Laravel avec >80% de couverture
- [ ] Tests Flutter avec >80% de couverture
- [ ] Collections Postman complètes et automatisées
- [ ] Pipeline CI/CD fonctionnel avec tests
- [ ] Tests de performance de base implémentés
- [ ] Documentation des conventions de test
- [ ] Mocks appropriés pour services externes
- [ ] Rapports de couverture automatiques

---

## 🔗 **Dépendances**

- **Précédent**: T002, T003, T006 - API et Frontend de base
- **Suivant**: T008 - Docker & Déploiement

---

## 📚 **Ressources**

- [PHPUnit Documentation](https://phpunit.de/documentation.html)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Bloc Testing Library](https://pub.dev/packages/bloc_test)
- [Newman CLI](https://learning.postman.com/docs/running-collections/using-newman-cli/)

---

_Tâche créée le 25 juin 2025 - LifeCompanion Project_
