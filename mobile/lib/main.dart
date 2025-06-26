import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_it/get_it.dart';

// Imports des blocs et services
import 'blocs/auth/auth_bloc.dart';
import 'blocs/environmental/environmental_bloc.dart';
import 'blocs/activity/activity_bloc.dart';
import 'blocs/notification/notification_bloc.dart';

// Imports des repositories
import 'repositories/api_repository.dart';
import 'repositories/local_database_repository.dart';
import 'repositories/mqtt_repository.dart';

// Imports des services
import 'services/api_service.dart';
import 'services/database_service.dart';
import 'services/mqtt_service.dart';
import 'services/notification_service.dart';

// Imports des pages
import 'ui/pages/splash_page.dart';
import 'ui/pages/auth/login_page.dart';
import 'ui/pages/home/home_page.dart';

// Configuration
import 'config/app_config.dart';
import 'config/theme_config.dart';

// Injection de dépendances
final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuration HydratedBloc pour la persistance d'état
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  
  // Configuration des observateurs Bloc
  Bloc.observer = AppBlocObserver();
  
  // Initialisation des services
  await _setupDependencies();
  
  runApp(const LifeCompanionApp());
}

/// Configuration de l'injection de dépendances
Future<void> _setupDependencies() async {
  // Services de base
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<MqttService>(() => MqttService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  
  // Repositories
  getIt.registerLazySingleton<ApiRepository>(
    () => ApiRepository(getIt<ApiService>())
  );
  getIt.registerLazySingleton<LocalDatabaseRepository>(
    () => LocalDatabaseRepository(getIt<DatabaseService>())
  );
  getIt.registerLazySingleton<MqttRepository>(
    () => MqttRepository(getIt<MqttService>())
  );
  
  // Initialisation asynchrone
  await getIt<DatabaseService>().initialize();
  await getIt<NotificationService>().initialize();
}

/// Application principale LifeCompanion
class LifeCompanionApp extends StatelessWidget {
  const LifeCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Bloc d'authentification
        BlocProvider(
          create: (context) => AuthBloc(
            apiRepository: getIt<ApiRepository>(),
          )..add(const AuthCheckRequested()),
        ),
        
        // Bloc des données environnementales
        BlocProvider(
          create: (context) => EnvironmentalBloc(
            apiRepository: getIt<ApiRepository>(),
            localRepository: getIt<LocalDatabaseRepository>(),
            mqttRepository: getIt<MqttRepository>(),
          ),
        ),
        
        // Bloc de classification d'activités
        BlocProvider(
          create: (context) => ActivityBloc(
            apiRepository: getIt<ApiRepository>(),
            localRepository: getIt<LocalDatabaseRepository>(),
          ),
        ),
        
        // Bloc des notifications
        BlocProvider(
          create: (context) => NotificationBloc(
            apiRepository: getIt<ApiRepository>(),
            notificationService: getIt<NotificationService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'LifeCompanion',
        debugShowCheckedModeBanner: false,
        
        // Configuration du thème
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: ThemeMode.system,
        
        // Configuration de localisation
        locale: const Locale('fr', 'FR'),
        
        // Route initiale
        home: const SplashPage(),
        
        // Routes nommées
        routes: {
          '/splash': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
        },
        
        // Configuration du router
        onGenerateRoute: (settings) {
          // Gestion des routes dynamiques si nécessaire
          return null;
        },
        
        // Gestionnaire d'erreurs
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              // Navigation basée sur l'état d'authentification
              if (state is AuthAuthenticated) {
                Navigator.pushReplacementNamed(context, '/home');
              } else if (state is AuthUnauthenticated) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

/// Observateur personnalisé pour le debugging des Blocs
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(BlocBase bloc, Object? event) {
    super.onEvent(bloc, event);
    // Log des événements en mode debug
    if (AppConfig.isDebugMode) {
      debugPrint('${bloc.runtimeType}: $event');
    }
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // Log des transitions en mode debug
    if (AppConfig.isDebugMode) {
      debugPrint('${bloc.runtimeType}: $transition');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Log des erreurs
    debugPrint('${bloc.runtimeType}: $error');
    debugPrint('StackTrace: $stackTrace');
  }
} 