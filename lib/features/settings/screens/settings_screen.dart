// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:bites/core/widgets/buttons.dart';
import 'package:bites/core/widgets/cards.dart';
import 'package:bites/core/services/auth_service.dart';
import 'package:bites/features/dashboard/controllers/dashboard_controller.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: const CustomBackButton(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SettingsCard(
                  title: 'Edit Profile',
                  icon: Icons.person,
                  onTap: () =>
                      Navigator.pushNamed(context, '/settings/edit-profile'),
                ),
                const SizedBox(height: 12),
                SettingsCard(
                  title: 'Update Goals',
                  icon: Icons.track_changes,
                  onTap: () => Navigator.pushNamed(context, '/settings/goals'),
                ),
                const SizedBox(height: 12),
                SettingsCard(
                  title: 'Help & Support',
                  icon: Icons.help_outline,
                  onTap: () =>
                      Navigator.pushNamed(context, '/settings/support'),
                ),
                const SizedBox(height: 12),
                SettingsCard(
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip_outlined,
                  onTap: () =>
                      Navigator.pushNamed(context, '/settings/privacy'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SettingsCard(
              title: 'Sign Out',
              icon: Icons.logout,
              onTap: () async {
                print('Starting sign out process');
                Provider.of<DashboardController>(context, listen: false)
                    .dispose();
                print('DashboardController disposed');

                if (!context.mounted) return;

                print('Navigating to login screen');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );

                print('About to sign out');
                final authService = AuthService();
                await authService.signOut();
                print('Sign out completed');
              },
              textColor: Colors.red.shade900,
              iconColor: Colors.red.shade900,
              isTrailingIcon: false,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
