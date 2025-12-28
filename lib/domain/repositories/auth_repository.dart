import '../entity/user_registration_entity.dart';

abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> register(UserRegistrationEntity user);
  Future<void> logout(String refreshToken);
  Future<void> refreshToken(String refreshToken);
}
