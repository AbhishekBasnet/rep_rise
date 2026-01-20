import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/screens/home/widgets/ai_workout_card.dart';
import 'package:rep_rise/presentation/screens/home/widgets/daily_summary_card.dart';

import '../../provider/auth/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<void> _handleLogout(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Logout'),
        ),
      ],
    ),
  );

  if (shouldLogout == true && context.mounted) {
    final authProvider = context.read<AuthProvider>();

    await authProvider.logout();
  }
}

class _HomeScreenState extends State<HomeScreen> {
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
                Text("Hello, ${data.username}!", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                Text("Let's crush your goals.", style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
        actions: [
          // LOGOUT BUTTON (Moved here as requested)
          IconButton(
            onPressed: (() => _handleLogout(context)),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 5)],
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
            DailySummaryCard(data: data),

            AiWorkoutCard(),

          ],
        ),
      ),
    );
  }
}
