import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/auth_provider.dart';
import 'package:rep_rise/presentation/screens/main_screen.dart';

import 'core/network/api_client.dart';
import 'core/services/token_service.dart';
import 'data/repositories/auth_repository_impl.dart';

void main() {
  final tokenService = TokenService();
  final apiClient = ApiClient(tokenService);
  final authRepository = AuthRepositoryImpl(apiClient, tokenService);


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository: authRepository),
        ),
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
      routes: {
        '/': (context) => const MainScreen(),
      },
    );
  }
}