import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/screens/home/widgets/mini_stat.dart';

class MockHomeData {
  final String username = "Abhishek";
  final int stepsTaken = 3500;
  final int stepGoal = 5000;
  final int calories = 420;
  final double distanceKm = 2.5;
}

class DailySummaryCard extends StatelessWidget {
  final MockHomeData data;

  const DailySummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: AppTheme.homeActivityCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Activity",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text("Jan 26", style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data.stepsTaken}",
                    style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold, height: 1.0),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "/ ${data.stepGoal} Steps",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.directions_run_rounded, color: AppTheme.primaryPurple, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MiniStat(icon: Icons.local_fire_department_rounded, value: "${data.calories}", unit: "kcal"),
              MiniStat(icon: Icons.location_on_rounded, value: "${data.distanceKm}", unit: "km"),
              MiniStat(icon: Icons.timer_rounded, value: "45", unit: "min"),
            ],
          ),
        ],
      ),
    );
  }
}
