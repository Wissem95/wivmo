# 🔗 T006 - API Integration Flutter

**Sprint**: 1 | **Points**: 8 | **Assigné**: Wissem | **Priorité**: HIGH

---

## 🎯 **Objectif**

Intégrer l'API Laravel dans l'application Flutter avec HTTP client, repository pattern et gestion d'état Bloc.

## 📋 **Acceptance Criteria**

- [ ] HTTP client Dio configuré avec interceptors
- [ ] Repository pattern implémenté pour toutes les entités
- [ ] Models Dart générés avec json_serializable
- [ ] Intégration complète avec les Blocs existants
- [ ] Gestion d'erreurs robuste (réseau, auth, validation)
- [ ] Loading states et offline handling
- [ ] Cache local avec SQLite pour mode offline
- [ ] Synchronisation automatique online/offline

---

## 🔧 **Prompts à Utiliser**

### **1. Configuration HTTP Client Dio**

```bash
# Prompt pour Dio HTTP client
Je configure un client HTTP Flutter avec Dio pour une API Laravel IoT.

**Fonctionnalités requises** :
- **Authentification** : Bearer tokens automatiques
- **Interceptors** : logs, retry, error handling
- **Base URL** : configuration environnement
- **Timeout** : gestion des timeouts réseau
- **Cache** : cache HTTP intelligent

**API Endpoints à supporter** :
- Auth : /api/auth/login, /api/auth/logout, /api/auth/refresh
- Users : /api/users (CRUD)
- Devices : /api/devices (CRUD + activation)
- Environmental : /api/environmental-readings (list, filters)
- Activities : /api/activity-classifications (CRUD + stats)
- Notifications : /api/notifications (list, mark read)

**Gestion d'erreurs** :
- Network errors (connection, timeout)
- HTTP errors (400, 401, 403, 404, 500)
- Validation errors (422)
- Token refresh automatique

J'ai besoin de :
- Configuration Dio complète
- Interceptors pour auth et errors
- Error classes typées
- Retry logic intelligent
- Logging pour debugging

Fournis l'implémentation complète avec exemples.
```

### **2. Models Dart et Serialization**

```bash
# Prompt pour models Flutter
Je crée des models Dart pour une app IoT Flutter avec json_serializable.

**Entités à modéliser** :
- **User** : id, name, email, preferences, settings
- **Device** : id, userId, type, macAddress, mqttTopic, isActive, metadata
- **EnvironmentalReading** : id, deviceId, measuredAt, temperature, humidity, pressure, airQuality, batteryLevel
- **ActivityClassification** : id, userId, startedAt, endedAt, activityType, confidenceScore, metadata
- **Notification** : id, userId, title, message, type, status, sentAt, readAt

**Fonctionnalités requises** :
- JSON serialization/deserialization automatique
- Validation des données
- Nullable fields gérés correctement
- DateTime parsing avec timezone
- Enum support pour types et statuts
- copyWith methods pour immutabilité

**Spécificités** :
- DateTime en UTC depuis API
- Enum values mapped depuis strings
- Nested objects support
- List<T> serialization
- Custom field names (snake_case ↔ camelCase)

J'ai besoin de :
- Models complets avec annotations
- Factory constructors
- toJson/fromJson methods
- Validation custom si nécessaire
- Tests unitaires pour serialization

Fournis le code complet pour tous les models.
```

### **3. Repository Pattern Implementation**

```bash
# Prompt pour Repository pattern
Je veux implémenter le Repository pattern dans Flutter pour une app IoT.

**Architecture souhaitée** :
```

UI → Bloc → Repository → (API Service | Local DB)
↓
Cache Strategy

```

**Repositories nécessaires** :
- **AuthRepository** : login, logout, refresh token, user profile
- **DeviceRepository** : CRUD devices, activation, last readings
- **EnvironmentalRepository** : readings with filters, aggregations
- **ActivityRepository** : classifications, statistics, trends
- **NotificationRepository** : list, mark read, preferences

**Fonctionnalités par repo** :
- API calls avec error handling
- Local cache avec SQLite
- Offline/online sync
- Data transformation
- Cache invalidation strategies

**Cache Strategy** :
- Fresh data priorité si online
- Cache fallback si offline
- Background sync quand online revient
- Conflict resolution pour modifications offline

J'ai besoin de :
- Interface abstraite pour chaque repository
- Implémentation concrète avec API + Cache
- Error handling uniforme
- Sync logic robuste
- Tests unitaires et mocks

Fournis l'implémentation complète avec exemples.
```

### **4. Bloc Integration et State Management**

```bash
# Prompt pour Bloc integration
Je veux intégrer mes repositories avec les Blocs Flutter existants.

**Blocs existants à étendre** :
- **AuthBloc** : login, logout, token refresh
- **EnvironmentalBloc** : load readings, filters, real-time updates
- **ActivityBloc** : load activities, statistics
- **NotificationBloc** : load notifications, mark read
- **DeviceBloc** : manage devices, activation

**Patterns d'états** :
- Initial, Loading, Success, Error
- Pagination states pour listes
- Refresh states pour pull-to-refresh
- Offline/Online awareness

**Événements typiques** :
- Load, Refresh, LoadMore (pagination)
- Create, Update, Delete
- Filter, Search, Sort
- SyncOfflineData

**Error Handling** :
- Typed errors (NetworkError, ValidationError, etc.)
- User-friendly error messages
- Retry mechanisms
- Offline mode graceful degradation

J'ai besoin de :
- Extension des Blocs existants
- Integration avec repositories
- Pagination logic
- Error handling comprehensive
- Offline state management

Fournis l'implémentation complète avec exemples d'usage.
```

---

## 📝 **Actions Détaillées**

### **Étape 1 : Configuration HTTP Client**

1. **Ajouter dépendances Flutter**

   ```yaml
   dependencies:
     dio: ^5.3.2
     pretty_dio_logger: ^1.3.1
     dio_cache_interceptor: ^3.4.4
     connectivity_plus: ^5.0.1
     json_serializable: ^6.7.1
     json_annotation: ^4.8.1

   dev_dependencies:
     build_runner: ^2.4.7
   ```

2. **Créer le service HTTP base**
   ```dart
   lib/services/api_service.dart
   lib/services/interceptors/auth_interceptor.dart
   lib/services/interceptors/error_interceptor.dart
   ```

### **Étape 2 : Models et Serialization**

1. **Générer les models**

   ```bash
   # Créer tous les models avec annotations
   lib/models/user.dart
   lib/models/device.dart
   lib/models/environmental_reading.dart
   lib/models/activity_classification.dart
   lib/models/notification.dart
   ```

2. **Générer le code de serialization**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

### **Étape 3 : Repositories**

1. **Créer les interfaces repository**

   ```dart
   lib/repositories/interfaces/
   ```

2. **Implémenter les repositories concrets**

   ```dart
   lib/repositories/implementations/
   ```

3. **Setup base de données locale**
   ```dart
   lib/services/database_service.dart
   ```

### **Étape 4 : Integration Bloc**

1. **Étendre les Blocs existants**
2. **Ajouter les événements API**
3. **Gérer les états de chargement**

### **Étape 5 : Tests**

1. **Tests unitaires repositories**
2. **Tests integration avec mocks**
3. **Tests des models serialization**

---

## 🔧 **Configuration Dio - Exemple**

### **ApiService Class**

```dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Auth Interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Try to refresh token
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry original request
            return handler.resolve(await _retry(error.requestOptions));
          }
        }
        handler.next(error);
      },
    ));

    // Logging
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final response = await _dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });

      final newToken = response.data['access_token'];
      await _storage.write(key: 'auth_token', value: newToken);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Dio get dio => _dio;
}
```

---

## 📦 **Model Example - EnvironmentalReading**

```dart
import 'package:json_annotation/json_annotation.dart';

part 'environmental_reading.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EnvironmentalReading {
  final int id;
  final int deviceId;
  final DateTime measuredAt;
  final double? temperature;
  final double? humidity;
  final double? pressure;
  final int? airQuality;
  final int? batteryLevel;

  const EnvironmentalReading({
    required this.id,
    required this.deviceId,
    required this.measuredAt,
    this.temperature,
    this.humidity,
    this.pressure,
    this.airQuality,
    this.batteryLevel,
  });

  factory EnvironmentalReading.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentalReadingFromJson(json);

  Map<String, dynamic> toJson() => _$EnvironmentalReadingToJson(this);

  EnvironmentalReading copyWith({
    int? id,
    int? deviceId,
    DateTime? measuredAt,
    double? temperature,
    double? humidity,
    double? pressure,
    int? airQuality,
    int? batteryLevel,
  }) {
    return EnvironmentalReading(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      measuredAt: measuredAt ?? this.measuredAt,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      airQuality: airQuality ?? this.airQuality,
      batteryLevel: batteryLevel ?? this.batteryLevel,
    );
  }
}
```

---

## 🗄️ **Repository Example - EnvironmentalRepository**

```dart
import '../models/environmental_reading.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

abstract class EnvironmentalRepository {
  Future<List<EnvironmentalReading>> getReadings({
    int? deviceId,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 50,
  });

  Future<void> syncOfflineData();
}

class EnvironmentalRepositoryImpl implements EnvironmentalRepository {
  final ApiService _apiService;
  final DatabaseService _databaseService;

  EnvironmentalRepositoryImpl(this._apiService, this._databaseService);

  @override
  Future<List<EnvironmentalReading>> getReadings({
    int? deviceId,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      // Try to fetch from API first
      final response = await _apiService.dio.get('/environmental-readings',
        queryParameters: {
          'device_id': deviceId,
          'start_date': startDate?.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
          'page': page,
          'limit': limit,
        },
      );

      final readings = (response.data['data'] as List)
          .map((json) => EnvironmentalReading.fromJson(json))
          .toList();

      // Cache in local database
      await _databaseService.cacheReadings(readings);

      return readings;
    } catch (e) {
      // Fallback to local cache
      return await _databaseService.getCachedReadings(
        deviceId: deviceId,
        startDate: startDate,
        endDate: endDate,
        page: page,
        limit: limit,
      );
    }
  }

  @override
  Future<void> syncOfflineData() async {
    final offlineReadings = await _databaseService.getUnsyncedReadings();

    for (final reading in offlineReadings) {
      try {
        await _apiService.dio.post('/environmental-readings',
          data: reading.toJson(),
        );
        await _databaseService.markAsSynced(reading.id);
      } catch (e) {
        // Will retry later
        print('Failed to sync reading ${reading.id}: $e');
      }
    }
  }
}
```

---

## 🔄 **Bloc Integration Example**

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/environmental_repository.dart';
import '../models/environmental_reading.dart';

// Events
abstract class EnvironmentalEvent {}

class LoadEnvironmentalData extends EnvironmentalEvent {
  final int? deviceId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadEnvironmentalData({this.deviceId, this.startDate, this.endDate});
}

class RefreshEnvironmentalData extends EnvironmentalEvent {}

// States
abstract class EnvironmentalState {}

class EnvironmentalInitial extends EnvironmentalState {}
class EnvironmentalLoading extends EnvironmentalState {}
class EnvironmentalLoaded extends EnvironmentalState {
  final List<EnvironmentalReading> readings;
  final bool isRefreshing;

  EnvironmentalLoaded(this.readings, {this.isRefreshing = false});
}

class EnvironmentalError extends EnvironmentalState {
  final String message;
  final bool hasCache;

  EnvironmentalError(this.message, {this.hasCache = false});
}

// Bloc
class EnvironmentalBloc extends Bloc<EnvironmentalEvent, EnvironmentalState> {
  final EnvironmentalRepository _repository;

  EnvironmentalBloc(this._repository) : super(EnvironmentalInitial()) {
    on<LoadEnvironmentalData>(_onLoadData);
    on<RefreshEnvironmentalData>(_onRefreshData);
  }

  Future<void> _onLoadData(
    LoadEnvironmentalData event,
    Emitter<EnvironmentalState> emit,
  ) async {
    emit(EnvironmentalLoading());

    try {
      final readings = await _repository.getReadings(
        deviceId: event.deviceId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(EnvironmentalLoaded(readings));
    } catch (e) {
      emit(EnvironmentalError(e.toString()));
    }
  }

  Future<void> _onRefreshData(
    RefreshEnvironmentalData event,
    Emitter<EnvironmentalState> emit,
  ) async {
    final currentState = state;
    if (currentState is EnvironmentalLoaded) {
      emit(EnvironmentalLoaded(currentState.readings, isRefreshing: true));

      try {
        final readings = await _repository.getReadings();
        emit(EnvironmentalLoaded(readings));
      } catch (e) {
        emit(EnvironmentalLoaded(currentState.readings));
      }
    }
  }
}
```

---

## 🧪 **Tests à Implémenter**

### **Tests API Service**

```dart
// api_service_test.dart
- test_dio_configuration()
- test_auth_interceptor()
- test_token_refresh()
- test_error_handling()
```

### **Tests Models**

```dart
// environmental_reading_test.dart
- test_json_serialization()
- test_json_deserialization()
- test_copy_with_method()
- test_nullable_fields()
```

### **Tests Repository**

```dart
// environmental_repository_test.dart
- test_get_readings_success()
- test_offline_fallback()
- test_cache_mechanism()
- test_sync_offline_data()
```

### **Tests Bloc Integration**

```dart
// environmental_bloc_test.dart
- test_load_data_success()
- test_load_data_error()
- test_refresh_data()
- test_offline_state_handling()
```

---

## ✅ **Definition of Done**

- [ ] HTTP client Dio configuré avec interceptors
- [ ] Models Dart avec serialization automatique
- [ ] Repository pattern implémenté complètement
- [ ] Integration Bloc fonctionnelle
- [ ] Gestion d'erreurs robuste et UX
- [ ] Cache local et mode offline
- [ ] Synchronisation automatique
- [ ] Tests unitaires et integration
- [ ] Documentation d'API complète

---

## 🔗 **Dépendances**

- **Précédent**: T003 - Frontend Flutter Foundation, T002 - Backend API Core
- **Suivant**: T007 - Tests Unitaires

---

## 📚 **Ressources**

- [Dio HTTP Client](https://pub.dev/packages/dio)
- [JSON Serializable](https://pub.dev/packages/json_serializable)
- [Flutter Bloc](https://bloclibrary.dev/)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)

---

_Tâche créée le 25 juin 2025 - LifeCompanion Project_
