import 'package:saasfork_core/saasfork_core.dart';

class SFSEOModel implements AbstractModel<SFSEOModel> {
  final String title;
  final String? description;
  final List<String>? keywords;
  final String? imageUrl;
  final String? url;

  const SFSEOModel({
    required this.title,
    this.description,
    this.keywords = const [],
    this.imageUrl,
    this.url,
  });

  @override
  SFSEOModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? keywords,
    String? imageUrl,
    String? url,
  }) {
    return SFSEOModel(
      title: title ?? this.title,
      description: description ?? this.description,
      keywords: keywords ?? this.keywords,
      imageUrl: imageUrl ?? this.imageUrl,
      url: url ?? this.url,
    );
  }

  factory SFSEOModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return SFSEOModel(
      title: data['title'] as String,
      description: data['description'] as String?,
      keywords: List<String>.from(data['keywords'] ?? []),
      imageUrl: data['imageUrl'] as String?,
      url: data['url'] as String?,
    );
  }

  @override
  Map<String, dynamic> toDebugMap() {
    return toMap();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'keywords': keywords,
      'imageUrl': imageUrl,
      'url': url,
    };
  }
}
