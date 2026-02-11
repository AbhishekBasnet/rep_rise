import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/workout/workout_provider.dart';
import '../../../../../../domain/entity/workout/workout_entity.dart';
import 'exercise_card.dart';

class DaySection extends StatelessWidget {
  final String dayTitle;
  final List<WorkoutExerciseEntity> exercises;
  final bool initiallyExpanded;
  final bool isDone;
  const DaySection({
    super.key,
    required this.dayTitle,
    required this.exercises,
    required this.isDone,
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
                  color: isDone ? Colors.grey : AppTheme.appContentColor,
                  fontWeight: FontWeight.w800,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(width: 8),

              GestureDetector(
                onTap: () async {
                  final provider = context.read<WorkoutProvider>();
                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                  await provider.toggleDayProgress(dayTitle, isDone);

                  final newStatus = !isDone;
                  final message = newStatus ? " marked as done!" : " marked as incomplete.";

                  scaffoldMessenger.clearSnackBars();

                  final snackBarController = scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('$dayTitle$message'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.appContentColor,
                      action: SnackBarAction(
                        label: 'UNDO',
                        textColor: AppTheme.primaryPurple,
                        onPressed: () {
                          provider.toggleDayProgress(dayTitle, newStatus);
                        },
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );

                  Future.delayed(const Duration(seconds: 3), () {
                    snackBarController.close();
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? AppTheme.primaryPurple : Colors.transparent,
                    border: Border.all(color: isDone ? AppTheme.primaryPurple : Colors.grey.shade300, width: 2),
                  ),
                  child: isDone ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                ),
              ),
            ],
          ),
          children: exercises.map((ex) => ExerciseCard(exercise: ex)).toList(),
        ),
      ),
    );
  }
}
