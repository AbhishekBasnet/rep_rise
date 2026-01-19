import 'package:flutter/material.dart';
import 'package:rep_rise/domain/entity/profile/user_profile_entity.dart' show UserProfileEntity;
import 'package:rep_rise/domain/repositories/profile/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository profileRepository;

  ProfileProvider({required this.profileRepository});

  UserProfileEntity? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfileEntity? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userProfile = await profileRepository.getUserProfile();
    } catch (e) {
      _errorMessage = "Failed to load profile: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}