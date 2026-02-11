import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/screens/nav_bar/workout/widget/workout_widget.dart';
import '../../../../../../domain/entity/workout/workout_entity.dart';

class ExerciseCard extends StatelessWidget {
  final WorkoutExerciseEntity exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryPurple.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            debugPrint("Card tapped: Load Video/GIF logic here");
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppTheme.secondaryGrey),
                const SizedBox(height: 12),
                _buildStatsRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.appContentColor),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ExerciseTag(
                    label: exercise.bodyPart,
                    backgroundColor: AppTheme.lavender.withOpacity(0.3),
                    textColor: AppTheme.primaryPurple,
                  ),
                  ExerciseTag(
                    label: exercise.targetMuscle,
                    backgroundColor: AppTheme.secondaryGrey,
                    textColor: Colors.black54,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExerciseStat(icon: Icons.layers_outlined, value: exercise.sets, label: "Sets"),
        _verticalDivider(),
        ExerciseStat(icon: Icons.refresh_rounded, value: exercise.reps, label: "Reps"),
        _verticalDivider(),
        ExerciseStat(icon: Icons.timer_outlined, value: exercise.restTime, label: "Rest"),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 25, width: 1, color: AppTheme.secondaryGrey);
  }
}
