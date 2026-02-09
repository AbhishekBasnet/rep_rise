import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/register_profile_provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/widget/profile_selection_card.dart';

import '../widget/profile_enums.dart';

class GenderStepPage extends StatelessWidget {
  const GenderStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProfileProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Select your Gender', style: AppTheme.profileSetupHeader),
              Column(
                children: [
                  ProfileSelectionCard(
                    isSelected: provider.gender == Gender.male,
                    label: 'Male',
                    icon: Icons.male,
                    onTap: () => provider.setGender(Gender.male),
                  ),
                  const SizedBox(height: 50),
                  ProfileSelectionCard(
                    isSelected: provider.gender == Gender.female,
                    label: 'Female',
                    icon: Icons.female,
                    onTap: () => provider.setGender(Gender.female),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
