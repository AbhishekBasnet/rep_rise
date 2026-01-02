import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile_screen.dart';

import '../../../core/theme/app_theme.dart';
import '../../provider/auth_provider.dart';

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({super.key});

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  void _profileSetup(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfileScreen()));
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),


      ),
      body:  SafeArea(child: Column(

        children: [
          Text('Profile Home Screen'),
          ElevatedButton(onPressed: _profileSetup, child: Text('Setup Profile'))
        ],
      )),
    );
  }
}
