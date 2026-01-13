import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

class StepsCounterMonthly extends StatelessWidget {
  const StepsCounterMonthly({super.key});

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.directions_walk, color: Colors.purpleAccent, size: 28),
              SizedBox(width: 10),

              Text(
                "256,480",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),

          SizedBox(height: 8),

          Text("Total steps this month"),
        ],
      ),
    );
  }
}
