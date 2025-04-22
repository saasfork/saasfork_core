import 'package:flutter_test/flutter_test.dart';
import 'package:saasfork_core/utils/debounce.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  late Debouncer debouncer;

  setUp(() {
    debouncer = Debouncer();
  });

  test('Exécuter une action après le délai spécifié', () {
    // ARRANGE
    bool actionExecuted = false;
    void action() => actionExecuted = true;

    // ACT & ASSERT
    fakeAsync((async) {
      debouncer.run(action);
      expect(actionExecuted, false);

      async.elapse(Duration(milliseconds: 499));
      expect(actionExecuted, false);

      async.elapse(Duration(milliseconds: 1));
      expect(actionExecuted, true);
    });
  });

  test('Annuler les exécutions précédentes lors des appels consécutifs', () {
    // ARRANGE
    int executionCount = 0;
    void action() => executionCount++;

    // ACT & ASSERT
    fakeAsync((async) {
      debouncer.run(action);
      async.elapse(Duration(milliseconds: 200));

      debouncer.run(action);
      async.elapse(Duration(milliseconds: 200));

      debouncer.run(action);
      async.elapse(Duration(milliseconds: 500));

      expect(executionCount, 1);
    });
  });

  test('Exécuter l\'action avec un délai personnalisé', () {
    // ARRANGE
    bool actionExecuted = false;
    void action() => actionExecuted = true;
    const customDelay = 300;

    // ACT & ASSERT
    fakeAsync((async) {
      debouncer.run(action, milliseconds: customDelay);

      async.elapse(Duration(milliseconds: customDelay - 1));
      expect(actionExecuted, false);

      async.elapse(Duration(milliseconds: 1));
      expect(actionExecuted, true);
    });
  });

  test('Annuler une exécution programmée', () {
    // ARRANGE
    bool actionExecuted = false;
    void action() => actionExecuted = true;

    // ACT & ASSERT
    fakeAsync((async) {
      debouncer.run(action);
      debouncer.cancel();

      async.elapse(Duration(milliseconds: 500));
      expect(actionExecuted, false);
    });
  });
}
