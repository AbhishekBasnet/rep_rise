import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/register_profile_provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/widget/profile_enums.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/widget/profile_selection_card.dart';

class WorkoutLevelStepPage extends StatelessWidget {
  const WorkoutLevelStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProfileProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('What\'s your workout level?', style: AppTheme.profileSetupHeader),
              Column(
                children: [
                  ProfileSelectionCard(
                    isSelected: provider.workoutLevel == WorkoutLevel.beginner,
                    label: 'Beginner',
                    icon: Icons.light_mode,
                    onTap: () => provider.setWorkoutLevel(WorkoutLevel.beginner),
                  ),
                  const SizedBox(height: 50),
                  ProfileSelectionCard(
                    isSelected: provider.workoutLevel == WorkoutLevel.intermediate,
                    label: 'Intermediate',
                    icon: Icons.bolt,
                    isEnabled: false,
                    disabledMessage: 'You can change this later in your profile',
                    onTap: () => provider.setWorkoutLevel(WorkoutLevel.intermediate),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
