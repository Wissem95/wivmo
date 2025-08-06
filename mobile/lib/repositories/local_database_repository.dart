import '../services/database_service.dart';

class LocalDatabaseRepository {
  final DatabaseService _databaseService;

  LocalDatabaseRepository(this._databaseService);

  // Données environnementales
  Future<void> saveEnvironmentalData(Map<String, dynamic> data) async {
    await _databaseService.insertEnvironmentalData(data);
  }

  Future<Map<String, dynamic>?> getLatestEnvironmentalData() async {
    return await _databaseService.getLatestEnvironmentalData();
  }

  Future<List<Map<String, dynamic>>> getEnvironmentalDataRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _databaseService.getEnvironmentalDataRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Activités
  Future<void> saveActivityData(Map<String, dynamic> data) async {
    await _databaseService.insertActivityData(data);
  }

  Future<Map<String, dynamic>?> getLatestActivityData() async {
    return await _databaseService.getLatestActivityData();
  }

  // Synchronisation
  Future<List<Map<String, dynamic>>> getUnsyncedData() async {
    return await _databaseService.getUnsyncedData();
  }

  Future<void> markDataAsSynced(List<String> ids) async {
    await _databaseService.markDataAsSynced(ids);
  }
}