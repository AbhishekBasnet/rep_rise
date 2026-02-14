import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

class UserHeaderCard extends StatelessWidget {
  // 1. Accept specific fields instead of the whole object
  final String name;
  final String height;
  final String weight;
  final String bmi;
  final VoidCallback onEditTap;

  const UserHeaderCard({
    super.key,
    required this.name,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Stack(
        children: [
          Positioned.fill(child: Container(decoration: AppTheme.homeActivityCardDecoration)),

          // Decorative Background Circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome back,", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(
                            name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Edit Button
                    GestureDetector(
                      onTap: onEditTap, // Use the callback
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Stats Row
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat("Height", "$height cm"),
                      _buildDivider(),
                      _buildStat("Weight", "$weight kg"),
                      _buildDivider(),
                      _buildStat("BMI", bmi, isHighlight: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 25, width: 1, color: Colors.white.withOpacity(0.3));
  }

  Widget _buildStat(String label, String value, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? const Color(0xFF5AFFD2) : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
      ],
    );
  }
}