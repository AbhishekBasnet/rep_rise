import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/profile/register_profile_provider.dart';

class GenderStepPage extends StatelessWidget {
  const GenderStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProfileProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text('Select your Gender',style: AppTheme.profileSetupHeader,),
              Column(
                children: [
                  _GenderCard(
                    isSelected: provider.gender == Gender.male,
                    label: 'Male',
                    icon: Icons.male,
                    onTap: () => provider.setGender(Gender.male),
                  ),
                  SizedBox(height: 50),
                  _GenderCard(
                    isSelected: provider.gender == Gender.female,
                    label: 'Female',
                    icon: Icons.female,
                    onTap: () => provider.setGender(Gender.female),
                  ),
                ],
              ),
              // const Spacer(),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _GenderCard extends StatelessWidget {
  final bool isSelected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GenderCard({
    required this.isSelected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            height: isSelected ? 160 : 120,
            width: isSelected ? 160 : 120,
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple : Colors.purple,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.purple, blurRadius: isSelected ? 30 : 10, offset: const Offset(0, 10)),
              ],
            ),
            child: Icon(icon, size: isSelected ? 80 : 50, color: isSelected ? Colors.white : Colors.grey),
          ),
          SizedBox(height: 20,),
          isSelected ? Text(label, style: TextStyle(fontSize: 22, ),) : Text(label, style: TextStyle(fontSize: 15),),
        ],
      ),
    );
  }
}
