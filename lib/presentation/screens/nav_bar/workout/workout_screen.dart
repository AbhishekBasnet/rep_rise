import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: const Center(
        child: Text(
          'Workout Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

}