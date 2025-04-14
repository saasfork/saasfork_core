abstract class AbstractModel<T> {
  Map<String, dynamic> toMap();

   Map<String, dynamic> toDebugMap();

  factory AbstractModel.fromMap(Map<String, dynamic> data, {String? id}) {
    throw UnimplementedError(
      'AbstractModel.fromMap() has not been implemented.',
    );
  }

  T copyWith({String? id});
}
