import 'package:rep_rise/data/model/user_registration_model.dart';


abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> register(UserRegistrationModel user);
  Future<void> logout(String refreshToken);
  Future<void> refreshToken(String refreshToken);
}
