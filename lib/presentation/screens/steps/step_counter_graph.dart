import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

class StepCounterCircularProgress extends StatelessWidget {
  const StepCounterCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
            Text("Steps", style:AppTheme.profileSetupSubHeader),
            SizedBox(height: 8),
            Text("4,805", style: AppTheme.stepsProgressNumber),
            Text("/6000"),
          ],
        ),
      ),
    );
  }
}
