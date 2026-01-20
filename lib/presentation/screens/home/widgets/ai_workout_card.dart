import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

class AiWorkoutCard extends StatelessWidget {
  const AiWorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppTheme.stepsCardBoxShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_upperTile(), const SizedBox(height: 15),_mainBody()],
      ),
    );
  }

  Widget _upperTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Recommended for You", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.auto_awesome, size: 14, color: AppTheme.primaryPurple),
              SizedBox(width: 4),
              Text(
                "AI Pick",
                style: TextStyle(fontSize: 10, color: AppTheme.primaryPurple, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mainBody() {
    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.fitness_center, color: Colors.orange, size: 30),
        ),
        const SizedBox(width: 15),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upper Body Power", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("45 mins • Intermediate • 8 Exercises", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple),
          child: IconButton(
            icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to workout start
            },
          ),
        ),
      ],
    );
  }
}
