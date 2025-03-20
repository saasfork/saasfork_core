import 'package:flutter/material.dart';

/// An abstract class for state management that extends [ChangeNotifier].
///
/// This class serves as a base for implementing state management solutions
/// that need to notify listeners when state changes.
///
/// Example implementation:
/// ```dart
/// class CounterNotifier extends StateNotifier<int> {
///   // Initialize with a default value
///   CounterNotifier() {
///     setState(0);
///   }
///
///   void increment() {
///     setState((state ?? 0) + 1);
///   }
///
///   void decrement() {
///     setState((state ?? 0) - 1);
///   }
/// }
/// ```
///
/// Usage example:
/// ```dart
/// // Create an instance
/// final counter = CounterNotifier();
///
/// // Add a listener
/// counter.addListener(() {
///   print('Counter changed to ${counter.state}');
/// });
///
/// // Update state
/// counter.increment(); // Prints: Counter changed to 1
///
/// // Use with a provider
/// ChangeNotifierProvider(
///   create: (_) => CounterNotifier(),
///   child: Consumer<CounterNotifier>(
///     builder: (context, notifier, _) => Text('${notifier.state}'),
///   ),
/// );
/// ```
abstract class StateNotifier<T> extends ChangeNotifier {
  /// Internal state value that can be null.
  T? _state;

  /// Returns the current state value.
  T? get state => _state;

  /// Updates the state with a new value and notifies all listeners.
  ///
  /// This will trigger a rebuild of all widgets that depend on this notifier.
  void setState(T newState) {
    _state = newState;
    notifyListeners();
  }

  /// Modifies the state using a function that transforms the current state.
  ///
  /// This method does NOT notify listeners by default, allowing silent state updates.
  ///
  /// Example:
  /// ```dart
  /// class UserNotifier extends StateNotifier<User> {
  ///   void updateUserName(String newName) {
  ///     // Update user name without triggering a rebuild
  ///     mutateState((currentUser) => currentUser!.copyWith(name: newName));
  ///   }
  /// }
  /// ```
  void mutateState(T Function(T? currentState) mutator) {
    _state = mutator(_state);
    // N'émet pas de notification par défaut
  }

  /// Applies a mutation to the state and then notifies listeners.
  ///
  /// This combines mutateState and notifyChanges into one call for convenience.
  ///
  /// Example:
  /// ```dart
  /// class UserNotifier extends StateNotifier<User> {
  ///   void updateUserAndNotify(String newName) {
  ///     mutateStateAndNotify((currentUser) => currentUser!.copyWith(name: newName));
  ///   }
  /// }
  /// ```
  void mutateStateAndNotify(T Function(T? currentState) mutator) {
    mutateState(mutator);
    notifyListeners();
  }

  /// Forces notification to all listeners without changing the state.
  ///
  /// Useful after using mutateState when you want to control precisely when
  /// the UI should update.
  void notifyChanges() {
    notifyListeners();
  }

  /// Resets the state to null and notifies all listeners.
  ///
  /// This is useful for clearing the state, such as when logging out a user
  /// or resetting a form.
  ///
  /// Example:
  /// ```dart
  /// class AuthNotifier extends StateNotifier<AuthState> {
  ///   void logout() {
  ///     // Clear user data
  ///     resetState();
  ///     // Navigate to login screen
  ///   }
  /// }
  /// ```
  void resetState() {
    _state = null;
    notifyListeners();
  }
}
