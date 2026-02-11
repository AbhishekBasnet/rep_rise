import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/workout/workout_provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/screens/nav_bar/workout/widget/day_section.dart';
import '../../../../domain/entity/workout/workout_entity.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().fetchWorkout();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();

    return Scaffold(
      backgroundColor: AppTheme.appBackgroundColor,
      appBar: AppBar(
        title: const Text('Your Plan'),
        backgroundColor: AppTheme.appBackgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(WorkoutProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryPurple));
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text("Could not load plan", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => context.read<WorkoutProvider>().fetchWorkout(), child: const Text('Retry')),
          ],
        ),
      );
    }

    if (provider.workoutEntity != null) {
      return _buildScheduleList(provider.workoutEntity!, provider);
    }

    return Center(child: Text("No workout plan found.", style: Theme.of(context).textTheme.bodyMedium));
  }

  Widget _buildScheduleList(WorkoutEntity data, WorkoutProvider provider) {
    final sortedDays = data.schedule.keys.toList()..sort((a, b) => a.compareTo(b));

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      itemCount: sortedDays.length,
      separatorBuilder: (c, i) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final day = sortedDays[index];
        final exercises = data.schedule[day]!;

        final bool isDayDone = provider.isDayCompleted(day);

        return DaySection(dayTitle: day, exercises: exercises, isDone: isDayDone, initiallyExpanded: index == 0);
      },
    );
  }
}
