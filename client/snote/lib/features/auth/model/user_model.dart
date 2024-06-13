class UserModel {
  String id;
  String username;
  String email;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  UserModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      username = json['username'],
      email = json['email'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email)';
  }
}
