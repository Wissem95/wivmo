# 📱 T003 - Frontend Flutter Foundation

**Sprint**: 1 | **Points**: 13 | **Assigné**: Wissem | **Priorité**: CRITICAL

---

## 🎯 **Objectif**

Créer l'application Flutter avec l'architecture Bloc, la navigation et les écrans de base pour LifeCompanion.

## 📋 **Acceptance Criteria**

- [ ] Structure de projet Flutter optimisée avec dossiers organisés
- [ ] Configuration Bloc Pattern avec états et événements
- [ ] Navigation GoRouter configurée avec routes protégées
- [ ] Écrans principaux : Splash, Login, Home, Dashboard, Settings
- [ ] Thème Material Design cohérent (dark/light mode)
- [ ] Composants réutilisables (widgets custom)
- [ ] Configuration des dépendances principales
- [ ] State management offline-first avec HydratedBloc
- [ ] Tests widgets et unit tests de base

---

## 🔧 **Prompts à Utiliser**

### **1. Architecture Flutter avec Bloc Pattern**

```bash
# Prompt pour architecture Flutter
Je développe une application Flutter IoT avec architecture Bloc.
Structure nécessaire :

**Fonctionnalités principales** :
- Authentification utilisateur
- Dashboard environnemental temps réel
- Historique des activités
- Paramètres et préférences
- Notifications

**Structure de dossiers optimale** :
lib/
├── blocs/ (gestion d'état)
├── models/ (modèles de données)
├── repositories/ (couche données)
├── services/ (services métier)
├── ui/ (interface utilisateur)
└── utils/ (utilitaires)

J'ai besoin de :
- Setup Bloc Pattern avec HydratedBloc pour persistance
- Configuration des providers Bloc
- Structure des événements et états pour chaque fonctionnalité
- Organisation des dossiers optimisée
- Configuration des dépendances pubspec.yaml

Fournis la structure complète avec exemples concrets.
```

### **2. Navigation et Routing Flutter**

```bash
# Prompt pour navigation GoRouter
Je veux configurer GoRouter pour une app Flutter avec :

**Routes nécessaires** :
- / (Splash Screen)
- /login (Authentification)
- /home (Dashboard principal)
- /environmental (Données environnementales)
- /activity (Historique activités)
- /settings (Paramètres)
- /profile (Profil utilisateur)

**Fonctionnalités requises** :
- Routes protégées nécessitant authentification
- Deep linking
- Navigation par onglets dans la partie authentifiée
- Transitions animées entre écrans
- Gestion des paramètres de route

J'ai besoin de :
- Configuration GoRouter complète
- Middleware d'authentification
- Navigation guards
- Gestion des erreurs 404
- Integration avec Bloc pour l'état auth

Fournis la configuration complète avec exemples.
```

### **3. Thème et Design System**

```bash
# Prompt pour thème Material Design
Je crée un thème Flutter pour une app IoT moderne.

**Identité visuelle** :
- Couleurs : Bleu primaire, vert secondaire, gris neutres
- Support dark/light mode
- Typography : Roboto avec variations
- Composants : Cards, Buttons, Inputs, Charts

**Composants custom nécessaires** :
- EnvironmentalCard (affichage données capteurs)
- ActivityTimeline (timeline des activités)
- MetricWidget (affichage métriques)
- NotificationBanner (notifications)
- LoadingOverlay (états de chargement)

J'ai besoin de :
- ThemeData complet (light/dark)
- Couleurs et typography cohérentes
- Widgets custom réutilisables
- Responsive design (phone/tablet)
- Animations et transitions

Fournis le code complet du design system.
```

### **4. State Management avec Bloc**

```bash
# Prompt pour Bloc Pattern implémentation
Je veux implémenter le Bloc Pattern pour une app IoT Flutter.

**Blocs nécessaires** :
- **AuthBloc** : login, logout, register, token management
- **EnvironmentalBloc** : données capteurs temps réel, historique
- **ActivityBloc** : classification activités, statistiques
- **NotificationBloc** : notifications, mark as read
- **SettingsBloc** : préférences, thème, configuration

**États pour chaque Bloc** :
- Initial, Loading, Success, Error
- États spécifiques (ex: AuthAuthenticated, AuthUnauthenticated)

**Événements typiques** :
- Load, Refresh, Update, Delete
- Événements spécifiques (ex: AuthLoginRequested)

J'ai besoin de :
- Implémentation complète de chaque Bloc
- Gestion d'erreurs robuste
- Persistance avec HydratedBloc
- Integration repositories
- Tests unitaires pour chaque Bloc

Fournis le code complet avec exemples d'usage.
```

---

## 📝 **Actions Détaillées**

### **Étape 1 : Configuration Initiale**

1. **Nettoyer le projet Flutter par défaut**

   ```bash
   # Supprimer les fichiers de démo
   rm lib/main.dart test/widget_test.dart
   ```

2. **Configurer pubspec.yaml avec dépendances**
   ```yaml
   dependencies:
     flutter_bloc: ^8.1.3
     hydrated_bloc: ^9.1.2
     go_router: ^12.1.1
     dio: ^5.3.2
     cached_network_image: ^3.3.0
     flutter_secure_storage: ^9.0.0
     sqflite: ^2.3.0
     # ... autres dépendances
   ```

### **Étape 2 : Structure des Dossiers**

1. **Créer la structure de dossiers**
   ```
   lib/
   ├── blocs/
   │   ├── auth/
   │   ├── environmental/
   │   ├── activity/
   │   └── settings/
   ├── models/
   ├── repositories/
   ├── services/
   ├── ui/
   │   ├── pages/
   │   ├── widgets/
   │   └── themes/
   └── utils/
   ```

### **Étape 3 : Configuration Bloc**

1. **Créer les Blocs principaux**

   ```bash
   # AuthBloc
   - auth_bloc.dart
   - auth_event.dart
   - auth_state.dart

   # EnvironmentalBloc
   - environmental_bloc.dart
   - environmental_event.dart
   - environmental_state.dart
   ```

2. **Configurer HydratedBloc pour persistance**
3. **Setup Bloc providers dans main.dart**

### **Étape 4 : Navigation et Routes**

1. **Configurer GoRouter**
2. **Créer les écrans de base**
3. **Implémenter la navigation protégée**

### **Étape 5 : Thème et UI**

1. **Créer le design system**
2. **Implémenter les écrans principaux**
3. **Créer les widgets réutilisables**

### **Étape 6 : Tests**

1. **Tests unitaires pour les Blocs**
2. **Tests widgets pour les composants**
3. **Tests d'intégration navigation**

---

## 📱 **Écrans à Implémenter**

### **1. SplashScreen**

```dart
// Affichage logo, vérification auth, redirection
- Logo animé LifeCompanion
- Vérification token stocké
- Redirection vers /home ou /login
```

### **2. LoginScreen**

```dart
// Formulaire authentification
- Champs email/password
- Validation en temps réel
- Loading states
- Gestion erreurs
```

### **3. HomeScreen**

```dart
// Dashboard principal avec navigation tabs
- AppBar avec profil
- BottomNavigationBar
- Contenu dynamique selon tab
```

### **4. EnvironmentalScreen**

```dart
// Affichage données environnementales
- Métriques temps réel
- Graphiques historiques
- Score de confort
```

### **5. ActivityScreen**

```dart
// Historique des activités
- Timeline des activités
- Statistiques
- Filtres par date
```

### **6. SettingsScreen**

```dart
// Paramètres utilisateur
- Préférences notifications
- Thème dark/light
- Configuration devices
```

---

## 🎨 **Design System**

### **Couleurs**

```dart
// Palette principale
primary: Color(0xFF2196F3),        // Bleu
primaryVariant: Color(0xFF1976D2),
secondary: Color(0xFF4CAF50),      // Vert
background: Color(0xFFF5F5F5),
surface: Color(0xFFFFFFFF),
error: Color(0xFFE53935),
```

### **Typography**

```dart
// Styles de texte
headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
headline2: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
caption: TextStyle(fontSize: 12, color: Colors.grey[600]),
```

### **Widgets Custom**

```dart
// Composants réutilisables
- EnvironmentalCard
- MetricDisplay
- ActivityChip
- LoadingButton
- ErrorBanner
```

---

## 🧪 **Tests à Implémenter**

### **Tests Blocs**

```dart
// auth_bloc_test.dart
- test_initial_state_is_unauthenticated()
- test_login_success_emits_authenticated()
- test_login_failure_emits_error()
- test_logout_emits_unauthenticated()
```

### **Tests Widgets**

```dart
// login_screen_test.dart
- test_displays_login_form()
- test_validates_email_input()
- test_shows_loading_on_submit()
- test_displays_error_message()
```

### **Tests Navigation**

```dart
// router_test.dart
- test_redirects_unauthenticated_to_login()
- test_authenticated_accesses_home()
- test_deep_links_work()
```

---

## ✅ **Definition of Done**

- [ ] Structure projet organisée et cohérente
- [ ] Bloc Pattern configuré et fonctionnel
- [ ] Navigation GoRouter opérationnelle
- [ ] Écrans principaux implémentés
- [ ] Thème cohérent (dark/light mode)
- [ ] Widgets réutilisables créés
- [ ] Tests unitaires et widgets passants
- [ ] Code respectant les conventions Dart/Flutter
- [ ] Documentation des composants
- [ ] Performance optimisée (pas de rebuild inutiles)

---

## 🔗 **Dépendances**

- **Précédent**: T001 - Setup Environnement
- **Suivant**: T006 - API Integration Flutter

---

## 📚 **Ressources**

- [Flutter Bloc Documentation](https://bloclibrary.dev/)
- [GoRouter Documentation](https://docs.flutter.dev/development/ui/navigation/url-strategies)
- [Material Design Guidelines](https://material.io/design)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)

---

_Tâche créée le 25 juin 2025 - LifeCompanion Project_
