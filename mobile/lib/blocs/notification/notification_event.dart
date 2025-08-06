import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationLoadRequested extends NotificationEvent {
  const NotificationLoadRequested();
}

class NotificationReceived extends NotificationEvent {
  final Map<String, dynamic> notification;

  const NotificationReceived(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotificationMarkAsRead extends NotificationEvent {
  final String notificationId;

  const NotificationMarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}