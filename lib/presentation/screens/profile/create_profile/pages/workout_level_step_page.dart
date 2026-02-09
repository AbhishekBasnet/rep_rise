import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/register_profile_provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/widget/profile_enums.dart';

class LevelStepPage extends StatelessWidget {
  const LevelStepPage({super.key});

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
                  _WorkoutLevelCard(
                    isSelected: provider.workoutLevel == WorkoutLevel.beginner,
                    label: 'Beginner',
                    icon: Icons.light_mode,
                    onTap: () => provider.setWorkoutLevel(WorkoutLevel.beginner),
                  ),
                  const SizedBox(height: 50),
                  _WorkoutLevelCard(
                    isSelected: provider.workoutLevel == WorkoutLevel.intermediate,
                    label: 'Intermediate',
                    icon: Icons.bolt,
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

class _WorkoutLevelCard extends StatelessWidget {
  final bool isSelected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _WorkoutLevelCard({required this.isSelected, required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            height: isSelected ? 160 : 120,
            width: isSelected ? 160 : 120,
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple : Colors.purple,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.purple, blurRadius: isSelected ? 30 : 10, offset: const Offset(0, 10)),
              ],
            ),
            child: Icon(icon, size: isSelected ? 80 : 50, color: isSelected ? Colors.white : Colors.grey),
          ),
          const SizedBox(height: 20),
          isSelected
              ? Text(label, style: const TextStyle(fontSize: 22))
              : Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
