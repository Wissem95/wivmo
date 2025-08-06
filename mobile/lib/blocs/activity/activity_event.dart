import 'package:equatable/equatable.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class ActivityDataRequested extends ActivityEvent {
  const ActivityDataRequested();
}

class ActivityClassificationReceived extends ActivityEvent {
  final Map<String, dynamic> classification;

  const ActivityClassificationReceived(this.classification);

  @override
  List<Object?> get props => [classification];
}