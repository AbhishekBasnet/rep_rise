import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

class ExerciseTag extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const ExerciseTag({super.key, required this.label, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textColor, letterSpacing: 0.5),
      ),
    );
  }
}

class ExerciseStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const ExerciseStat({super.key, required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryPurple),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.appContentColor),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
