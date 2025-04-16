import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_service_test.mocks.dart';

// Modèle pour les tests
class TestSettings implements AbstractModel {
  final String id;
  final int value;

  TestSettings({required this.id, required this.value});

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'value': value};
  }

  static TestSettings fromMap(Map<String, dynamic> map) {
    return TestSettings(id: map['id'] as String, value: map['value'] as int);
  }

  static TestSettings defaultSettings() {
    return TestSettings(id: 'default', value: 0);
  }

  @override
  copyWith({String? id, int? value}) {
    return TestSettings(id: id ?? this.id, value: value ?? this.value);
  }

  @override
  Map<String, dynamic> toDebugMap() {
    return {'id': id, 'value': value};
  }
}

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockPrefs;
  late SettingsService<TestSettings> settingsService;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    settingsService = SettingsService<TestSettings>(
      fromMap: TestSettings.fromMap,
      defaultSettings: TestSettings.defaultSettings,
    );

    // Utiliser la méthode d'injection de test au lieu d'accéder directement à _prefsInstance
    settingsService.setPrefsForTesting(mockPrefs);
  });

  group('SettingsService', () {
    test('Récupérer les paramètres depuis SharedPreferences', () async {
      // ARRANGE
      final expectedSettings = TestSettings(id: 'test', value: 42);
      final jsonString = jsonEncode(expectedSettings.toMap());

      when(mockPrefs.getString('app_settings')).thenReturn(jsonString);

      // ACT
      final result = await settingsService.getSettings();

      // ASSERT
      expect(result.id, equals(expectedSettings.id));
      expect(result.value, equals(expectedSettings.value));
      verify(mockPrefs.getString('app_settings')).called(1);
    });

    test(
      'Retourner les paramètres par défaut quand aucun paramètre n\'est enregistré',
      () async {
        // ARRANGE
        when(mockPrefs.getString('app_settings')).thenReturn(null);

        // ACT
        final result = await settingsService.getSettings();

        // ASSERT
        expect(result.id, equals('default'));
        expect(result.value, equals(0));
        verify(mockPrefs.getString('app_settings')).called(1);
      },
    );

    test('Sauvegarder les paramètres dans SharedPreferences', () async {
      // ARRANGE
      final settings = TestSettings(id: 'test', value: 42);
      when(
        mockPrefs.setString('app_settings', jsonEncode(settings.toMap())),
      ).thenAnswer((_) async => true);

      // ACT
      await settingsService.saveSettings(settings);

      // ASSERT
      verify(
        mockPrefs.setString('app_settings', jsonEncode(settings.toMap())),
      ).called(1);
    });

    test('Mettre à jour un paramètre spécifique', () async {
      // ARRANGE
      final initialSettings = TestSettings(id: 'initial', value: 10);
      when(
        mockPrefs.getString('app_settings'),
      ).thenReturn(jsonEncode(initialSettings.toMap()));

      when(
        mockPrefs.setString('app_settings', any),
      ).thenAnswer((_) async => true);

      // ACT
      final updatedSettings = await settingsService.updateSetting<String>(
        'updated',
        (settings, value) => TestSettings(id: value, value: settings.value),
      );

      // ASSERT
      expect(updatedSettings.id, equals('updated'));
      expect(updatedSettings.value, equals(10));
      verify(
        mockPrefs.setString(
          'app_settings',
          jsonEncode(updatedSettings.toMap()),
        ),
      ).called(1);
    });

    test('Ne pas sauvegarder quand les paramètres ne changent pas', () async {
      // ARRANGE
      final initialSettings = TestSettings(id: 'initial', value: 10);
      when(
        mockPrefs.getString('app_settings'),
      ).thenReturn(jsonEncode(initialSettings.toMap()));

      // ACT
      final updatedSettings = await settingsService.updateSetting<String>(
        'initial', // Même valeur qu'avant
        (settings, value) => TestSettings(id: value, value: settings.value),
      );

      // ASSERT
      expect(updatedSettings.id, equals('initial'));
      expect(updatedSettings.value, equals(10));
      verifyNever(mockPrefs.setString('app_settings', any));
    });

    test('Gérer les erreurs lors du chargement des paramètres', () async {
      // ARRANGE
      when(
        mockPrefs.getString('app_settings'),
      ).thenThrow(Exception('Erreur de test'));

      // ACT
      final result = await settingsService.getSettings();

      // ASSERT
      expect(result.id, equals('default'));
      expect(result.value, equals(0));
    });

    test('Gérer les erreurs lors de la sauvegarde des paramètres', () async {
      // ARRANGE
      final settings = TestSettings(id: 'test', value: 42);
      when(
        mockPrefs.setString('app_settings', any),
      ).thenThrow(Exception('Erreur de test'));

      // ACT & ASSERT
      // On s'attend à ce que l'erreur soit gérée à l'intérieur de la méthode
      await expectLater(settingsService.saveSettings(settings), completes);
    });
  });
}
