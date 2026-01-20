import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/register_profile_provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/widget/profile_wheel_picker.dart';

class WeightStepPage extends StatelessWidget {
  const WeightStepPage({super.key});

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
              Text('Enter your current weight.',style: AppTheme.profileSetupHeader,),
              SizedBox(height: 5,),
              Text('This helps us create you personalized plan.',style: AppTheme.profileSetupSubHeader,),
              SizedBox(height: 10,),
              Text.rich(
                TextSpan(
                    text: 'Selected age: ',
                    children: [TextSpan(text: '${provider.weight} kg', style:AppTheme.profileSetupWheelSelectedText)],
                    style: AppTheme.profileSetupHeader3
                ),
              ),
              Expanded(
                child: ProfileWheelPicker(
                  unit: 'kg',
                  minValue: 35,
                  maxValue: 100,
                  initialValue: provider.weight,
                  onChanged: (newWeight) {
                    provider.setWeight(newWeight);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );}
}
