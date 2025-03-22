# SaasFork Core

Bibliothèque centrale pour les applications développées avec SaasFork. Cette bibliothèque fournit des outils, utilitaires et modèles réutilisables dans tous vos projets.

## Fonctionnalités principales

### 1. Système de journalisation (Logger)

Un système de journalisation unifié et configurable pour faciliter le débogage et le suivi d'événements.

#### Utilisation basique

```dart
import 'package:saasfork_core/saasfork_core.dart';

// Messages informatifs
log('Application démarrée');
Logger.info('Configuration chargée', tag: 'CONFIG');

// Avertissements
warn('Tentative de reconnexion', tag: 'NETWORK');
Logger.warn('Cache expiré');

// Erreurs
error('Échec de la synchronisation', 
      error: e, 
      stackTrace: stackTrace, 
      tag: 'SYNC');
```

#### Fonctionnalités du Logger

- Formatage automatique avec horodatage et niveau de priorité
- Catégorisation par tags
- Support complet des erreurs et stack traces
- Prêt à être connecté à des services distants comme Sentry ou Firebase Crashlytics

### 2. Modèles de données

Des modèles pour les entités communes dans les applications SaaS, avec sérialisation/désérialisation intégrée.

#### UserModel

Modèle pour représenter un utilisateur dans l'application :

```dart
final user = UserModel(
  uid: 'user123',
  email: 'user@example.com',
  username: 'johndoe',
  claims: UserClaims(role: Roles.admin)
);

// Vérifier si l'utilisateur est vide
if (user.isEmpty) {
  // Traitement pour utilisateur non initialisé
}

// Création d'une copie modifiée
final updatedUser = user.copyWith(username: 'newusername');

// Conversion vers/depuis JSON
final json = user.toJson();
final userFromJson = UserModel.fromJson(json);

// Conversion vers/depuis Map
final map = user.toMap();
final userFromMap = UserModel.fromMap(map);
```

#### UserClaims et gestion des rôles

Gestion des droits et rôles utilisateur :

```dart
// Rôles disponibles
enum Roles { visitor, user, admin, moderator }

// Création des claims
final claims = UserClaims(role: Roles.user);

// Modification des claims
final adminClaims = claims.copyWith(role: Roles.admin);

// Sérialisation/désérialisation
final jsonMap = claims.toJson(); // Retourne un Map<String, dynamic>
final claimsFromJson = UserClaims.fromJson(jsonMap);
```

### 3. Système de notification

Un système complet pour afficher des notifications à l'utilisateur, intégré avec Riverpod.

#### Types de notifications

```dart
enum NotificationType { error, success, info, warning }
```

#### Utilisation basique

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';

// Dans un widget ConsumerWidget ou ConsumerStatefulWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accéder au contrôleur de notification
    final notifier = ref.read(notificationProvider.notifier);
    
    // Afficher différents types de notifications
    notifier.showSuccess('Opération réussie', title: 'Bravo');
    notifier.showError('Une erreur s\'est produite');
    notifier.showInfo('Information importante');
    notifier.showWarning('Attention', title: 'Avertissement');
    
    // Écouter l'état des notifications
    final notification = ref.watch(notificationProvider);
    if (notification.hasNotification) {
      // Traiter la notification (par exemple, afficher un toast ou une snackbar)
      
      // Effacer la notification après traitement
      notifier.clear();
    }
    
    return Container();
  }
}
```

#### Fonctionnalités du système de notification

- Quatre types de notifications : erreur, succès, info, avertissement
- Prise en charge des titres et messages
- État géré par Riverpod pour une intégration facile dans l'architecture de l'application
- Méthode `clear()` pour effacer les notifications après traitement

## Bonnes pratiques

1. **Journalisation** : Utilisez les différents niveaux de log de manière cohérente
   - `info` pour le suivi normal des opérations
   - `warn` pour les situations anormales mais non critiques
   - `error` pour les véritables erreurs nécessitant une attention

2. **Structure des modèles** : Tous nos modèles implémentent :
   - Méthodes de sérialisation (`toMap()`, `toJson()`)
   - Méthodes de désérialisation (`fromMap()`, `fromJson()`)
   - Opérateurs d'équivalence (`==`, `hashCode`)
   - Méthode `copyWith()` pour manipulation immuable
   - Méthode `toString()` pour faciliter le débogage

3. **Performance** : Évitez les logs trop fréquents dans les sections critiques de votre application
