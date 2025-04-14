import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService<T extends AbstractModel> {
  static const String _settingsKey = 'app_settings';

  final T Function(Map<String, dynamic>) _fromMap;
  final T Function() _defaultSettings;

  final String settingsKey;

  SettingsService({
    required T Function(Map<String, dynamic>) fromMap,
    required T Function() defaultSettings,
    this.settingsKey = 'app_settings',
  }) : _fromMap = fromMap,
       _defaultSettings = defaultSettings;

  SharedPreferences? _prefsInstance;

  @visibleForTesting
  void setPrefsForTesting(SharedPreferences preferences) {
    _prefsInstance = preferences;
  }

  Future<SharedPreferences> _getPrefs() async {
    return _prefsInstance ??= await SharedPreferences.getInstance();
  }

  Future<T> getSettings() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(_settingsKey);

      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return _fromMap(json);
      }
    } catch (e) {
      error('Erreur lors du chargement des paramètres: $e');
    }

    return _defaultSettings();
  }

  Future<void> saveSettings(T settings) async {
    try {
      final prefs = await _getPrefs();
      final jsonString = jsonEncode(settings.toMap());
      await prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      error('Erreur lors de la sauvegarde des paramètres: $e');
    }
  }

  Future<T> updateSetting<V>(V value, T Function(T, V) updater) async {
    final settings = await getSettings();
    final newSettings = updater(settings, value);
    if (jsonEncode(settings.toMap()) != jsonEncode(newSettings.toMap())) {
      await saveSettings(newSettings);
    }
    return newSettings;
  }
}

Provider<SettingsService<S>> createSettingsServiceProvider<
  S extends AbstractModel
>(SettingsServiceConfig<S> config) {
  return Provider<SettingsService<S>>((ref) {
    return SettingsService<S>(
      fromMap: config.fromMap,
      defaultSettings: config.defaultSettings,
    );
  });
}

class SettingsServiceConfig<T extends AbstractModel> {
  final T Function(Map<String, dynamic>) fromMap;
  final T Function() defaultSettings;

  SettingsServiceConfig({required this.fromMap, required this.defaultSettings});
}
