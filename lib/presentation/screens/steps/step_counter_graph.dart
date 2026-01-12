import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

class StepCounterCircularGraph extends StatelessWidget {
  const StepCounterCircularGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsetsGeometry.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        // Optional: Adds a subtle shadow like the card in the image
        boxShadow: [AppTheme.stepsCardBoxShadow],
      ),
      child: CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 20.0,
        animation: true,
        percent: 0.80,

        startAngle: 225.0,
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: AppTheme.wheelPurple,
        backgroundColor: Colors.grey.shade300,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Steps", style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 8),
            Text("4,805", style: AppTheme.stepsProgressNumber),
            Text("/6000"),
          ],
        ),
      ),
    );
  }
}
