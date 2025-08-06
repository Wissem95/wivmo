import 'package:equatable/equatable.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {
  const ActivityInitial();
}

class ActivityLoading extends ActivityState {
  const ActivityLoading();
}

class ActivityLoaded extends ActivityState {
  final Map<String, dynamic> currentActivity;
  final List<Map<String, dynamic>> history;

  const ActivityLoaded({
    required this.currentActivity,
    this.history = const [],
  });

  @override
  List<Object?> get props => [currentActivity, history];
}

class ActivityError extends ActivityState {
  final String message;

  const ActivityError({required this.message});

  @override
  List<Object?> get props => [message];
}