import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/profile_setup_provider.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/profile_wheel_picker.dart';

class GoalStepPage extends StatelessWidget {
  const GoalStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSetupProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('What is your daily goal steps?'),
              Text('This helps us create you personalized plan.'),
              Text('Selected age: ${provider.goalSteps} per day'),
              Expanded(
                child: ProfileWheelPicker(
                  minValue: 0,
                  maxValue: 10000,
                  initialValue: provider.goalSteps,
                  onChanged: (newAge) {
                    provider.setAge(newAge);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
