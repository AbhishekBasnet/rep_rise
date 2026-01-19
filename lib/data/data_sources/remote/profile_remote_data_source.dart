import 'package:rep_rise/core/exception/api_exception.dart';
import 'package:rep_rise/core/network/api_client.dart';
import 'package:rep_rise/data/model/profile/user_profile_model.dart';

///
/// This class handles fetching user profile data from the server
/// via the provided [ApiClient].
class ProfileRemoteDataSource {
  final ApiClient client;

  ProfileRemoteDataSource({required this.client});

  /// Fetches the current user's profile details including physical stats and goals.
  ///
  /// Returns a [UserProfileModel] populated with the server response.
  ///
  /// Throws an [ApiException] if the network request fails or the response
  /// cannot be parsed.
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await client.get('user/me/');
      return UserProfileModel.fromJson(response.data);
    } catch (e) {
      throw ApiException(message: "   on profile remote data source: Failed to fetch user profile: $e");
    }
  }
}
