
import 'package:rep_rise/domain/entity/profile/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getUserProfile();
  Future<void> updateUserProfile(Map<String, dynamic> updateData);
}