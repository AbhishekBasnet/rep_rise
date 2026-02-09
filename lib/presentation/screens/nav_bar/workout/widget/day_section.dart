import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import '../../../../../../domain/entity/workout/workout_entity.dart';
import 'exercise_card.dart';

class DaySection extends StatelessWidget {
  final String dayTitle;
  final List<WorkoutExerciseEntity> exercises;
  final bool initiallyExpanded;

  const DaySection({
    super.key,
    required this.dayTitle,
    required this.exercises,
    this.initiallyExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: 8),

          iconColor: AppTheme.primaryPurple,
          collapsedIconColor: AppTheme.appContentColor,
          title: Row(
            children: [
              Text(
                dayTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.appContentColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.check_circle_outline, size: 20, color: Colors.grey),
            ],
          ),

          children: exercises.map((ex) => ExerciseCard(exercise: ex)).toList(),
        ),
      ),
    );
  }
}