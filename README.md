# SaasFork Core - Middleware Manager

Un système de middleware flexible et extensible pour la gestion de la navigation dans les applications Flutter développées avec SaasFork.

## Qu'est-ce qu'un Middleware?

Dans SaasFork, un middleware de navigation est une fonction qui intercepte et traite les requêtes de navigation avant leur exécution. Ils permettent de :

- Vérifier l'authentification des utilisateurs
- Contrôler les accès aux routes protégées
- Rediriger vers d'autres pages si nécessaire
- Journaliser les changements de route
- Et d'autres traitements personnalisés

## Architecture du système de Middleware

### 1. L'interface NavigationState

Cette abstraction permet aux middlewares de fonctionner indépendamment du routeur utilisé :

```dart
abstract class NavigationState {
  String get path;
  Map<String, String> get params;
  Map<String, String> get queryParams;
  Map<String, dynamic> get extra;
}
```

### 2. Définition d'un Middleware

Un middleware est défini comme une fonction qui peut rediriger la navigation :

```dart
typedef GenericRouterMiddleware =
    FutureOr<String?> Function(BuildContext? context, NavigationState state);
```

- Retourne `null` pour poursuivre la navigation normalement
- Retourne un `String` contenant le chemin de redirection si nécessaire

## Utilisation pratique avec Go Router

### 1. Créer un adaptateur pour votre routeur

```dart
class GoRouterStateAdapter implements NavigationState {
  final GoRouterState _state;
  
  GoRouterStateAdapter(this._state);
  
  @override
  String get path => _state.matchedLocation;
  
  @override
  Map<String, String> get params => _state.pathParameters;
  
  @override
  Map<String, String> get queryParams => _state.queryParameters;
  
  @override
  Map<String, dynamic> get extra => {
        if (_state.extra != null) 'extra': _state.extra,
        'name': _state.name,
        'fullpath': _state.fullPath,
      };
}
```

### 2. Définir vos middlewares

Exemple de middleware d'authentification :

```dart
Future<String?> authMiddleware(
  BuildContext? context,
  NavigationState state,
) async {
  // Vérifier si l'utilisateur est connecté
  final isLoggedIn = authProvider.autState != null;

  // Rediriger vers la page de connexion si non connecté
  if (!isLoggedIn && state.path != '/login') return '/login';
  
  // Rediriger vers la page d'accueil si déjà connecté et sur la page login
  if (isLoggedIn && state.path == '/login') return '/';

  // Pas de redirection nécessaire
  return null;
}
```

### 3. Intégrer à votre routeur

```dart
GoRouter router = GoRouter(
  initialLocation: isLoggedIn ? '/' : '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginView()),
    GoRoute(path: '/', builder: (context, state) => HomeView()),
  ],
  redirect: (context, state) async {
    // Adapter l'état de GoRouter pour notre système
    final navigationState = GoRouterStateAdapter(state);
    
    // Liste des middlewares à appliquer
    final routeMiddlewares = [authMiddleware];
    
    // Exécuter les middlewares et obtenir une éventuelle redirection
    return await MiddlewareManager.run(
      context,
      navigationState,
      routeMiddlewares,
    );
  },
);
```

## Exemples supplémentaires

### Middleware de journalisation

```dart
FutureOr<String?> loggingMiddleware(BuildContext? context, NavigationState state) {
  print('Navigation vers: ${state.path}');
  return null; // Pas de redirection
}
```

### Middleware de contrôle d'accès aux fonctionnalités

```dart
FutureOr<String?> featureFlagMiddleware(BuildContext? context, NavigationState state) async {
  // Exemple : si la route commence par '/premium'
  if (state.path.startsWith('/premium')) {
    // Vérifier si l'utilisateur a un abonnement premium
    final hasPremium = await subscriptionService.hasPremiumAccess();
    
    if (!hasPremium) {
      // Rediriger vers la page d'abonnement
      return '/subscribe';
    }
  }
  
  return null; // Autoriser la navigation
}
```

## Bonnes pratiques

1. **Simplicité** : Gardez vos middlewares simples et concentrés sur une seule tâche.
   
2. **Ordre d'exécution** : Les middlewares sont exécutés dans l'ordre où ils sont déclarés dans la liste. Placez les plus critiques en premier.

3. **Performance** : Évitez les opérations coûteuses dans les middlewares.

4. **Tests** : Créez des tests unitaires pour chaque middleware.

## Pour les tests

Pour réinitialiser les middlewares entre les tests :

```dart
void setUp() {
  MiddlewareManager.resetGlobalMiddlewares();
}
