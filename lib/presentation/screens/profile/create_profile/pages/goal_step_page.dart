import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/register_profile_provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/widget/profile_wheel_picker.dart';

class GoalStepPage extends StatelessWidget {
  const GoalStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProfileProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('What is your daily goal steps?',style: AppTheme.profileSetupHeader,),
              SizedBox(height: 5,),
              Text('This helps us create you personalized plan.',style: AppTheme.profileSetupSubHeader,),
              SizedBox(height: 10,),
              Text.rich(
                TextSpan(
                    text: 'Selected age: ',
                    children: [TextSpan(text: '${provider.goalSteps} steps', style:AppTheme.profileSetupWheelSelectedText)],
                    style: AppTheme.profileSetupHeader3
                ),
              ),
              Expanded(
                child: ProfileWheelPicker(
                  unit: '             steps',
                  step: 500,
                  minValue: 1000,
                  maxValue: 10000,
                  initialValue: provider.goalSteps,
                  onChanged: (newGoalSteps) {
                    provider.setGoalSteps(newGoalSteps);
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
