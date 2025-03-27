import 'package:flutter_test/flutter_test.dart';
import 'package:cross_file/cross_file.dart';
import 'package:saasfork_core/models/image_value.dart';
import 'dart:typed_data';

void main() {
  group('ImageValue', () {
    test('fromFile devrait créer une ImageValue avec un fichier', () {
      final file = XFile.fromData(Uint8List(0), name: 'test.jpg');
      final imageValue = ImageValue.fromFile(file);

      expect(imageValue.file, equals(file));
      expect(imageValue.url, isNull);
      expect(imageValue.isChanged, isTrue);
      expect(imageValue.isValid, isTrue);
      expect(imageValue.displayValue, equals(file));
    });

    test('fromUrl devrait créer une ImageValue avec une URL', () {
      const url = 'https://example.com/image.jpg';
      final imageValue = ImageValue.fromUrl(url);

      expect(imageValue.file, isNull);
      expect(imageValue.url, equals(url));
      expect(imageValue.isChanged, isFalse);
      expect(imageValue.isValid, isTrue);
      expect(imageValue.displayValue, equals(url));
    });

    group('fromDynamic', () {
      test('devrait accepter un XFile', () {
        final file = XFile.fromData(Uint8List(0), name: 'test.jpg');
        final imageValue = ImageValue.fromDynamic(file);

        expect(imageValue.file, equals(file));
        expect(imageValue.url, isNull);
        expect(imageValue.isChanged, isTrue);
      });

      test('devrait accepter une URL valide', () {
        const url = 'https://example.com/image.jpg';
        final imageValue = ImageValue.fromDynamic(url);

        expect(imageValue.file, isNull);
        expect(imageValue.url, equals(url));
        expect(imageValue.isChanged, isFalse);
      });

      test('devrait retourner une ImageValue pour un string non-URL', () {
        const nonUrl = 'not-a-url';
        final imageValue = ImageValue.fromDynamic(nonUrl);

        expect(imageValue.file, isNull);
        expect(imageValue.url, isNull);
        expect(imageValue.isValid, isFalse);
      });

      test('devrait accepter une instance d\'ImageValue', () {
        final original = ImageValue.fromUrl('https://example.com/image.jpg');
        final copied = ImageValue.fromDynamic(original);

        expect(copied.url, equals(original.url));
        expect(copied.file, equals(original.file));
        expect(copied.isChanged, equals(original.isChanged));
      });

      test('devrait retourner une ImageValue vide pour null', () {
        final imageValue = ImageValue.fromDynamic(null);

        expect(imageValue.file, isNull);
        expect(imageValue.url, isNull);
        expect(imageValue.isValid, isFalse);
      });
    });

    test(
      'isValid devrait retourner false quand ni file ni url ne sont définis',
      () {
        const imageValue = ImageValue();
        expect(imageValue.isValid, isFalse);
      },
    );

    test('isValid devrait retourner false quand url est vide', () {
      const imageValue = ImageValue(url: '');
      expect(imageValue.isValid, isFalse);
    });

    test('toString devrait afficher les infos du fichier quand disponible', () {
      final file = XFile.fromData(
        Uint8List(0),
        name: 'test.jpg',
        path: '/path/to/test.jpg',
      );
      final imageValue = ImageValue.fromFile(file);

      expect(imageValue.toString(), equals('File: /path/to/test.jpg'));
    });

    test('toString devrait afficher l\'URL quand disponible sans fichier', () {
      const url = 'https://example.com/image.jpg';
      final imageValue = ImageValue.fromUrl(url);

      expect(
        imageValue.toString(),
        equals('URL: https://example.com/image.jpg'),
      );
    });

    test(
      'toString devrait afficher un message par défaut sans fichier ni URL',
      () {
        const imageValue = ImageValue();
        expect(imageValue.toString(), equals('No image'));
      },
    );

    test('copyWith devrait créer une copie avec des valeurs modifiées', () {
      const originalValue = ImageValue(url: 'https://example.com/image.jpg');
      final file = XFile.fromData(Uint8List(0), name: 'test.jpg');

      final copied = originalValue.copyWith(file: file, isChanged: true);

      expect(copied.file, equals(file));
      expect(copied.url, equals(originalValue.url));
      expect(copied.isChanged, isTrue);
    });
  });
}
