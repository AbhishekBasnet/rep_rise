import '../entity/profile/user_profile_data_entity.dart';

abstract class ProfileRepository {
  Future<void> createProfile(UserProfileEntity profile);
} 