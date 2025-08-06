import '../services/mqtt_service.dart';

class MqttRepository {
  final MqttService _mqttService;

  MqttRepository(this._mqttService);

  // Stream des données environnementales en temps réel
  Stream<Map<String, dynamic>> get environmentalStream => _mqttService.environmentalStream;

  // Stream des classifications d'activité en temps réel
  Stream<Map<String, dynamic>> get activityStream => _mqttService.activityStream;

  // Stream des notifications en temps réel
  Stream<Map<String, dynamic>> get notificationStream => _mqttService.notificationStream;

  // Connexion et déconnexion
  Future<void> connect() async {
    await _mqttService.connect();
  }

  Future<void> disconnect() async {
    await _mqttService.disconnect();
  }

  // Publication de messages
  Future<void> publishMessage(String topic, Map<String, dynamic> message) async {
    await _mqttService.publishMessage(topic, message);
  }
}