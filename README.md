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

Modèle complet pour représenter un utilisateur :

```dart
final user = UserModel(
  uid: 'user123',
  email: 'user@example.com',
  username: 'johndoe',
  claims: UserClaims(role: Roles.admin)
);

// Conversion vers/depuis JSON
final json = user.toJson();
final userFromJson = UserModel.fromJson(json);
```

#### UserClaims et gestion des rôles

```dart
// Rôles disponibles
enum Roles { visitor, user, admin, moderator }

// Création et manipulation
final claims = UserClaims(role: Roles.user);
final adminClaims = claims.copyWith(role: Roles.admin);
```

## Bonnes pratiques

1. **Journalisation** : Utilisez les différents niveaux de log de manière cohérente
   - `info` pour le suivi normal des opérations
   - `warn` pour les situations anormales mais non critiques
   - `error` pour les véritables erreurs nécessitant une attention

2. **Structure des modèles** : Assurez-vous que vos modèles implémentent les méthodes de sérialisation et d'équivalence (`==`, `hashCode`)

3. **Performance** : Évitez les logs trop fréquents dans les sections critiques de votre application
