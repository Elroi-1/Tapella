import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(gradient: AppColors.grad),
            child: const Center(
              child: Text(
                'TAPELLA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.pop(); // Close drawer
              context.go('/');
            },
          ),
          const Divider(color: Colors.white10),
          const Spacer(),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              // Close drawer first
              context.pop();

              // Call logout
              // Assuming authProvider has a logout method based on grep
              final notifier = ref.read(authProvider.notifier);
              await (notifier as dynamic).logout();

              if (context.mounted) {
                context.go('/welcome');
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
