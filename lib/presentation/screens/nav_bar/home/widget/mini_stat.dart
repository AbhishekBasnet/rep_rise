import 'package:flutter/material.dart';

class MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;

  const MiniStat({super.key, required this.icon, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 5),
        RichText(
          text: TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            children: [
              TextSpan(
                text: " $unit",
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
