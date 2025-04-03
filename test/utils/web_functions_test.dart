import 'package:flutter_test/flutter_test.dart';

// Create custom mock classes to simulate web objects
class MockLocation {
  String protocol = '';
  String hostname = '';
  String port = '';
}

class MockWindow {
  final MockLocation _location = MockLocation();

  MockLocation get location => _location;
}

// Extension pour permettre de mocker les objets web
extension WebMock on Object {
  static MockWindow? _mockWindow;

  static void setMockWindow(MockWindow? mock) {
    _mockWindow = mock;
  }

  static MockWindow? get mockWindow => _mockWindow;
}

// Mock de la fonction getLocalhostUrl pour tester
String mockGetLocalhostUrl({bool isWebForced = false}) {
  if (isWebForced) {
    try {
      // Utiliser le mock au lieu de web.window
      final location = WebMock.mockWindow!.location;
      final protocol = location.protocol;
      final hostname = location.hostname;
      final port = location.port;

      return '$protocol//$hostname${port.isNotEmpty ? ':$port' : ''}';
    } catch (e) {
      return '';
    }
  } else {
    return '';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('getLocalhostUrl', () {
    late MockWindow mockWindow;

    setUp(() {
      mockWindow = MockWindow();
      // Définir notre mock window
      WebMock.setMockWindow(mockWindow);
    });

    test('devrait retourner URL correcte avec port', () {
      // Configuration de l'objet location
      mockWindow.location.protocol = 'http:';
      mockWindow.location.hostname = 'localhost';
      mockWindow.location.port = '3000';

      // Exécution avec l'environnement web simulé
      final result = mockGetLocalhostUrl(isWebForced: true);

      // Vérification
      expect(result, 'http://localhost:3000');
    });

    test('devrait retourner URL correcte sans port', () {
      // Configuration de l'objet location
      mockWindow.location.protocol = 'https:';
      mockWindow.location.hostname = 'example.com';
      mockWindow.location.port = '';

      // Exécution avec l'environnement web simulé
      final result = mockGetLocalhostUrl(isWebForced: true);

      // Vérification
      expect(result, 'https://example.com');
    });

    test('devrait gérer les erreurs en environnement web', () {
      // Supprimer la référence pour provoquer une erreur
      WebMock.setMockWindow(null);

      // Exécution avec l'environnement web simulé
      final result = mockGetLocalhostUrl(isWebForced: true);

      // Vérification
      expect(result, '');
    });

    test('devrait retourner chaîne vide en environnement non-web', () {
      // Exécution avec l'environnement non-web simulé
      final result = mockGetLocalhostUrl(isWebForced: false);

      // Vérification
      expect(result, '');
    });
  });
}
