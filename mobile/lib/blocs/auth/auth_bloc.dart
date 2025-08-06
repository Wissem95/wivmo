import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/api_repository.dart';
import '../../config/app_config.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiRepository apiRepository;

  AuthBloc({required this.apiRepository}) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthTokenRefreshRequested>(_onAuthTokenRefreshRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConfig.userTokenKey);
      
      if (token != null && token.isNotEmpty) {
        // Vérifier la validité du token avec l'API
        try {
          final response = await apiRepository.getCurrentUser();
          // Structure de réponse: {"success": true, "data": {"user": {...}}}
          final user = response['data']['user'] as Map<String, dynamic>;
          emit(AuthAuthenticated(token: token, user: user));
        } catch (e) {
          // Token invalide, supprimer et déconnecter
          await prefs.remove(AppConfig.userTokenKey);
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Erreur lors de la vérification: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      
      final response = await apiRepository.login(
        email: event.email,
        password: event.password,
      );
      
      // Structure de réponse: {"success": true, "data": {"token": "...", "user": {...}}}
      final data = response['data'] as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;
      
      // Sauvegarder le token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.userTokenKey, token);
      
      emit(AuthAuthenticated(token: token, user: user));
    } catch (e) {
      emit(AuthError(message: 'Erreur de connexion: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      
      // Nettoyer le token local
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConfig.userTokenKey);
      
      // Optionnel: appeler l'API de logout
      try {
        await apiRepository.logout();
      } catch (e) {
        // Ignorer les erreurs de logout côté serveur
      }
      
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Erreur lors de la déconnexion: ${e.toString()}'));
    }
  }

  Future<void> _onAuthTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final newToken = await apiRepository.refreshToken();
      
      if (newToken == null) {
        throw Exception('Token refresh failed - null token received');
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.userTokenKey, newToken);
      
      final response = await apiRepository.getCurrentUser();
      final user = response['data']['user'] as Map<String, dynamic>;
      emit(AuthAuthenticated(token: newToken, user: user));
    } catch (e) {
      // En cas d'erreur de refresh, déconnecter l'utilisateur
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConfig.userTokenKey);
      emit(const AuthUnauthenticated());
    }
  }
}