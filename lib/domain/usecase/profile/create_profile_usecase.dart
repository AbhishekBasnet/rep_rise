import 'package:rep_rise/domain/entity/profile/register_user_profile_data_entity.dart';
import 'package:rep_rise/domain/repositories/profile_repository.dart';


class CreateProfileUseCase {
  final ProfileRepository profileRepository;

  CreateProfileUseCase(this.profileRepository);

  Future<void> execute(RegisterUserProfileEntity profile) async {
    return await profileRepository.createProfile(profile);
  }
}