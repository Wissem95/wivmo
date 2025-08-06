import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/api_repository.dart';
import '../../repositories/local_database_repository.dart';
import 'activity_event.dart';
import 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ApiRepository apiRepository;
  final LocalDatabaseRepository localRepository;

  ActivityBloc({
    required this.apiRepository,
    required this.localRepository,
  }) : super(const ActivityInitial()) {
    on<ActivityDataRequested>(_onDataRequested);
    on<ActivityClassificationReceived>(_onClassificationReceived);
  }

  Future<void> _onDataRequested(
    ActivityDataRequested event,
    Emitter<ActivityState> emit,
  ) async {
    try {
      emit(const ActivityLoading());
      
      final data = await apiRepository.getCurrentActivity();
      emit(ActivityLoaded(currentActivity: data));
    } catch (e) {
      emit(ActivityError(message: e.toString()));
    }
  }

  Future<void> _onClassificationReceived(
    ActivityClassificationReceived event,
    Emitter<ActivityState> emit,
  ) async {
    try {
      await localRepository.saveActivityData(event.classification);
      emit(ActivityLoaded(currentActivity: event.classification));
    } catch (e) {
      emit(ActivityError(message: e.toString()));
    }
  }
}