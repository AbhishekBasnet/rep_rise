import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/profile_setup_provider.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/profile_wheel_picker.dart';

class WeightStepPage extends StatelessWidget {
  const WeightStepPage({super.key});

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
              Text('Enter your current weight.'),
              Text('This helps us create you personalized plan.'),
              Text('Selected age: ${provider.weight} kg'),
              Expanded(
                child: ProfileWheelPicker(
                  minValue: 35,
                  maxValue: 100,
                  initialValue: provider.weight,
                  onChanged: (newAge) {
                    provider.setAge(newAge);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );}
}
