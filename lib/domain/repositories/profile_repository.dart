import '../entity/profile/register_user_profile_data_entity.dart';

abstract class ProfileRepository {
  Future<void> createProfile(RegisterUserProfileEntity profile);
} 