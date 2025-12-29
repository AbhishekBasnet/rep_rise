import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/domain/usecase/auth/check_auth_status_usecase.dart';
import 'package:rep_rise/domain/usecase/auth/login_usecase.dart';
import 'package:rep_rise/domain/usecase/auth/logout_usecase.dart';
import 'package:rep_rise/presentation/provider/auth_provider.dart';
import 'package:rep_rise/presentation/screens/auth/login_screen.dart';
import 'package:rep_rise/presentation/screens/main_screen.dart';
import 'package:rep_rise/presentation/screens/root_wrapper.dart';

import 'core/di/injection_container.dart.dart';
import 'core/network/api_client.dart';
import 'core/services/expired_token_login_navigation.dart';
import 'core/services/token_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecase/auth/register_usecase.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Rep Rise',
  //     navigatorKey: NavigationService.navigatorKey,
  //     initialRoute: '/register_new_user_screen',
  //     routes: {
  //       '/': (context) => const MainScreen(),
  //       '/register_new_user_screen': (context) => const RegisterNewUserScreen(),
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      home: const RootWrapper(),
      routes: {'/login_screen': (context) => const LoginScreen(), '/main': (context) => const MainScreen()},
    );
  }
}
