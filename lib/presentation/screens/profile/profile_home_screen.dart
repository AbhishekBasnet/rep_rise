import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:rep_rise/data/data_sources/local/step/step_local_data_source.dart';

import '../../../core/di/injection_container.dart.dart';

class ProfileHomeScreen extends StatelessWidget {
  const ProfileHomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // DEBUG DATABASE BUTTON
          IconButton(
            icon: const Icon(Icons.storage_rounded, color: Colors.red), // Red so you remember to remove it!
            onPressed: () {
              // 1. Get the database instance directly from your Service Locator
              final db = sl<AppDatabase>();

              // 2. Navigate to the Viewer
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DriftDbViewer(db)),
              );
            },
          ),
        ],
      ),
      // ... rest of your body
    );
  }
}
