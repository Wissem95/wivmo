/// Configuration globale de l'application LifeCompanion
class AppConfig {
  // Informations de l'application
  static const String appName = 'LifeCompanion';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // Mode de développement
  static const bool isDebugMode = true; // À changer en production
  
  // Configuration API Backend
  static const String baseUrl = 'http://localhost:8000/api';
  static const String wsUrl = 'ws://localhost:8000/ws';
  
  // Configuration MQTT
  static const String mqttHost = 'localhost';
  static const int mqttPort = 1883;
  static const String mqttClientId = 'lifecompanion_mobile';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration mqttTimeout = Duration(seconds: 10);
  static const Duration dbTimeout = Duration(seconds: 5);
  
  // Configuration de synchronisation
  static const Duration syncInterval = Duration(minutes: 5);
  static const Duration offlineDataRetention = Duration(days: 7);
  
  // Configuration des notifications
  static const bool enablePushNotifications = true;
  static const bool enableLocalNotifications = true;
  static const Duration notificationCooldown = Duration(minutes: 5);
  
  // Configuration des capteurs
  static const Duration sensorReadingInterval = Duration(seconds: 30);
  static const Duration activityClassificationInterval = Duration(minutes: 1);
  
  // Seuils de confort par défaut
  static const double comfortTempMin = 18.0;
  static const double comfortTempMax = 24.0;
  static const double comfortHumidityMin = 40.0;
  static const double comfortHumidityMax = 60.0;
  
  // Configuration de l'activité
  static const double walkingThreshold = 1.5; // m/s²
  static const double runningThreshold = 3.0; // m/s²
  static const double transportThreshold = 0.8; // m/s²
  static const Duration minimumActivityDuration = Duration(minutes: 2);
  
  // Configuration de l'interface
  static const int maxNotificationsDisplayed = 50;
  static const Duration chartAnimationDuration = Duration(milliseconds: 800);
  static const int maxDataPointsInChart = 100;
  
  // Configuration du cache
  static const Duration cacheValidityDuration = Duration(hours: 1);
  static const int maxCacheSize = 100; // MB
  
  // Clés de stockage local
  static const String userTokenKey = 'user_token';
  static const String userPreferencesKey = 'user_preferences';
  static const String deviceSettingsKey = 'device_settings';
  static const String lastSyncKey = 'last_sync_timestamp';
  
  // Configuration des logs
  static const bool enableLogging = true;
  static const int maxLogFiles = 5;
  static const int maxLogSizeBytes = 10 * 1024 * 1024; // 10MB
  
  // URLs et endpoints
  static String get authEndpoint => '$baseUrl/auth';
  static String get devicesEndpoint => '$baseUrl/devices';
  static String get environmentalEndpoint => '$baseUrl/environmental';
  static String get activitiesEndpoint => '$baseUrl/activities';
  static String get notificationsEndpoint => '$baseUrl/notifications';
  static String get userEndpoint => '$baseUrl/user';
  
  // Topics MQTT
  static const String mqttTopicEnvironmental = 'lifecompanion/environmental';
  static const String mqttTopicActivity = 'lifecompanion/activity';
  static const String mqttTopicNotifications = 'lifecompanion/notifications';
  static const String mqttTopicDeviceStatus = 'lifecompanion/device/status';
  
  // Validation des données
  static const double maxTemperature = 60.0;
  static const double minTemperature = -40.0;
  static const double maxHumidity = 100.0;
  static const double minHumidity = 0.0;
  static const double maxPressure = 1200.0;
  static const double minPressure = 800.0;
  
  // Configuration des couleurs (hex)
  static const String primaryColorHex = '#2196F3';
  static const String secondaryColorHex = '#4CAF50';
  static const String errorColorHex = '#F44336';
  static const String warningColorHex = '#FF9800';
  static const String successColorHex = '#4CAF50';
  
  // Méthodes de validation
  static bool isValidTemperature(double? temp) {
    return temp != null && temp >= minTemperature && temp <= maxTemperature;
  }
  
  static bool isValidHumidity(double? humidity) {
    return humidity != null && humidity >= minHumidity && humidity <= maxHumidity;
  }
  
  static bool isValidPressure(double? pressure) {
    return pressure != null && pressure >= minPressure && pressure <= maxPressure;
  }
  
  // Configuration par environnement
  static Map<String, dynamic> get environmentConfig {
    if (isDebugMode) {
      return {
        'baseUrl': 'http://localhost:8000/api',
        'mqttHost': 'localhost',
        'enableSSL': false,
        'logLevel': 'debug',
      };
    } else {
      return {
        'baseUrl': 'https://api.lifecompanion.com/api',
        'mqttHost': 'mqtt.lifecompanion.com',
        'enableSSL': true,
        'logLevel': 'info',
      };
    }
  }
} 