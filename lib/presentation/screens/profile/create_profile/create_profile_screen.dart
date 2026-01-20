import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/domain/entity/profile/register_user_profile_data_entity.dart';
import 'package:rep_rise/domain/entity/auth/user_registration_entity.dart';
import 'package:rep_rise/presentation/provider/auth/auth_provider.dart';
import 'package:rep_rise/presentation/provider/profile/register_profile_provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/pages/age_step_page.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/pages/gender_step_page.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/pages/goal_step_page.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/pages/height_step_page.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/pages/weight_step_page.dart';

class CreateProfileScreen extends StatelessWidget {
  final UserRegistrationEntity userRegistrationData;
  const CreateProfileScreen({super.key, required this.userRegistrationData});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _topProgressBar(provider),
                _middlePageView(provider),
                _footerNavigationButtons(context, provider, userRegistrationData),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _topProgressBar(RegisterProfileProvider provider) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Visibility(
              visible: provider.currentPage > 0,
              maintainAnimation: true,
              maintainState: true,
              maintainSize: true,
              child: IconButton(
                onPressed: () {
                  if (provider.currentPage > 0) {
                    provider.goToPreviousPage();
                  }
                },
                icon: const Icon(Icons.arrow_back),
                tooltip: "Go Back",
              ),
            ),
          ),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: (provider.currentPage + 1) / 5),
              duration: Duration(milliseconds: 450),

              builder: (context, tweenAnimationValue, _) => LinearProgressIndicator(
                value: tweenAnimationValue,
                backgroundColor: Colors.grey.shade300,
                color: Colors.blueAccent,
                minHeight: 12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 30), child: Text('${provider.currentPage + 1}/5')),
        ],
      ),
    );
  }

  Widget _middlePageView(RegisterProfileProvider provider) {
    return Expanded(
      child: PageView(
        controller: provider.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: provider.onPageChanged,
        children: const [AgeStepPage(), GenderStepPage(), HeightStepPage(), WeightStepPage(), GoalStepPage()],
      ),
    );
  }

  Widget _footerNavigationButtons(
    BuildContext context,
    RegisterProfileProvider provider,
    UserRegistrationEntity userRegistrationSData,
  ) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => _submitUserData(context, provider),
              child: Text(provider.isLastPage ? 'Finish' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitUserData(BuildContext context, RegisterProfileProvider provider) async {
    if (provider.isLastPage) {
      debugPrint('    On last page, triggering FINAL API call...');

      final profileData = RegisterUserProfileEntity(
        age: provider.age,
        weight: provider.weight,
        height: provider.height,
        gender: provider.gender.name,
        stepGoal: provider.goalSteps,
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.registerAndSetupProfile(
        user: userRegistrationData,
        profile: profileData,
      );

      if (context.mounted) {
        if (success) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.errorMessage ?? "Setup failed")),
          );
        }
      }
    } else {
      provider.goToNextPage();
      debugPrint('    continue button pressed: on page view index ${provider.currentPage}');
    }
  }
}
