import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_ai/app/routes.dart';
import 'package:nutrition_ai/core/auth/auth_wrapper.dart';
import 'package:nutrition_ai/core/themes/app_theme.dart';
import 'package:nutrition_ai/features/dashboard/controllers/dashboard_controller.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardController(),
      child: MaterialApp(
        title: 'NutritionAI',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (_) => const AuthWrapper());
          }
          return AppRoutes.onGenerateRoute(settings);
        },
      ),
    );
  }
}
