// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rep_rise/core/theme/app_theme.dart';
// import 'package:rep_rise/presentation/provider/auth/auth_provider.dart';
// import 'package:rep_rise/presentation/provider/profile/profile_provider.dart';
//
// class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const MainAppBar({super.key});
//
//   @override
//   Size get preferredSize => const Size.fromHeight(70);
//
//   @override
//   Widget build(BuildContext context) {
//     // We listen to ProfileProvider to get the latest data (from your JSON)
//     return Consumer<ProfileProvider>(
//       builder: (context, profileProvider, child) {
//         // Accessing the data based on your JSON structure
//         final user = profileProvider.userProfile;
//         final username = user?.username ?? "Abhishek"; // Fallback if null
//         // If your model has a 'profile' nested object for stats:
//         final stats = user?.profile;
//
//         return AppBar(
//           backgroundColor: AppTheme.appBackgroundColor,
//           elevation: 0,
//           toolbarHeight: 70,
//           title: Row(
//             children: [
//               // 1. Persistent Avatar (Triggers the Sheet)
//               GestureDetector(
//                 onTap: () => _showModernProfileSheet(context, user),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: AppTheme.primaryPurple, width: 2),
//                   ),
//                   child: const CircleAvatar(
//                     radius: 20,
//                     backgroundImage: AssetImage('assets/images/user_placeholder.png'),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//
//               // 2. Greeting Text
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Hello, ${username}!", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
//                   Text("Let's crush your goals.", style: Theme.of(context).textTheme.bodySmall),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             // Quick Logout Icon (Optional, since it's also in the sheet now)
//             IconButton(
//               onPressed: () => _handleLogout(context),
//               icon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 5)],
//                 ),
//                 child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
//               ),
//             ),
//             const SizedBox(width: 15),
//           ],
//         );
//       },
//     );
//   }
//
//   // --- The Modern Bottom Sheet ---
//   void _showModernProfileSheet(BuildContext context, dynamic user) {
//     // Extracting data from your JSON structure
//     final email = user?.email ?? "1@1.com";
//     final username = user?.username ?? "Abhishek";
//     // Adjust these getters based on your actual Model class field names
//     final height = user?.profile?.height?.toString() ?? "--";
//     final weight = user?.profile?.weight?.toString() ?? "--";
//     final age = user?.profile?.age?.toString() ?? "--";
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // Allows sheet to be taller if needed
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       backgroundColor: Colors.white,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Drag Handle
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
//                 ),
//               ),
//
//               // User Header
//               Row(
//                 children: [
//                   const CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/images/user_placeholder.png')),
//                   const SizedBox(width: 15),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       Text(email, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
//                     ],
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // Stats Row (Height | Weight | Age)
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: AppTheme.appBackgroundColor, // Using your subtle background
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildStatItem("Height", "$height cm"),
//                     _buildVerticalDivider(),
//                     _buildStatItem("Weight", "$weight kg"),
//                     _buildVerticalDivider(),
//                     _buildStatItem("Age", "$age yo"),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               // Menu Options
//               _buildMenuOption(
//                 icon: Icons.person_outline,
//                 title: "My Profile",
//                 onTap: () {
//                   Navigator.pop(context);
//                   // TODO: Navigate to full profile edit screen
//                 },
//               ),
//
//               // THE NEW SETTINGS BUTTON
//               _buildMenuOption(
//                 icon: Icons.settings_outlined,
//                 title: "Settings",
//                 onTap: () {
//                   Navigator.pop(context);
//                   // TODO: Navigate to Settings Page
//                 },
//               ),
//
//               const Divider(height: 30),
//
//               _buildMenuOption(
//                 icon: Icons.logout,
//                 title: "Log Out",
//                 isDestructive: true,
//                 onTap: () {
//                   Navigator.pop(context);
//                   _handleLogout(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Helper for Stats
//   Widget _buildStatItem(String label, String value) {
//     return Column(
//       children: [
//         Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 4),
//         Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//       ],
//     );
//   }
//
//   Widget _buildVerticalDivider() {
//     return Container(height: 30, width: 1, color: Colors.grey[300]);
//   }
//
//   // Helper for Menu Options
//   Widget _buildMenuOption({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool isDestructive = false,
//   }) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(color: isDestructive ? Colors.red[50] : Colors.grey[100], shape: BoxShape.circle),
//         child: Icon(icon, color: isDestructive ? Colors.red : AppTheme.primaryPurple, size: 20),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : Colors.black87),
//       ),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//       onTap: onTap,
//     );
//   }
//
//   // Standard Logout Logic
//   Future<void> _handleLogout(BuildContext context) async {
//     final shouldLogout = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to log out?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//
//     if (shouldLogout == true && context.mounted) {
//       final authProvider = context.read<AuthProvider>();
//       await authProvider.logout();
//     }
//   }
// }
