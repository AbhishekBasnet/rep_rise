import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rep_rise/core/network/api_client.dart';
import 'package:rep_rise/data/model/user_profile_model.dart';

class StepRemoteDataSource {
  final ApiClient apiClient;
  StepRemoteDataSource({required this.apiClient});
  Future<void> postSteps(UserProfileModel userProfileModel) async {
    try{
      await apiClient.patch(
        'user/profile/',
        data: userProfileModel.toJson(),
      );
      debugPrint("    --- Data Source: Profile Created Successfully ---");
    } on DioException catch (e) {
      throw Exception("Failed to create profile: ${e.message}");
    }
  }
}
