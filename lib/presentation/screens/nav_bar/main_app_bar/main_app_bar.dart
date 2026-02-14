import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/authentication/auth_provider.dart';
import 'package:rep_rise/presentation/provider/profile/user_profile_provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<UserProfileProvider>();

    return AppBar(
      backgroundColor: AppTheme.appBackgroundColor,
      elevation: 0,
      toolbarHeight: 70,
      // 1. Title is just text now (No Gesture Detector)
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${profileProvider.username}!",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
              Text("Let's crush your goals.", style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
      // 2. Added Logout Button here
      actions: [
        IconButton(
          onPressed: () => _handleLogout(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.secondaryGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout, color: Colors.red, size: 20),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      context.read<AuthProvider>().logout();
    }
  }
}