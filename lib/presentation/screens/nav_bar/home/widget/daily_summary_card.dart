import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/core/util/extension/date/toMonthDay.dart';
import 'package:rep_rise/presentation/screens/nav_bar/home/widget/mini_stat.dart';

class DailySummaryCard extends StatelessWidget {
  final int stepsTaken;
  final int stepGoal;
  final double calories;
  final double distanceK;

  const DailySummaryCard({
    super.key,
    required this.stepsTaken,
    required this.stepGoal,
    required this.calories,
    required this.distanceK,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: AppTheme.homeActivityCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topTitle(),
            const SizedBox(height: 20),
            _middleBody(),
            const SizedBox(height: 25),
            const Divider(color: Colors.white24),
            _bottomContainer(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _topTitle() {
    return Row(
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
          child: Text(DateTime.now().toMonthDay, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _middleBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$stepsTaken",
              style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold, height: 1.0),
            ),
            const SizedBox(height: 5),
            Text("/ $stepGoal Steps", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.directions_run_rounded, color: AppTheme.primaryPurple, size: 30),
        ),
      ],
    );
  }

  Widget _bottomContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MiniStat(icon: Icons.local_fire_department_rounded, value: "$calories", unit: "kcal"),
        MiniStat(icon: Icons.location_on_rounded, value: "$distanceK", unit: "km"),
        MiniStat(icon: Icons.timer_rounded, value: "45", unit: "min"),
      ],
    );
  }
}
