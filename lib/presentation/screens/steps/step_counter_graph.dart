import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

class StepCounterGraph extends StatelessWidget {
  const StepCounterGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsetsGeometry.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        // Optional: Adds a subtle shadow like the card in the image
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),      child: CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 13.0,
        animation: true,
        percent: 0.80,


        startAngle: 225.0,
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: AppTheme.wheelPurple,
        backgroundColor: Colors.grey.shade50,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Steps", style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 8),
            Text(
              "4,805",
              style: AppTheme.stepsProgressNumber,
            ),
            Text("/6000", ),
          ],
        ),
      ),
    );
  }
}