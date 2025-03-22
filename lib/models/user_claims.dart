enum Roles { visitor, user, admin, moderator }

class UserClaims {
  Roles role;

  UserClaims({required this.role});

  UserClaims copyWith({Roles? role}) {
    return UserClaims(role: role ?? this.role);
  }

  Map<String, dynamic> toJson() {
    return {'role': role.toString().split('.').last};
  }

  factory UserClaims.fromJson(Map<String, dynamic> json) {
    assert(json['role'] != null, 'Role must not be null');

    return UserClaims(
      role: Roles.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => Roles.visitor,
      ),
    );
  }

  @override
  String toString() => 'UserClaims(role: $role)';
}
