import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/register_profile_provider.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/profile_wheel_picker.dart';

class HeightStepPage extends StatelessWidget {
  const HeightStepPage({super.key});

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
              Text('How tall are you?',style: AppTheme.profileSetupHeader2,),
              const SizedBox(height: 5,),
              Text('This helps us create you personalized plan.',style: AppTheme.profileSetupSubHeader,),
              const SizedBox(height: 10,),
              Text.rich(
                TextSpan(
                    text: 'Selected height: ',
                    children: [TextSpan(text: '${provider.height} cm', style:AppTheme.profileSetupWheelSelectedText)],
                    style: AppTheme.profileSetupHeader3
                ),
              ),Expanded(
                child: ProfileWheelPicker(
                  unit: '     cm',
                  minValue: 50,
                  maxValue: 300,
                  initialValue: provider.height,
                  onChanged: (newHeight) {
                    provider.setHeight(newHeight);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );}
}
