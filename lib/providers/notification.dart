import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotificationType { error, success, info, warning }

class NotificationState {
  final String? message;
  final String? title;
  final NotificationType type;
  final bool hasNotification;

  NotificationState({
    this.message,
    this.title,
    required this.type,
    this.hasNotification = false,
  });

  NotificationState copyWith({
    String? message,
    String? title,
    required NotificationType type,
    bool? hasNotification,
  }) {
    return NotificationState(
      message: message ?? this.message,
      title: title ?? this.title,
      type: type,
      hasNotification: hasNotification ?? this.hasNotification,
    );
  }

  NotificationState clear() {
    return NotificationState(
      message: null,
      title: null,
      type: NotificationType.info,
      hasNotification: false,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier()
    : super(NotificationState(type: NotificationType.info));

  void showError(String message, {String? title}) {
    state = state.copyWith(
      message: message,
      title: title,
      type: NotificationType.error,
      hasNotification: true,
    );
  }

  void showSuccess(String message, {String? title}) {
    state = state.copyWith(
      message: message,
      title: title,
      type: NotificationType.success,
      hasNotification: true,
    );
  }

  void showInfo(String message, {String? title}) {
    state = state.copyWith(
      message: message,
      title: title,
      type: NotificationType.info,
      hasNotification: true,
    );
  }

  void showWarning(String message, {String? title}) {
    state = state.copyWith(
      message: message,
      title: title,
      type: NotificationType.warning,
      hasNotification: true,
    );
  }

  void clear() {
    state = state.clear();
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
      (ref) => NotificationNotifier(),
    );
