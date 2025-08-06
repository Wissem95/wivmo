import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ApiService {
  late final Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.apiTimeout,
      receiveTimeout: AppConfig.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _dio.interceptors.add(_AuthInterceptor());
  }

  // Authentification
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  Future<String?> refreshToken() async {
    final response = await _dio.post('/auth/refresh');
    return response.data['data']?['token'] as String?;
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _dio.get('/auth/me');
    return response.data;
  }

  // Données environnementales
  Future<Map<String, dynamic>> getCurrentEnvironmentalData() async {
    final response = await _dio.get('/environmental/current');
    return response.data;
  }

  Future<List<Map<String, dynamic>>> getEnvironmentalHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _dio.get('/environmental/history', queryParameters: {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    });
    return List<Map<String, dynamic>>.from(response.data);
  }

  // Activités
  Future<Map<String, dynamic>> getCurrentActivity() async {
    final response = await _dio.get('/activities/current');
    return response.data;
  }

  Future<List<Map<String, dynamic>>> getActivityHistory() async {
    final response = await _dio.get('/activities/history');
    return List<Map<String, dynamic>>.from(response.data);
  }

  // Notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await _dio.get('/notifications');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _dio.patch('/notifications/$notificationId/read');
  }
}

// Intercepteur pour ajouter automatiquement le token d'authentification
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConfig.userTokenKey);
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expíré, supprimer le token local
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConfig.userTokenKey);
    }
    
    handler.next(err);
  }
}