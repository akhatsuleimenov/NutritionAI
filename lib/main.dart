// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:bytes/app/routes.dart';
import 'package:bytes/core/auth/auth_wrapper.dart';
import 'package:bytes/core/themes/app_theme.dart';
import 'package:bytes/features/dashboard/controllers/dashboard_controller.dart';
import 'core/firebase_options.dart';

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
        title: 'bites.',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (_) => AuthWrapper());
          }
          return AppRoutes.onGenerateRoute(settings);
        },
      ),
    );
  }
}
