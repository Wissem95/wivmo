import '../services/api_service.dart';

class ApiRepository {
  final ApiService _apiService;

  ApiRepository(this._apiService);

  // Authentification
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _apiService.login(email: email, password: password);
  }

  Future<void> logout() async {
    return await _apiService.logout();
  }

  Future<String?> refreshToken() async {
    return await _apiService.refreshToken();
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    return await _apiService.getCurrentUser();
  }

  // Données environnementales
  Future<Map<String, dynamic>> getCurrentEnvironmentalData() async {
    return await _apiService.getCurrentEnvironmentalData();
  }

  Future<List<Map<String, dynamic>>> getEnvironmentalHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _apiService.getEnvironmentalHistory(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Activités
  Future<Map<String, dynamic>> getCurrentActivity() async {
    return await _apiService.getCurrentActivity();
  }

  Future<List<Map<String, dynamic>>> getActivityHistory() async {
    return await _apiService.getActivityHistory();
  }

  // Notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    return await _apiService.getNotifications();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    return await _apiService.markNotificationAsRead(notificationId);
  }
}