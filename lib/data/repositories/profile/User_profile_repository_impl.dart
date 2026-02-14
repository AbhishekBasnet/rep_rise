import 'package:rep_rise/data/data_sources/remote/profile/profile_remote_data_source.dart';

import '../../../domain/entity/profile/user_profile_entity.dart';
import '../../../domain/repositories/profile/user_profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfileEntity> getUserProfile() async {
    try {
      final userProfileModel = await remoteDataSource.getUserProfile();
      return userProfileModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(Map<String, dynamic> updateData) async {
    try {
      await remoteDataSource.updateUserProfile(updateData);
    } catch (e) {
      rethrow;
    }
  }
}
