import 'package:flutter/material.dart';

class ProfileSelectionCard extends StatelessWidget {
  final bool isSelected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;
  final String? disabledMessage;

  const ProfileSelectionCard({
    super.key,
    required this.isSelected,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isEnabled = true,
    this.disabledMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: () {
          if (isEnabled) {
            onTap();
          } else if (disabledMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(disabledMessage!),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              height: isSelected ? 160 : 120,
              width: isSelected ? 160 : 120,
              decoration: BoxDecoration(
                color: isEnabled ? Colors.purple : Colors.grey.shade400,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isEnabled ? Colors.purple : Colors.grey,
                    blurRadius: isSelected ? 30 : 10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: isSelected ? 80 : 50,
                color: isSelected ? Colors.white : Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: isSelected ? 22 : 15,
                color: Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}