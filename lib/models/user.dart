class User {
  final String email;
  final String password;
  final int? adminId;

  User({required this.email, required this.password, this.adminId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'] ?? '', // password may not be returned from backend
      adminId: json['admin_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (adminId != null) 'admin_id': adminId,
    };
  }
}
