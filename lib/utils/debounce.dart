import 'dart:async';

/// Une classe qui permet de limiter la fréquence d'exécution d'une fonction.
///
/// Utile pour éviter des appels répétés rapides à une fonction coûteuse,
/// comme des requêtes API lors de la saisie utilisateur.
class Debouncer {
  /// Le timer qui contrôle le délai d'exécution
  Timer? _timer;

  /// Exécute la fonction [action] après un délai de [milliseconds].
  ///
  /// Si cette méthode est appelée à nouveau avant que le délai ne soit écoulé,
  /// le timer précédent est annulé et un nouveau délai est démarré.
  void run(Function action, {int milliseconds = 500}) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () => action());
  }

  /// Annule le timer s'il est en cours.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
