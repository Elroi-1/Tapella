import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/core/widgets/app_scaffold.dart';
import 'package:tapella/core/widgets/glass_card.dart';
import 'package:tapella/core/widgets/primary_button.dart';
import 'package:tapella/core/widgets/secondary_button.dart';
import 'package:tapella/core/widgets/text_field.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class ClientSignupScreen extends ConsumerStatefulWidget {
  const ClientSignupScreen({super.key});

  @override
  ConsumerState<ClientSignupScreen> createState() => _ClientSignupScreenState();
}

class _ClientSignupScreenState extends ConsumerState<ClientSignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    final ok = await ref
        .read(authProvider.notifier)
        .register(
          email: _email.text.trim(),
          password: _password.text,
          displayName: _name.text.trim(),
          isProvider: false,
        );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(authProvider).error ?? 'Signup failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return AppScaffold(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Create Account',
              style: AppTextStyles.displayLgBold.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Find. Book. Done.',
              style: AppTextStyles.titleSm.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Connect with top-rated local professionals in seconds.',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up',
                    style: AppTextStyles.titleSm.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _name,
                    label: 'Full Name',
                    hintText: 'Jane Doe',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _email,
                    label: 'Email',
                    hintText: 'name@email.com',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _password,
                    label: 'Password',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _confirm,
                    label: 'Confirm Password',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Sign Up',
                    height: 56,
                    width: 277,
                    fill: AppColors.primaryBlue,
                    onPressed: _signup,
                    isLoading: auth.isSubmitting,
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Back to Login',
                    onPressed: () => context.go('/client/login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
