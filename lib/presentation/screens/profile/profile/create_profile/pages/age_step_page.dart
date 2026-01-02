import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/profile_setup_provider.dart';
import '../profile_wheel_picker.dart';

class AgeStepPage extends StatelessWidget {
  const AgeStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileSetupProvider(),
      child: Consumer<ProfileSetupProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('How old are you?'),
                Text('This helps us create you personalized plan.'),
                Text('Selected age: ${provider.age}'),
                Expanded(
                  child: ProfileWheelPicker(
                    minValue: 18,
                    maxValue: 100,
                    initialValue: provider.age,
                    onChanged: (newAge) {
                      provider.setAge(newAge);
                    },
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
