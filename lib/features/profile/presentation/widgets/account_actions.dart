import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/core/widgets/confirm_dialog.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';

Future<void> handleLogout(
  BuildContext context,
  WidgetRef ref, {
  required bool isProvider,
}) async {
  await ref.read(authProvider.notifier).logout();
  if (context.mounted) {
    context.go(isProvider ? '/business/login' : '/client/login');
  }
}

Future<void> handleDeleteAccount(
  BuildContext context,
  WidgetRef ref, {
  required bool isProvider,
}) async {
  final confirmed = await showConfirmDialog(
    context,
    title: 'Delete Account',
    message:
        'This permanently deletes your account and all associated data. This cannot be undone.',
    confirmLabel: 'Delete Account',
    isDestructive: true,
  );
  if (!confirmed || !context.mounted) return;

  final ok = await ref.read(authProvider.notifier).deleteAccount();
  if (!context.mounted) return;

  if (ok) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted successfully')),
    );
    context.go(isProvider ? '/business/signup' : '/client/signup');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ref.read(authProvider).error ?? 'Could not delete account',
        ),
      ),
    );
  }
}
