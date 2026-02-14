import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/user_profile_provider.dart';
import 'package:rep_rise/presentation/provider/step/step_provider.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/ai_workout_card.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/daily_summary_card.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/user_header_card.dart';
import 'package:rep_rise/presentation/screens/profile/edit_profile_screen.dart'; // Import Edit Screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackgroundColor,
      body: SafeArea(
        child: Consumer2<StepProvider, UserProfileProvider>(
          builder: (context, stepProvider, userProfileProvider, child) {
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                          },
                          child: UserHeaderCard(userProfile: userProfileProvider.userProfile),
                        ),

                        DailySummaryCard(
                          stepsTaken: stepProvider.walkedDailySteps,
                          stepGoal: stepProvider.dailyStepGoal,
                          calories: stepProvider.caloriesBurned,
                          distanceK: stepProvider.distanceKiloMeters,
                        ),

                        AiWorkoutCard(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
