import 'package:rep_rise/domain/entity/authentication/user_registration_entity.dart';


abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> register(UserRegistrationEntity user);
  Future<bool> checkUsername(String userName);
  Future<void> logout();
  Future<void> refreshToken(String refreshToken);
}
