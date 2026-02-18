class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'token': token,
    };
  }
}
