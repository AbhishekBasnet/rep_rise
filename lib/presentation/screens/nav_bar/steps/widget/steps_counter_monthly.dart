import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ensure provider is imported
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/step/step_provider.dart'; // Adjust path as needed
import 'package:intl/intl.dart'; // Useful for number formatting (e.g., 256,480)

class StepsCounterMonthly extends StatelessWidget {
  const StepsCounterMonthly({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Listen to the StepProvider
    // context.watch() subscribes this widget to changes.
    final stepProvider = context.watch<StepProvider>();

    // Format the number with commas (e.g., 1000 -> 1,000)
    final formatter = NumberFormat('#,###');
    final displaySteps = formatter.format(stepProvider.monthlyTotalSteps);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.stepsCardBoxShadow],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_walk, color: Colors.purpleAccent, size: 28),
              const SizedBox(width: 10),
              Text(
                displaySteps, // 4. Use the dynamic value here
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text("Total steps this month"),
        ],
      ),
    );
  }
}
