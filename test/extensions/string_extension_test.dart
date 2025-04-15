import 'package:flutter_test/flutter_test.dart';
import 'package:saasfork_core/extensions/string_extension.dart';

void main() {
  group('StringExtension', () {
    group('capitalize()', () {
      test('Retourner la chaîne vide quand la chaîne est vide', () {
        // ARRANGE
        const String emptyString = '';

        // ACT
        final result = emptyString.capitalize();

        // ASSERT
        expect(result, equals(''));
      });

      test('Mettre en majuscule le premier caractère d\'une chaîne', () {
        // ARRANGE
        const String input = 'hello';

        // ACT
        final result = input.capitalize();

        // ASSERT
        expect(result, equals('Hello'));
      });

      test(
        'Conserver le premier caractère tel quel s\'il est déjà en majuscule',
        () {
          // ARRANGE
          const String input = 'Hello';

          // ACT
          final result = input.capitalize();

          // ASSERT
          expect(result, equals('Hello'));
        },
      );

      test('Gérer correctement les chaînes d\'un seul caractère', () {
        // ARRANGE
        const String input = 'a';

        // ACT
        final result = input.capitalize();

        // ASSERT
        expect(result, equals('A'));
      });
    });
  });
}
