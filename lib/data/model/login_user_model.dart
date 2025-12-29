class LoginUserModel {
  final int id;
  final String username;
  final String email;

  LoginUserModel({required this.id, required this.username, required this.email});

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['user_id'],
      username: json['username'],
      email: json['email'],
    );
  }
}