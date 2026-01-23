import '../../entity/profile/user_profile_entity.dart';
import '../../repositories/profile/user_profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository profileRepository;

  GetUserProfileUseCase({required this.profileRepository});

  Future<UserProfileEntity> execute() {
    return profileRepository.getUserProfile();
  }
}
