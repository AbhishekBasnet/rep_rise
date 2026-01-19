import '../../entity/profile/register_user_profile_data_entity.dart';

abstract class RegisterProfileRepository {
  Future<void> createProfile(RegisterUserProfileEntity profile);
} 