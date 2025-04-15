import 'package:saasfork_core/saasfork_core.dart';

/// Configuration centralisée pour l'application
/// Inspirée du modèle nuxt.config.js
class SFConfig {
  static const String dev = "dev";
  static const String prod = "prod";
  // Stockage des configurations
  static final Map<String, dynamic> _config = {};
  static String _currentEnvironment = 'dev';

  /// Initialise la configuration avec les valeurs par défaut et .env
  static Future<void> initialize({
    Map<String, dynamic>? defaultConfig,
    String environment = 'dev',
  }) async {
    // Définir l'environnement courant
    _currentEnvironment = environment;

    // Initialiser avec les valeurs par défaut
    if (defaultConfig != null) {
      _config.addAll(defaultConfig);
    }

    log('SFConfig initialisé pour l\'environnement: $_currentEnvironment');
  }

  /// Accéder à une valeur de configuration
  static T? get<T>(String key, {T? defaultValue}) {
    if (_config.containsKey(key)) {
      final value = _config[key];

      // Conversion basique des types
      if (T == bool && value is String) {
        return (value.toLowerCase() == 'true') as T?;
      } else if (T == int && value is String) {
        return int.tryParse(value) as T?;
      } else if (T == double && value is String) {
        return double.tryParse(value) as T?;
      } else if (value is T) {
        return value;
      }
    }

    return defaultValue;
  }

  /// Accéder à une section de configuration
  static Map<String, dynamic> getSection(String sectionPrefix) {
    final section = <String, dynamic>{};

    _config.forEach((key, value) {
      if (key.startsWith('$sectionPrefix.')) {
        final subKey = key.substring(sectionPrefix.length + 1);
        section[subKey] = value;
      }
    });

    return section;
  }

  /// Obtenir l'environnement courant
  static String get environment => _currentEnvironment;

  /// Vérifier si nous sommes en environnement de développement
  static bool get isDevelopment => _currentEnvironment == 'dev';

  /// Vérifier si nous sommes en environnement de production
  static bool get isProduction => _currentEnvironment == 'prod';
}
