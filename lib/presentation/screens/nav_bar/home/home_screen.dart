import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/user_profile_provider.dart';
import 'package:rep_rise/presentation/provider/step/step_provider.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/ai_workout_card.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/daily_summary_card.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/user_header_card.dart';
import 'package:rep_rise/presentation/screens/profile/edit_profile_screen.dart';

import '../../../provider/workout/workout_provider.dart';
import '../workout/workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().fetchWorkout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackgroundColor,
      body: SafeArea(
        child: Consumer3<StepProvider, UserProfileProvider, WorkoutProvider>(
          builder: (context, stepProvider, userProfileProvider, workoutProvider, child) {
            final profile = userProfileProvider.userProfile;
            final name = profile?.username ?? "Athlete";
            final bmi = profile?.bmi.toStringAsFixed(1) ?? "--";
            final height = profile?.height.toString() ?? "--";
            final weight = profile?.weight.toString() ?? "--";
            final recommendedWorkout = workoutProvider.getNextIncompleteWorkout();

            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UserHeaderCard(
                          name: name,
                          height: height,
                          weight: weight,
                          bmi: bmi,
                          onEditTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                          },
                        ),
                        const SizedBox(height: 12),
                        DailySummaryCard(
                          stepsTaken: stepProvider.walkedDailySteps,
                          stepGoal: stepProvider.dailyStepGoal,
                          calories: stepProvider.caloriesBurned,
                          distanceK: stepProvider.distanceKiloMeters,
                        ),
                        const SizedBox(height: 12),
                        if (recommendedWorkout != null)
                          AiWorkoutCard(
                            title: recommendedWorkout.key,
                            duration: "${recommendedWorkout.value.length * 5} mins",
                            difficulty: "Intermediate",
                            exerciseCount: recommendedWorkout.value.length,
                            onPlayPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => WorkoutScreen(targetDay: recommendedWorkout.key)),
                              );
                            },
                          )
                        else if (workoutProvider.isLoading)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text("All workouts completed! Great job!", style: TextStyle(color: Colors.grey)),
                            ),
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
