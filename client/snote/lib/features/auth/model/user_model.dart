class UserModel {
  String id;
  String username;
  String email;
  String tokenKey;
  String refreshTokenKey;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.tokenKey,
    required this.refreshTokenKey,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        tokenKey = json['tokenKey'],
        refreshTokenKey = json['refreshTokenKey'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': tokenKey,
      'refreshTokenKey': refreshTokenKey,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? tokenKey,
    String? refreshTokenKey,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      tokenKey: tokenKey ?? this.tokenKey,
      refreshTokenKey: refreshTokenKey ?? this.refreshTokenKey,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, tokenKey: $tokenKey, refreshTokenKey: $refreshTokenKey)';
  }
}
