import 'package:flutter/material.dart';


class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({super.key});

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SafeArea(
        child: Column(
          children: [
            Text('Profile Home Screen'),
            ElevatedButton(onPressed: () {}, child: Text('Setup Profile')),
          ],
        ),
      ),
    );
  }
}
