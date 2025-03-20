import 'package:flutter/foundation.dart';

/// Classe utilitaire pour faciliter la journalisation
///
/// Permet de journaliser des messages avec différents niveaux de priorité
/// et éventuellement de les envoyer à des services externes.
class Logger {
  /// Journalise un message de niveau INFO
  ///
  /// [message] Le message à journaliser
  /// [tag] Tag optionnel pour catégoriser le message
  static void info(String message, {String? tag}) {
    _log('INFO', message, tag: tag);
  }

  /// Journalise un message de niveau WARNING
  ///
  /// [message] Le message à journaliser
  /// [tag] Tag optionnel pour catégoriser le message
  static void warn(String message, {String? tag}) {
    _log('WARNING', message, tag: tag);
  }

  /// Journalise un message de niveau ERROR avec les détails de l'erreur
  ///
  /// [message] Le message décrivant l'erreur
  /// [error] L'objet d'erreur optionnel
  /// [stackTrace] La trace d'appels optionnelle
  /// [tag] Tag optionnel pour catégoriser le message
  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _log('ERROR', message, error: error, stackTrace: stackTrace, tag: tag);
  }

  /// Méthode interne pour formater et afficher les messages de log
  ///
  /// Cette méthode gère le formatage standard des logs avec horodatage,
  /// niveau de priorité et catégorie. Elle imprime les détails des erreurs
  /// et les traces d'appel lorsqu'ils sont disponibles.
  ///
  /// [level] Niveau de journalisation (INFO, WARNING, ERROR)
  /// [message] Le message à journaliser
  /// [error] L'objet d'erreur optionnel pour fournir des détails supplémentaires
  /// [stackTrace] La trace d'appels optionnelle pour faciliter le débogage
  /// [tag] Tag optionnel pour catégoriser le message
  static void _log(
    String level,
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    final now = DateTime.now();
    final prefix = '[$now] [$level] ${tag != null ? '[$tag] ' : ''}';

    debugPrint('$prefix$message');

    if (error != null) {
      debugPrint('$prefix Error details: $error');
    }

    if (stackTrace != null) {
      debugPrint('$prefix Stack trace:\n$stackTrace');
    }

    // TODO: Ici vous pourriez ajouter l'envoi à un service de journalisation distant
    // comme Firebase Crashlytics, Sentry ou LogRocket pour les applications en production.
  }
}

/// Fonction raccourci pour journaliser un message de niveau INFO
///
/// Permet d'utiliser `log()` au lieu de `Logger.info()` pour plus de concision.
///
/// [message] Le message à journaliser
/// [tag] Tag optionnel pour catégoriser le message
void log(String message, {String? tag}) {
  Logger.info(message, tag: tag);
}

/// Fonction raccourci pour journaliser un message de niveau WARNING
///
/// Permet d'utiliser `warn()` au lieu de `Logger.warn()` pour plus de concision.
///
/// [message] Le message à journaliser
/// [tag] Tag optionnel pour catégoriser le message
void warn(String message, {String? tag}) {
  Logger.warn(message, tag: tag);
}

/// Fonction raccourci pour journaliser un message de niveau ERROR
///
/// Permet d'utiliser `error()` au lieu de `Logger.error()` pour plus de concision.
///
/// [message] Le message décrivant l'erreur
/// [error] L'objet d'erreur optionnel
/// [stackTrace] La trace d'appels optionnelle
/// [tag] Tag optionnel pour catégoriser le message
void error(
  String message, {
  dynamic error,
  StackTrace? stackTrace,
  String? tag,
}) {
  Logger.error(message, error: error, stackTrace: stackTrace, tag: tag);
}
