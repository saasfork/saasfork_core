import 'dart:convert';

import 'package:saasfork_core/saasfork_core.dart';

class UserModel {
  String? uid;
  String? email;
  String? username;

  UserClaims? claims;

  UserModel({this.uid, this.email, this.username, this.claims});

  bool get isEmpty => uid == null && email == null && username == null;

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    UserClaims? claims,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      claims: claims ?? this.claims,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': username,
      'claims': claims,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      claims: map['claims'] != null ? map['claims'] as UserClaims : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserModel(uid: $uid, username: $username, email: $email, claims: ${claims.toString()})';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.username == username &&
        other.email == email &&
        other.claims == claims;
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      username.hashCode ^
      email.hashCode ^
      (claims?.hashCode ?? 0);
}
