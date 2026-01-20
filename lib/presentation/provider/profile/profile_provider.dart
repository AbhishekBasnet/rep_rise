import 'package:flutter/material.dart';
import 'package:rep_rise/domain/entity/profile/user_profile_entity.dart' show UserProfileEntity;
import 'package:rep_rise/domain/repositories/profile/profile_repository.dart';
import 'package:rep_rise/domain/usecase/profile/get_user_profile_usecase.dart';

import '../../../domain/entity/profile/user_profile_entity.dart';

class ProfileProvider extends ChangeNotifier {
  final GetUserProfileUseCase getUserProfileUseCase;

  ProfileProvider({ required this.getUserProfileUseCase});

  UserProfileEntity? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _userProfile != null;

  String get username => _userProfile?.username ?? "User";
  String get email => _userProfile?.email ?? "";

  double get height => _userProfile?.height ?? 0.0;
  double get weight => _userProfile?.weight ?? 0.0;
  int get age => _userProfile?.age ?? 0;
  String get gender => _userProfile?.gender ?? "Not specified";

  int get dailyStepGoal => _userProfile?.dailyStepGoal ?? 0;
  double get bmi => _userProfile?.bmi ?? 0.0;

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userProfile = await  getUserProfileUseCase.execute();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
