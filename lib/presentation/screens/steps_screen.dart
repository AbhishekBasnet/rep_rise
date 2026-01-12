import 'package:flutter/material.dart';
import 'package:rep_rise/presentation/screens/steps/step_bar_graph.dart';
import 'package:rep_rise/presentation/screens/steps/step_counter_graph.dart';
import 'package:rep_rise/presentation/screens/steps/steps_counter_monthly.dart';

class StepsScreen extends StatelessWidget {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steps Screen')),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StepCounterGraph(),
              StepBarGraph(),
              StepsCounterMonthly()
            ],
          ),
        ),
      ),
    );
  }
}
