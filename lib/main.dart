// Flutter imports:
// import 'package:bites/core/services/revenue_cat_service.dart';
import 'package:bites/core/services/revenue_cat_service.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:bites/app/routes.dart';
import 'package:bites/core/auth/auth_wrapper.dart';
import 'package:bites/core/controllers/app_controller.dart';
import 'package:bites/core/controllers/subscription_controller.dart';
import 'package:bites/core/services/auth_service.dart';
import 'package:bites/core/themes/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await RevenueCatService.init();
  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authService),
        ChangeNotifierProvider(create: (context) => AppController(authService)),
        ChangeNotifierProvider(create: (context) => SubscriptionController()),
      ],
      child: const BitesApp(),
    ),
  );
}

class BitesApp extends StatelessWidget {
  const BitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bites.',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
