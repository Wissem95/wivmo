import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/api_repository.dart';
import '../../repositories/local_database_repository.dart';
import '../../repositories/mqtt_repository.dart';
import 'environmental_event.dart';
import 'environmental_state.dart';

class EnvironmentalBloc extends Bloc<EnvironmentalEvent, EnvironmentalState> {
  final ApiRepository apiRepository;
  final LocalDatabaseRepository localRepository;
  final MqttRepository mqttRepository;
  StreamSubscription? _mqttSubscription;

  EnvironmentalBloc({
    required this.apiRepository,
    required this.localRepository,
    required this.mqttRepository,
  }) : super(const EnvironmentalInitial()) {
    on<EnvironmentalDataRequested>(_onDataRequested);
    on<EnvironmentalDataReceived>(_onDataReceived);
    on<EnvironmentalHistoryRequested>(_onHistoryRequested);

    // Écouter les données MQTT en temps réel
    _mqttSubscription = mqttRepository.environmentalStream.listen((data) {
      add(EnvironmentalDataReceived(data));
    });
  }

  Future<void> _onDataRequested(
    EnvironmentalDataRequested event,
    Emitter<EnvironmentalState> emit,
  ) async {
    try {
      emit(const EnvironmentalLoading());
      
      // Essayer d'abord les données locales pour un affichage rapide
      final localData = await localRepository.getLatestEnvironmentalData();
      if (localData != null) {
        emit(EnvironmentalLoaded(currentData: localData));
      }
      
      // Puis récupérer les données fraîches via l'API
      final apiData = await apiRepository.getCurrentEnvironmentalData();
      
      // Sauvegarder localement
      await localRepository.saveEnvironmentalData(apiData);
      
      emit(EnvironmentalLoaded(currentData: apiData));
    } catch (e) {
      emit(EnvironmentalError(message: 'Erreur lors du chargement: ${e.toString()}'));
    }
  }

  Future<void> _onDataReceived(
    EnvironmentalDataReceived event,
    Emitter<EnvironmentalState> emit,
  ) async {
    try {
      // Sauvegarder les nouvelles données localement
      await localRepository.saveEnvironmentalData(event.data);
      
      // Mettre à jour l'état
      final currentState = state;
      if (currentState is EnvironmentalLoaded) {
        emit(currentState.copyWith(currentData: event.data));
      } else {
        emit(EnvironmentalLoaded(currentData: event.data));
      }
    } catch (e) {
      emit(EnvironmentalError(message: 'Erreur lors de la réception: ${e.toString()}'));
    }
  }

  Future<void> _onHistoryRequested(
    EnvironmentalHistoryRequested event,
    Emitter<EnvironmentalState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is EnvironmentalLoaded) {
        emit(const EnvironmentalLoading());
        
        final history = await apiRepository.getEnvironmentalHistory(
          startDate: event.startDate,
          endDate: event.endDate,
        );
        
        emit(currentState.copyWith(history: history));
      }
    } catch (e) {
      emit(EnvironmentalError(message: 'Erreur historique: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _mqttSubscription?.cancel();
    return super.close();
  }
}