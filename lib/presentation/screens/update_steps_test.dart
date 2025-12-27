import 'package:flutter/material.dart';

import '../../core/network/api_client.dart';
import '../../data/repositories/step_repository_impl.dart';
import '../../core/services/health_steps_service.dart';
import '../../data/data_sources/step_remote_data_source.dart';

import 'package:health/health.dart';

class UpdateStepsTest extends StatefulWidget {
  const UpdateStepsTest({super.key});

  @override
  State<UpdateStepsTest> createState() => _UpdateStepsTestState();
}



Future<void> requestHealthPermissions() async {
  final health = Health(); // In newer versions, use Health() directly

  // Define the types you want to access
  final types = [HealthDataType.STEPS];

  // Request authorization
  bool requested = await health.requestAuthorization(types);

  if (requested) {
    print("Permissions granted! You can now call syncSteps().");
  } else {
    print("Permissions denied by user.");
  }
}
class _UpdateStepsTestState extends State<UpdateStepsTest> {
  late final StepRepositoryImpl _repository;
  bool _isLoading = true;
  String _message = "Initializing API Test...";

  @override
  void initState() {
    super.initState();

    // 1. Initialize the ApiClient you provided
    final apiClient = ApiClient();

    // 2. Pass the ApiClient (and its Dio instance) to the Data Source
    // Note: Ensure your StepRemoteDataSource constructor accepts the ApiClient or Dio
    final remoteDataSource = StepRemoteDataSource(apiClient: apiClient);

    // 3. Setup the Repository with all dependencies
    _repository = StepRepositoryImpl(
      healthService: HealthService(),
      remoteDataSource: remoteDataSource,
    );

    // 4. Automatically trigger the sync when the page loads
    _runApiTest();
  }


  Future<void> _runApiTest() async {
    try {
      final health = Health();

      // 1. Request Authorization from the user first
      // This will now successfully launch the permission dialog
      bool hasPermissions = await health.requestAuthorization([HealthDataType.STEPS]);

      if (!hasPermissions) {
        setState(() {
          _message = "Permissions were denied by the user.";
          _isLoading = false;
        });
        return;
      }

      // 2. If granted, proceed with your API call
      await _repository.syncSteps();

      if (mounted) {
        setState(() {
          _message = "Success! Steps synced for Joshua.";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _message = "Error: ${e.toString()}";
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Step Sync Test")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload, size: 60, color: Colors.blue),
              const SizedBox(height: 16),
              Text(_message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() => _isLoading = true);
                  _runApiTest();
                },
                child: const Text("Retry Sync"),
              )
            ],
          ),
        ),
      ),
    );
  }
}