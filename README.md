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

### 4. Système de configuration

Un système de configuration centralisé qui permet de gérer les paramètres de l'application et les variables d'environnement.

#### Initialisation

```dart
import 'package:saasfork_core/saasfork_core.dart';

await SFConfig.initialize(
  envFilePath: '.env', // Chemin vers votre fichier .env
  defaultConfig: {
    'app.name': 'Mon Application',
    'app.version': '1.0.0',
    'api.url': 'https://api.example.com',
  },
  environment: 'dev', // ou 'prod', 'staging', etc.
);
```

#### Accès aux valeurs de configuration

```dart
// Accès à une valeur avec type spécifié et valeur par défaut
final appName = SFConfig.get<String>('app.name', defaultValue: 'Application');
final debugMode = SFConfig.get<bool>('app.debug', defaultValue: false);
final apiTimeout = SFConfig.get<int>('api.timeout', defaultValue: 30);

// Vérification de l'environnement courant
if (SFConfig.isDevelopment) {
  // Code spécifique à l'environnement de développement
}

if (SFConfig.isProduction) {
  // Code spécifique à l'environnement de production
}

// Obtenir l'environnement actuel
final env = SFConfig.environment; // 'dev', 'prod', etc.
```

#### Accès à une section de configuration

```dart
// Récupérer toutes les configurations commençant par 'api.'
final apiConfig = SFConfig.getSection('api');
// Résultat: { 'url': 'https://api.example.com', 'timeout': 30, ... }

// Utilisation
final apiUrl = apiConfig['url'] as String;
```

#### Intégration avec fichier .env

SFConfig se base sur flutter_dotenv pour charger les variables d'environnement à partir d'un fichier .env:

```
# Exemple de fichier .env
APP_NAME=Mon Application
APP_VERSION=1.0.0
API_URL=https://api.exemple.com
DEBUG_MODE=true
```

Ces variables seront disponibles via SFConfig, avec conversion automatique des types pour les booléens, entiers et nombres à virgule flottante.

#### Exemple pratique avec AppConfig

Créez une classe wrapper pour centraliser la configuration de votre application:

```dart
class AppConfig {
  static T? get<T>(String key, {T? defaultValue}) {
    return SFConfig.get<T>(key, defaultValue: defaultValue);
  }

  static Map<String, dynamic> getDefaultConfig() {
    return {'app.name': 'Clink2Pay', 'app.version': '1.0.0'};
  }

  static Future<void> initialize({String environment = 'dev'}) async {
    final defaultConfig = getDefaultConfig();

    if (defaultConfig.containsKey(environment)) {
      final envSpecificConfig =
          defaultConfig[environment] as Map<String, dynamic>;

      // Remplacer les valeurs par défaut
      defaultConfig.addAll(envSpecificConfig);

      // Supprimer la section d'environnement après fusion
      defaultConfig.remove(environment);
      defaultConfig.remove('dev');
      defaultConfig.remove('prod');
    }

    await SFConfig.initialize(
      envFilePath: '.env',
      defaultConfig: defaultConfig,
      environment: environment,
    );
  }
}
```

Utilisation dans votre application:

```dart
// Initialiser au démarrage de l'application
await AppConfig.initialize(environment: 'prod');

// Accéder aux valeurs de configuration
final appName = AppConfig.get<String>('app.name');
final isDebug = AppConfig.get<bool>('app.debug', defaultValue: false);
```

## Web Functions Utilities

The `web_functions.dart` utility provides a set of helper functions for web-specific operations.

### getLocalhostUrl()

Retrieves the current URL (protocol, hostname, and port) in a web environment.

```dart
String url = getLocalhostUrl();
```