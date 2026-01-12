import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rep_rise/domain/repositories/step_repository.dart';

class StepApiTestScreen extends StatefulWidget {
  // We ask for the repository here.
  // This ensures we use the existing, logged-in instance from your main app.
  final StepRepository repository;

  const StepApiTestScreen({
    super.key,
    required this.repository,
  });

  @override
  State<StepApiTestScreen> createState() => _StepApiTestScreenState();
}

class _StepApiTestScreenState extends State<StepApiTestScreen> {
  String _logText = "Ready to test endpoints...\n";
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  // --- LOGGING HELPER ---
  void _addToLog(String tag, String message) {
    setState(() {
      final time = DateFormat('HH:mm:ss').format(DateTime.now());
      _logText = "[$time] $tag: $message\n\n$_logText";
      _isLoading = false;
    });
  }

  // --- TEST ACTIONS ---

  // 1. Test GET Daily (Single Object)
  Future<void> _testDailySteps() async {
    setState(() => _isLoading = true);
    try {
      _addToLog("Request", "GET /api/v1/steps/analytics/?period=daily");

      // Using widget.repository accesses the instance passed in the constructor
      final data = await widget.repository.getDailySteps();

      _addToLog("Success", "Steps: ${data.steps}\nGoal: ${data.goal}\nDate: ${data.date}");
    } catch (e) {
      _addToLog("Error", e.toString());
    }
  }

  // 2. Test GET Weekly (List of Objects)
  Future<void> _testWeeklySteps() async {
    setState(() => _isLoading = true);
    try {
      _addToLog("Request", "GET /api/v1/steps/analytics/?period=weekly");

      final list = await widget.repository.getWeeklySteps();

      String summary = list.isEmpty
          ? "List is empty"
          : "First: ${list.first.date} (${list.first.steps} steps)\nLast: ${list.last.date} (${list.last.steps} steps)";

      _addToLog("Success", "Received ${list.length} days.\n$summary");
    } catch (e) {
      _addToLog("Error", e.toString());
    }
  }

  // 3. Test GET Monthly (Summary Object)
  Future<void> _testMonthlyStats() async {
    setState(() => _isLoading = true);
    try {
      final now = DateTime.now();
      _addToLog("Request", "GET /api/v1/steps/analytics/?period=monthly&year=${now.year}&month=${now.month}");

      final stats = await widget.repository.getMonthlyStats(now.year, now.month);

      _addToLog("Success", "Total Steps: ${stats.totalSteps}\nAvg Goal: ${stats.avgGoal}\nTotal Goal: ${stats.totalGoal}");
    } catch (e) {
      _addToLog("Error", e.toString());
    }
  }

  // 4. Test SYNC (HealthService -> API)
  Future<void> _testSyncSteps() async {
    setState(() => _isLoading = true);
    try {
      _addToLog("Process", "Reading Sensors & POSTing to /api/v1/steps/");

      await widget.repository.syncSteps();

      _addToLog("Success", "Device steps synced successfully.");
    } catch (e) {
      _addToLog("Error", "Sync Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Connectivity Test")),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(onPressed: _testDailySteps, child: const Text("Daily")),
                ElevatedButton(onPressed: _testWeeklySteps, child: const Text("Weekly")),
                ElevatedButton(onPressed: _testMonthlyStats, child: const Text("Monthly")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
                  onPressed: _testSyncSteps,
                  child: const Text("SYNC NOW"),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => setState(() => _logText = ""),
                )
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black87,
              padding: const EdgeInsets.all(12),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                controller: _scrollController,
                child: Text(
                  _logText,
                  style: const TextStyle(color: Colors.greenAccent,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}