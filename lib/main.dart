import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/core/theme/app_theme.dart';
import 'package:rep_rise/presentation/provider/auth/auth_provider.dart';
import 'package:rep_rise/presentation/provider/profile/register_profile_provider.dart';
import 'package:rep_rise/presentation/provider/profile/user_profile_provider.dart';
import 'package:rep_rise/presentation/provider/step_provider/step_provider.dart';
import 'package:rep_rise/presentation/screens/auth/login_screen.dart';
import 'package:rep_rise/presentation/screens/main_screen.dart';
import 'package:rep_rise/presentation/screens/root_wrapper.dart';

import 'core/di/injection_container.dart.dart';
import 'core/services/expired_token_login_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<RegisterProfileProvider>()),
        ChangeNotifierProvider(create: (_) => sl<StepProvider>()),
        ChangeNotifierProvider(create: (_) => sl<UserProfileProvider>()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      theme: AppTheme.lightTheme,
      home: const RootWrapper(),
      routes: {'/login_screen': (context) => const LoginScreen(), '/main': (context) => const MainScreen()},
    );
  }
}
