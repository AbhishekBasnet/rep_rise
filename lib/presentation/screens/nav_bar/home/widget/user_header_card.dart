import 'package:flutter/material.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/domain/entity/profile/user_profile_entity.dart';

class UserHeaderCard extends StatelessWidget {
  final UserProfileEntity? userProfile;

  const UserHeaderCard({super.key, this.userProfile});

  @override
  Widget build(BuildContext context) {
    final name = userProfile?.username ?? "Athlete";
    final bmi = userProfile?.bmi.toStringAsFixed(1) ?? "--";
    final height = userProfile?.height.toString() ?? "--";
    final weight = userProfile?.weight.toString() ?? "--";

    return Container(
      width: double.infinity,
      height: 240, // Taller to dominate the top
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Stack(
        children: [
          // 1. FLASHY BACKGROUND
          Container(
            decoration: AppTheme.homeActivityCardDecoration,
          ),
          // 2. DECORATIVE CIRCLES (The "Flashy" part)
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

          // 3. CONTENT
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome back,", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                        const SizedBox(height: 5),
                        Text(
                          name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900, // Thicker font
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/user_placeholder.png'),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // GLASSMORPHISM STATS ROW
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
            color: isHighlight ? const Color(0xFF5AFFD2) : Colors.white, // Teal accent for BMI
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
