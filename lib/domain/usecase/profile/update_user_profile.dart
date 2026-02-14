import '../../repositories/profile/user_profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository profileRepository;

  UpdateUserProfileUseCase({required this.profileRepository});

  Future<void> execute(Map<String, dynamic> updateData) {
    return profileRepository.updateUserProfile(updateData);
  }
}