import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/user_profile_provider.dart';
import 'package:rep_rise/presentation/provider/step/step_provider.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/ai_workout_card.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/daily_summary_card.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/user_header_card.dart';
import 'package:rep_rise/presentation/screens/profile/edit_profile_screen.dart';

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

            // 1. Extract and Prepare Data Here
            final profile = userProfileProvider.userProfile;
            final name = profile?.username ?? "Athlete";
            final bmi = profile?.bmi.toStringAsFixed(1) ?? "--";
            final height = profile?.height.toString() ?? "--";
            final weight = profile?.weight.toString() ?? "--";

            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        // 2. Pass Primitives directly
                        UserHeaderCard(
                          name: name,
                          height: height,
                          weight: weight,
                          bmi: bmi,
                          onEditTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                          },
                        ),

                        DailySummaryCard(
                          stepsTaken: stepProvider.walkedDailySteps,
                          stepGoal: stepProvider.dailyStepGoal,
                          calories: stepProvider.caloriesBurned,
                          distanceK: stepProvider.distanceKiloMeters,
                        ),

                        // From previous refactor
                        AiWorkoutCard(
                          title: "Upper Body Power",
                          duration: "45 mins",
                          difficulty: "Intermediate",
                          exerciseCount: 8,
                          onPlayPressed: () {
                            // Navigate logic
                          },
                        ),
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