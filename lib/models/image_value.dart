import 'package:cross_file/cross_file.dart';

/// Représente une valeur d'image qui peut être un fichier local ou une URL distante.
/// Utilisée pour unifier la gestion des images dans les formulaires et les composants UI.
class ImageValue {
  /// Fichier local si disponible
  final XFile? file;

  /// URL distante si disponible
  final String? url;

  /// Indique si l'image a été modifiée (nouveau fichier sélectionné)
  final bool isChanged;

  const ImageValue({this.file, this.url, this.isChanged = false});

  /// Crée une instance à partir d'un fichier local
  factory ImageValue.fromFile(XFile file) {
    return ImageValue(file: file, isChanged: true);
  }

  /// Crée une instance à partir d'une URL distante
  factory ImageValue.fromUrl(String url) {
    return ImageValue(url: url, isChanged: false);
  }

  /// Crée une instance à partir d'une valeur dynamique (pour compatibilité avec JSON)
  factory ImageValue.fromDynamic(dynamic value) {
    if (value is XFile) {
      return ImageValue.fromFile(value);
    } else if (value is String && value.isNotEmpty) {
      // Valider si c'est une URL
      if (value.startsWith('http://') || value.startsWith('https://')) {
        return ImageValue.fromUrl(value);
      }
    } else if (value is ImageValue) {
      return value;
    }
    return const ImageValue();
  }

  /// Vérifie si l'image est valide (a soit un fichier, soit une URL)
  bool get isValid => file != null || (url != null && url!.isNotEmpty);

  /// Retourne la valeur à utiliser pour l'affichage/prévisualisation
  dynamic get displayValue => file ?? url;

  /// Convertit en chaîne pour le débogage
  @override
  String toString() {
    if (file != null) return 'File: ${file!.path}';
    if (url != null) return 'URL: $url';
    return 'No image';
  }

  /// Crée une copie avec des modifications optionnelles
  ImageValue copyWith({XFile? file, String? url, bool? isChanged}) {
    return ImageValue(
      file: file ?? this.file,
      url: url ?? this.url,
      isChanged: isChanged ?? this.isChanged,
    );
  }
}
