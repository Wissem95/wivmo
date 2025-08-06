import 'package:equatable/equatable.dart';

abstract class EnvironmentalState extends Equatable {
  const EnvironmentalState();

  @override
  List<Object?> get props => [];
}

class EnvironmentalInitial extends EnvironmentalState {
  const EnvironmentalInitial();
}

class EnvironmentalLoading extends EnvironmentalState {
  const EnvironmentalLoading();
}

class EnvironmentalLoaded extends EnvironmentalState {
  final Map<String, dynamic> currentData;
  final List<Map<String, dynamic>> history;

  const EnvironmentalLoaded({
    required this.currentData,
    this.history = const [],
  });

  @override
  List<Object?> get props => [currentData, history];

  EnvironmentalLoaded copyWith({
    Map<String, dynamic>? currentData,
    List<Map<String, dynamic>>? history,
  }) {
    return EnvironmentalLoaded(
      currentData: currentData ?? this.currentData,
      history: history ?? this.history,
    );
  }
}

class EnvironmentalError extends EnvironmentalState {
  final String message;

  const EnvironmentalError({required this.message});

  @override
  List<Object?> get props => [message];
}