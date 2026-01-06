import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

import '../../../../../provider/profile_setup_provider.dart';
import '../profile_wheel_picker.dart';

class AgeStepPage extends StatelessWidget {
  const AgeStepPage({super.key});

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
              Column(
                children: [
                  const Text('How old are you?', style: AppTheme.profileSetupHeader),
                  const SizedBox(height: 5,),
                  const Text('This helps us create you personalized plan.', style: AppTheme.profileSetupSubHeader),
                  const SizedBox(height: 10,),
                  Text.rich(
                    TextSpan(
                      text: 'Selected age: ',
                      children: [TextSpan(text: '${provider.age} years', style:AppTheme.profileSetupWheelSelectedText)],
                      style: AppTheme.profileSetupHeader3
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ProfileWheelPicker(
                  unit: '      years',
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
    );
  }
}
