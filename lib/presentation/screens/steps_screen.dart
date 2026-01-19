import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/step_provider/step_provider.dart';
import 'package:rep_rise/presentation/screens/steps/step_bar_graph.dart';
import 'package:rep_rise/presentation/screens/steps/steps_circular_progress_bar.dart';
import 'package:rep_rise/presentation/screens/steps/steps_counter_monthly.dart';

import '../../core/di/injection_container.dart.dart';
import '../../data/data_sources/local/step/step_local_data_source.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StepProvider>().initSteps();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storage_rounded, color: Colors.red),
            onPressed: () {
              final db = sl<AppDatabase>();

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DriftDbViewer(db)));
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            // fills the space , if not, make the child scrollable: sano screen ko lagi
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(10),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: const [StepCounterCircularProgress(), StepBarGraph(), StepsCounterMonthly()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
