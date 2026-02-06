import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/workout/workout_provider.dart';
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
      appBar: AppBar(title: const Text('AI Workout Plan')),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(WorkoutProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.read<WorkoutProvider>().fetchWorkout(), child: const Text('Retry')),
          ],
        ),
      );
    }

    if (provider.workoutEntity != null) {
      return _buildWorkoutContent(provider.workoutEntity!);
    }

    return const Center(child: Text("No workout recommendations found."));
  }

  Widget _buildWorkoutContent(WorkoutEntity data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(data.summary),
          const SizedBox(height: 20),
          const Text("Weekly Schedule", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // Dynamic Schedule List
          ...data.schedule.entries.map((entry) {
            return _buildDayCard(entry.key, entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(WorkoutSummaryEntity summary) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem("Goal", summary.goal),
            _statItem("Level", summary.level),
            _statItem("Split", summary.split),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildDayCard(String day, List<WorkoutExerciseEntity> exercises) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${exercises.length} Exercises"),
        children: exercises.map((exercise) {
          return ListTile(
            leading: const Icon(Icons.fitness_center),
            title: Text(exercise.name),
            subtitle: Text("Sets: ${exercise.sets} • Reps: ${exercise.reps}"),
          );
        }).toList(),
      ),
    );
  }
}
