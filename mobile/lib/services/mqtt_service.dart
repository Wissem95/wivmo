import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../config/app_config.dart';

class MqttService {
  MqttServerClient? _client;
  final StreamController<Map<String, dynamic>> _environmentalController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _activityController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _notificationController = StreamController.broadcast();

  Stream<Map<String, dynamic>> get environmentalStream => _environmentalController.stream;
  Stream<Map<String, dynamic>> get activityStream => _activityController.stream;
  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;

  Future<void> connect() async {
    _client = MqttServerClient(AppConfig.mqttHost, AppConfig.mqttClientId);
    _client!.port = AppConfig.mqttPort;
    _client!.keepAlivePeriod = 20;
    _client!.connectTimeoutPeriod = 2000;
    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onSubscribed = _onSubscribed;

    try {
      await _client!.connect();
    } catch (e) {
      print('Erreur de connexion MQTT: $e');
      _client!.disconnect();
    }
  }

  void _onConnected() {
    print('MQTT connecté');
    _subscribeToTopics();
  }

  void _onDisconnected() {
    print('MQTT déconnecté');
  }

  void _onSubscribed(String topic) {
    print('Abonné au topic: $topic');
  }

  void _subscribeToTopics() {
    _client!.subscribe(AppConfig.mqttTopicEnvironmental, MqttQos.atMostOnce);
    _client!.subscribe(AppConfig.mqttTopicActivity, MqttQos.atMostOnce);
    _client!.subscribe(AppConfig.mqttTopicNotifications, MqttQos.atMostOnce);
    
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>> messages) {
      for (final message in messages) {
        _handleMessage(message);
      }
    });
  }

  void _handleMessage(MqttReceivedMessage<MqttMessage?> message) {
    final topic = message.topic;
    final payload = MqttPublishPayload.bytesToStringAsString(
      (message.payload as MqttPublishMessage).payload.message,
    );

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      
      if (topic == AppConfig.mqttTopicEnvironmental) {
        _environmentalController.add(data);
      } else if (topic == AppConfig.mqttTopicActivity) {
        _activityController.add(data);
      } else if (topic == AppConfig.mqttTopicNotifications) {
        _notificationController.add(data);
      }
    } catch (e) {
      print('Erreur parsing JSON MQTT: $e');
    }
  }

  Future<void> publishMessage(String topic, Map<String, dynamic> message) async {
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(jsonEncode(message));
      _client!.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    }
  }

  Future<void> disconnect() async {
    _client?.disconnect();
    await _environmentalController.close();
    await _activityController.close();
    await _notificationController.close();
  }
}