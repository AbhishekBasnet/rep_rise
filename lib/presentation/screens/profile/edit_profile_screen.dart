import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/user_profile_provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/widget/profile_enums.dart';

import '../../provider/workout/workout_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _targetWeightController;
  late TextEditingController _ageController;
  late TextEditingController _stepGoalController;

  WorkoutLevel _selectedFitnessLevel = WorkoutLevel.beginner;

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProfileProvider>();

    // Initialize with existing data
    _heightController = TextEditingController(text: provider.height.toString());
    _weightController = TextEditingController(text: provider.weight.toString());
    _ageController = TextEditingController(text: provider.age.toString());
    _targetWeightController = TextEditingController(text: provider.userProfile?.targetWeight.toString() ?? "0");
    _stepGoalController = TextEditingController(text: provider.dailyStepGoal.toString());

    _selectedFitnessLevel = WorkoutLevelExtension.fromString(provider.userProfile?.fitnessLevel ?? 'beginner');
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _ageController.dispose();
    _stepGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();

    return Scaffold(
      backgroundColor: AppTheme.appBackgroundColor,
      appBar: AppBar(title: const Text("Edit Profile"), backgroundColor: AppTheme.appBackgroundColor),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionHeader("Physical Stats"),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(child: _buildTextField("Height (cm)", _heightController, Icons.height)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildTextField("Weight (kg)", _weightController, Icons.monitor_weight)),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(child: _buildTextField("Age", _ageController, Icons.calendar_today)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildTextField("Target Wgt (kg)", _targetWeightController, Icons.flag)),
                    ],
                  ),

                  const SizedBox(height: 30),
                  _buildSectionHeader("Goals & Activity"),
                  const SizedBox(height: 15),

                  _buildTextField("Daily Step Goal", _stepGoalController, Icons.directions_walk),

                  const SizedBox(height: 20),
                  _buildLabel("Fitness Level"),
                  _buildDropdown(),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: provider.isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            "Save Changes",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(fontSize: 18));
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.primaryPurple.withValues(alpha: 0.7)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<WorkoutLevel>(
          value: _selectedFitnessLevel,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryPurple),
          items: WorkoutLevel.values.map((WorkoutLevel level) {
            return DropdownMenuItem<WorkoutLevel>(value: level, child: Text(level.displayName));
          }).toList(),
          onChanged: (WorkoutLevel? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedFitnessLevel = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProfileProvider>();
    final workoutProvider = context.read<WorkoutProvider>();

    final Map<String, dynamic> updateData = {
      "daily_step_goal": int.parse(_stepGoalController.text),
      "height": double.parse(_heightController.text),
      "weight": double.parse(_weightController.text),
      "age": int.parse(_ageController.text),
      "target_weight": double.parse(_targetWeightController.text),
      "fitness_level": _selectedFitnessLevel.apiValue,
    };

    final success = await provider.updateProfile(updateData);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated! Refreshing workout plan..."), duration: Duration(seconds: 2)),
        );
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          workoutProvider.fetchWorkout(forceRefresh: true);
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.errorMessage ?? "Update failed")));
      }
    }
  }
}
