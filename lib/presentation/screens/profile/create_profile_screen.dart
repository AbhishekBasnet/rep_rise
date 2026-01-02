import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/profile_setup_provider.dart';
import 'package:rep_rise/presentation/widgets/profile_wheel_picker.dart';

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileSetupProvider(),
      child: Consumer<ProfileSetupProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile Setup Screen')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsetsGeometry.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('How old are you?'),
                    Text('This helps us create you personalized plan.'),
                    Spacer(),
                    Text('Selected age: ${provider.age}'),
                    SizedBox(
                      height: 550,
                      child: ProfileWheelPicker(
                        minValue: 18,
                        maxValue: 100,
                        initialValue: provider.age,
                        onChanged: (newAge){
                          provider.setAge(newAge);
                        },
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: double.infinity,
                      child: ElevatedButton(onPressed: () {
                        debugPrint("    User has finished selecting age: ${provider.age}");

                      }, child: Text('Next')),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
