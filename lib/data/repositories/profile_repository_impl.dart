import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rep_rise/core/network/api_client.dart';
import 'package:rep_rise/data/model/user_profile_model.dart';
import 'package:rep_rise/domain/entity/profile/user_profile_data_entity.dart';
import 'package:rep_rise/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient apiClient;

  ProfileRepositoryImpl(this.apiClient);

  /*
 * FLOW: Profile Creation Process
 * -----------------------------------------------------------------------------
 * This method orchestrates the creation/update of a user profile by coordinating
 * data transformation and network transport.
 *
 * 1. Data Transformation (Entity -> Model):
 * The method accepts a raw domain entity ([UserProfileEntity]). It immediately
 * converts this into a Data Transfer Object ([UserProfileModel]) using the
 * `.fromEntity()` factory. This ensures the Domain layer remains decoupled
 * from JSON serialization logic.
 *
 * 2. API Interaction:
 * A PATCH request is issued to the endpoint `user/profile/` using the [ApiClient].
 * The model is serialized to JSON (`.toJson()`) for the request body.
 *
 * 3. Error Handling & Parsing:
 * The network call is wrapped in a try-catch block specifically targeting
 * [DioException]. If the API returns an error (e.g., 400 Bad Request):
 * - It inspects the `response.data`.
 * - It attempts to extract a specific user-facing message (checking keys like 'detail').
 * - If no specific key is found, it falls back to the first available value.
 * - Finally, it re-throws a clean [Exception] to be consumed by the UI/Domain.
 */

  /// Creates or updates the user's profile on the remote server.
  ///
  /// This method performs a `PATCH` request to partial-update the profile resource.
  ///
  /// - [profileEntity]: The domain entity containing the user's profile data (age, weight, etc.).
  ///
  /// Throws an [Exception] containing the specific error message from the server
  /// if the request fails (e.g., validation errors)
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
