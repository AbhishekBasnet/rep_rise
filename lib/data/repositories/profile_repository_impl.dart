import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rep_rise/core/network/api_client.dart';
import 'package:rep_rise/data/model/user_profile_model.dart';
import 'package:rep_rise/domain/entity/user_profile_data_entity.dart';
import 'package:rep_rise/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient apiClient;

  ProfileRepositoryImpl(this.apiClient);

  @override
  Future<void> createProfile(UserProfileEntity profileEntity) async {
    try {
      final profileModel = UserProfileModel.fromEntity(profileEntity);

      await apiClient.patch('user/profile/', data: profileModel.toJson());

      debugPrint('    --- PROFILE CREATION SUCCESS ---');
      debugPrint('    ${profileModel.toString()}');

    } on DioException catch (e) {
      debugPrint('    --- PROFILE CREATION ERROR ---');

      String errorMessage = "Failed to create profile";

      if (e.response?.data != null) {
        final data = e.response!.data;

        if (data is Map<String, dynamic>) {
          if (data.containsKey('detail')) {
            errorMessage = data['detail'];
          } else {
            errorMessage = data.values.first.toString();
          }
        }
      }

      throw Exception(errorMessage);
    }
  }
}
