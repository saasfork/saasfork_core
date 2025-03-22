import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/providers/notification.dart';

void main() {
  late NotificationNotifier notificationNotifier;

  setUp(() {
    notificationNotifier = NotificationNotifier();
  });

  group('NotificationState', () {
    test('should create an instance with default values', () {
      final state = NotificationState(type: NotificationType.info);

      expect(state.message, isNull);
      expect(state.title, isNull);
      expect(state.type, NotificationType.info);
      expect(state.hasNotification, false);
    });

    test('copyWith should return a new instance with updated values', () {
      final state = NotificationState(type: NotificationType.info);
      final newState = state.copyWith(
        message: 'Test message',
        title: 'Test title',
        type: NotificationType.error,
        hasNotification: true,
      );

      expect(newState.message, 'Test message');
      expect(newState.title, 'Test title');
      expect(newState.type, NotificationType.error);
      expect(newState.hasNotification, true);
    });

    test('clear should reset all values', () {
      final state = NotificationState(
        message: 'Test message',
        title: 'Test title',
        type: NotificationType.error,
        hasNotification: true,
      );

      final clearedState = state.clear();

      expect(clearedState.message, isNull);
      expect(clearedState.title, isNull);
      expect(clearedState.type, NotificationType.info);
      expect(clearedState.hasNotification, false);
    });
  });

  group('NotificationNotifier', () {
    test('should initialize with default state', () {
      expect(notificationNotifier.state.type, NotificationType.info);
      expect(notificationNotifier.state.hasNotification, false);
      expect(notificationNotifier.state.message, isNull);
      expect(notificationNotifier.state.title, isNull);
    });

    test('showError should update state with error notification', () {
      notificationNotifier.showError('Error message', title: 'Error title');

      expect(notificationNotifier.state.message, 'Error message');
      expect(notificationNotifier.state.title, 'Error title');
      expect(notificationNotifier.state.type, NotificationType.error);
      expect(notificationNotifier.state.hasNotification, true);
    });

    test('showSuccess should update state with success notification', () {
      notificationNotifier.showSuccess(
        'Success message',
        title: 'Success title',
      );

      expect(notificationNotifier.state.message, 'Success message');
      expect(notificationNotifier.state.title, 'Success title');
      expect(notificationNotifier.state.type, NotificationType.success);
      expect(notificationNotifier.state.hasNotification, true);
    });

    test('showInfo should update state with info notification', () {
      notificationNotifier.showInfo('Info message', title: 'Info title');

      expect(notificationNotifier.state.message, 'Info message');
      expect(notificationNotifier.state.title, 'Info title');
      expect(notificationNotifier.state.type, NotificationType.info);
      expect(notificationNotifier.state.hasNotification, true);
    });

    test('showWarning should update state with warning notification', () {
      notificationNotifier.showWarning(
        'Warning message',
        title: 'Warning title',
      );

      expect(notificationNotifier.state.message, 'Warning message');
      expect(notificationNotifier.state.title, 'Warning title');
      expect(notificationNotifier.state.type, NotificationType.warning);
      expect(notificationNotifier.state.hasNotification, true);
    });

    test('clear should reset the notification state', () {
      // Set a notification first
      notificationNotifier.showInfo('Info message');
      expect(notificationNotifier.state.hasNotification, true);

      // Then clear it
      notificationNotifier.clear();

      expect(notificationNotifier.state.message, isNull);
      expect(notificationNotifier.state.title, isNull);
      expect(notificationNotifier.state.type, NotificationType.info);
      expect(notificationNotifier.state.hasNotification, false);
    });
  });

  group('notificationProvider', () {
    test('should provide a NotificationNotifier instance', () {
      final container = ProviderContainer();
      final notifier = container.read(notificationProvider.notifier);
      final state = container.read(notificationProvider);

      expect(notifier, isA<NotificationNotifier>());
      expect(state, isA<NotificationState>());
      expect(state.type, NotificationType.info);
      expect(state.hasNotification, false);
    });
  });
}
