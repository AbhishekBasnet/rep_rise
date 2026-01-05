import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/profile_setup_provider.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/profile_wheel_picker.dart';

class HeightStepPage extends StatelessWidget {
  const HeightStepPage({super.key});

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
              Text('How tall are you?'),
              Text('This helps us create you personalized plan.'),
              Text('Selected age: ${provider.height} cm'),
              Expanded(
                child: ProfileWheelPicker(
                  minValue: 50,
                  maxValue: 300,
                  initialValue: provider.height,
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
