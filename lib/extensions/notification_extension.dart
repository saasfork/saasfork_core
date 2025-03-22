import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification.dart';

/// Extension qui permet d'afficher facilement des notifications
/// depuis n'importe quel contexte avec le système de notifications Riverpod
extension NotificationRiverpodExtension on BuildContext {
  /// Affiche une notification d'erreur
  ///
  /// ```dart
  /// context.showErrorMessage(
  ///   title: 'Échec',
  ///   message: 'Impossible de se connecter au serveur'
  /// );
  /// ```
  void showErrorMessage({
    String? title,
    required String message,
    WidgetRef? ref,
  }) {
    _getNotifier(ref)?.showError(message, title: title);
  }

  /// Affiche une notification de succès
  ///
  /// ```dart
  /// context.showSuccessMessage(
  ///   title: 'Enregistré',
  ///   message: 'Vos modifications ont été enregistrées'
  /// );
  /// ```
  void showSuccessMessage({
    String? title,
    required String message,
    WidgetRef? ref,
  }) {
    _getNotifier(ref)?.showSuccess(message, title: title);
  }

  /// Affiche une notification d'information
  ///
  /// ```dart
  /// context.showInfoMessage(
  ///   message: 'Une mise à jour est disponible'
  /// );
  /// ```
  void showInfoMessage({
    String? title,
    required String message,
    WidgetRef? ref,
  }) {
    _getNotifier(ref)?.showInfo(message, title: title);
  }

  /// Affiche une notification d'avertissement
  ///
  /// ```dart
  /// context.showWarningMessage(
  ///   title: 'Attention',
  ///   message: 'Votre abonnement expire bientôt'
  /// );
  /// ```
  void showWarningMessage({
    String? title,
    required String message,
    WidgetRef? ref,
  }) {
    _getNotifier(ref)?.showWarning(message, title: title);
  }

  /// Récupère le notifier de notification
  NotificationNotifier? _getNotifier(WidgetRef? ref) {
    if (ref == null) {
      try {
        // Essayer d'obtenir le WidgetRef via le ProviderScope
        final providerContainer = ProviderScope.containerOf(
          this,
          listen: false,
        );
        return providerContainer.read(notificationProvider.notifier);
      } catch (e) {
        debugPrint('Impossible d\'accéder au notificationProvider: $e');
        return null;
      }
    }
    return ref.read(notificationProvider.notifier);
  }
}
