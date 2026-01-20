class AuthResponseModel {
  final String access;
  final String refresh;
  final String userId;

  AuthResponseModel({required this.access, required this.refresh, required this.userId});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      access: json['access'],
      refresh: json['refresh'],
      userId: json['user_id'],
    );
  }
}