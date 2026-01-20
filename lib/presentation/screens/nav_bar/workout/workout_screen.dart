import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MockHomeData {
  final String username = "Sanjay";
  final int stepsTaken = 3500;
  final int stepGoal = 5000;
  final int calories = 420;
  final double distanceKm = 2.5;
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockHomeData();

    return Scaffold(
      backgroundColor: AppTheme.appBackgroundColor, //
      appBar: AppBar(
        backgroundColor: AppTheme.appBackgroundColor,
        elevation: 0,
        // Customized Title Area with Greeting and Avatar
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryPurple, width: 2),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/user_placeholder.png'), //
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${data.username}!",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                Text(
                  "Let's crush your goals.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        actions: [
          // LOGOUT BUTTON (Moved here as requested)
          IconButton(
            onPressed: () {
              // Add Logout Logic Here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logging out...")),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 5,
                  )
                ],
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Card: Daily Summary
            _DailySummaryCard(data: data),

            const SizedBox(height: 25),

            // 2. Section Title
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // 3. Action Grid
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: "Start\nWorkout",
                    icon: Icons.fitness_center_rounded,
                    color: AppTheme.primaryPurple,
                    isPrimary: true,
                    onTap: () {
                      // Navigate to Workout Screen
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _ActionCard(
                    title: "Log\nWater",
                    icon: Icons.water_drop_rounded,
                    color: Colors.blueAccent,
                    isPrimary: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: "Sleep\nTracker",
                    icon: Icons.bedtime_rounded,
                    color: Colors.indigo,
                    isPrimary: false,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _ActionCard(
                    title: "My\nReports",
                    icon: Icons.bar_chart_rounded,
                    color: Colors.orange,
                    isPrimary: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 4. Motivation / Insight Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.secondaryGrey, //
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates, color: Colors.amber, size: 30),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tip of the day", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          "Drink water 30 mins before meals for better digestion.",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SUB-WIDGETS
// ---------------------------------------------------------------------------

class _DailySummaryCard extends StatelessWidget {
  final MockHomeData data;

  const _DailySummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryPurple, AppTheme.purple], //
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Activity",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text("Jan 26", style: TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data.stepsTaken}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "/ ${data.stepGoal} Steps",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_run_rounded, color: AppTheme.primaryPurple, size: 30),
              )
            ],
          ),
          const SizedBox(height: 25),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniStat(icon: Icons.local_fire_department_rounded, value: "${data.calories}", unit: "kcal"),
              _MiniStat(icon: Icons.location_on_rounded, value: "${data.distanceKm}", unit: "km"),
              _MiniStat(icon: Icons.timer_rounded, value: "45", unit: "min"),
            ],
          )
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;

  const _MiniStat({required this.icon, required this.value, required this.unit});

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
              TextSpan(text: " $unit", style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white70)),
            ],
          ),
        )
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPrimary ? color : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white.withValues(alpha: 0.2) : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isPrimary ? Colors.white : color, size: 24),
            ),
            Text(
              title,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}