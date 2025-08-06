import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/api_repository.dart';
import '../../services/notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final ApiRepository apiRepository;
  final NotificationService notificationService;

  NotificationBloc({
    required this.apiRepository,
    required this.notificationService,
  }) : super(const NotificationInitial()) {
    on<NotificationLoadRequested>(_onLoadRequested);
    on<NotificationReceived>(_onNotificationReceived);
    on<NotificationMarkAsRead>(_onMarkAsRead);
  }

  Future<void> _onLoadRequested(
    NotificationLoadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());
      
      final notifications = await apiRepository.getNotifications();
      final unreadCount = notifications.where((n) => !n['read']).length;
      
      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      final updatedNotifications = [event.notification, ...currentState.notifications];
      emit(NotificationLoaded(
        notifications: updatedNotifications,
        unreadCount: currentState.unreadCount + 1,
      ));
    }
  }

  Future<void> _onMarkAsRead(
    NotificationMarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await apiRepository.markNotificationAsRead(event.notificationId);
      
      final currentState = state;
      if (currentState is NotificationLoaded) {
        final updatedNotifications = currentState.notifications.map((n) {
          if (n['id'] == event.notificationId) {
            return {...n, 'read': true};
          }
          return n;
        }).toList();
        
        emit(NotificationLoaded(
          notifications: updatedNotifications,
          unreadCount: currentState.unreadCount - 1,
        ));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }
}