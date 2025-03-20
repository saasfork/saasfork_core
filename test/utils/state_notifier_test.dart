import 'package:flutter_test/flutter_test.dart';
import 'package:saasfork_core/utils/utils.dart';

// Classe concrète pour tester StateNotifier
class TestStateNotifier<T> extends StateNotifier<T> {
  TestStateNotifier([T? initialState]) {
    if (initialState != null) {
      setState(initialState);
    }
  }
}

void main() {
  group('StateNotifier', () {
    test('vérifier que l\'état initial est null', () {
      // ARRANGE
      final notifier = TestStateNotifier<int>();

      // ACT & ASSERT
      expect(notifier.state, isNull);
    });

    test('initialiser avec une valeur définie', () {
      // ARRANGE
      final initialValue = 10;

      // ACT
      final notifier = TestStateNotifier<int>(initialValue);

      // ASSERT
      expect(notifier.state, equals(initialValue));
    });

    test('mettre à jour l\'état avec setState', () {
      // ARRANGE
      final notifier = TestStateNotifier<int>();
      const newValue = 5;

      // ACT
      notifier.setState(newValue);

      // ASSERT
      expect(notifier.state, equals(newValue));
    });

    test('notifier les listeners lors de la mise à jour avec setState', () {
      // ARRANGE
      final notifier = TestStateNotifier<String>();
      var listenerCalled = false;

      notifier.addListener(() {
        listenerCalled = true;
      });

      // ACT
      notifier.setState('nouveau texte');

      // ASSERT
      expect(listenerCalled, isTrue);
    });

    test('réinitialiser l\'état avec resetState', () {
      // ARRANGE
      final notifier = TestStateNotifier<int>(10);

      // ACT
      notifier.resetState();

      // ASSERT
      expect(notifier.state, isNull);
    });

    test(
      'notifier les listeners lors de la réinitialisation avec resetState',
      () {
        // ARRANGE
        final notifier = TestStateNotifier<bool>(true);
        var listenerCalled = false;

        notifier.addListener(() {
          listenerCalled = true;
        });

        // ACT
        notifier.resetState();

        // ASSERT
        expect(listenerCalled, isTrue);
      },
    );

    test(
      'vérifier que plusieurs appels à setState notifient à chaque fois',
      () {
        // ARRANGE
        final notifier = TestStateNotifier<int>(0);
        var notificationCount = 0;

        notifier.addListener(() {
          notificationCount++;
        });

        // ACT
        notifier.setState(1);
        notifier.setState(2);
        notifier.setState(3);

        // ASSERT
        expect(notificationCount, equals(3));
        expect(notifier.state, equals(3));
      },
    );

    test('vérifier le bon fonctionnement avec un type complexe', () {
      // ARRANGE
      final notifier = TestStateNotifier<Map<String, dynamic>>();
      final userData = {'name': 'Jean', 'age': 30};

      // ACT
      notifier.setState(userData);

      // ASSERT
      expect(notifier.state, isA<Map<String, dynamic>>());
      expect(notifier.state?['name'], equals('Jean'));
      expect(notifier.state?['age'], equals(30));
    });
  });
}
