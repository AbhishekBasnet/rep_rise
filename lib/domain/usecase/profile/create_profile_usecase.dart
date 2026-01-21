import 'package:rep_rise/domain/entity/profile/register_user_profile_data_entity.dart';
import 'package:rep_rise/domain/repositories/profile/register_profile_repository.dart';

class CreateProfileUseCase {
  final RegisterProfileRepository profileRepository;

  CreateProfileUseCase({required this.profileRepository});

  Future<void> execute(RegisterUserProfileEntity registerProfile) async {
    return await profileRepository.createProfile(registerProfile);
  }
}
