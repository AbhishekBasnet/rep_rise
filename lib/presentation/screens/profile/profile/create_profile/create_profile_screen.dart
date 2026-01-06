import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/profile_setup_provider.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/pages/age_step_page.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/pages/gender_step_page.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/pages/goal_step_page.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/pages/height_step_page.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/pages/weight_step_page.dart';

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _topProgressBar(provider),
                _middlePageView(provider),
                _footerNavigationButtons(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _topProgressBar(ProfileSetupProvider provider) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 10, ),

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
              tween: Tween<double>(begin: 0, end: (provider.currentPage+1)/5),
              duration: Duration(milliseconds: 450),

              builder: (context, tweenAnimationValue,_)=> LinearProgressIndicator(
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

  Widget _middlePageView(ProfileSetupProvider provider) {
    return Expanded(
      child: PageView(
        controller: provider.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: provider.onPageChanged,
        children: const [AgeStepPage(), GenderStepPage(), HeightStepPage(), WeightStepPage(), GoalStepPage()],
      ),
    );
  }

  Widget _footerNavigationButtons(BuildContext context, ProfileSetupProvider provider) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                if (provider.isLastPage) {
                  debugPrint('    On last page, call trigger for api');
                } else {
                  provider.goToNextPage();
                  debugPrint('    continue button pressed: on page view index ${provider.currentPage}');
                }
              },
              child: Text(provider.isLastPage ? 'Finish' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
