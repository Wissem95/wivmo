import 'package:equatable/equatable.dart';

abstract class EnvironmentalEvent extends Equatable {
  const EnvironmentalEvent();

  @override
  List<Object?> get props => [];
}

class EnvironmentalDataRequested extends EnvironmentalEvent {
  const EnvironmentalDataRequested();
}

class EnvironmentalDataReceived extends EnvironmentalEvent {
  final Map<String, dynamic> data;

  const EnvironmentalDataReceived(this.data);

  @override
  List<Object?> get props => [data];
}

class EnvironmentalHistoryRequested extends EnvironmentalEvent {
  final DateTime startDate;
  final DateTime endDate;

  const EnvironmentalHistoryRequested({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}