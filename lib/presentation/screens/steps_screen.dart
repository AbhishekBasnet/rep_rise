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
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            // fills the space , if not, make the child scrollable: sano screen ko lagi
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(10),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: const [StepCounterCircularGraph(), StepBarGraph(), StepsCounterMonthly()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
