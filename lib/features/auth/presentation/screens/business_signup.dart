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
import '../../../../../core/models/listing_model.dart';
import '../providers/auth_provider.dart';

class BusinessSignupScreen extends ConsumerStatefulWidget {
  const BusinessSignupScreen({super.key});

  @override
  ConsumerState<BusinessSignupScreen> createState() =>
      _BusinessSignupScreenState();
}

class _BusinessSignupScreenState extends ConsumerState<BusinessSignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String? _selectedProfession = appCategories.first;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final ok = await ref
        .read(authProvider.notifier)
        .register(
          email: _email.text.trim(),
          password: _password.text,
          displayName: _name.text.trim(),
          isProvider: true,
          phone: _phone.text.trim(),
          profession: _selectedProfession,
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
              'Create Business Account',
              style: AppTextStyles.displayLgBold.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'List services, manage requests, and grow.',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business Details',
                    style: AppTextStyles.titleSm.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _name,
                    label: 'Business Name',
                    hintText: 'Tapella Services',
                    prefixIcon: Icons.storefront,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _email,
                    label: 'Email',
                    hintText: 'business@email.com',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _phone,
                    label: 'Phone',
                    hintText: '+251 911 000 000',
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedProfession,
                    dropdownColor: const Color(0xFF151E3D),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Profession',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.work_outline,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF151E3D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: appCategories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedProfession = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _password,
                    label: 'Password',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    width: 277,
                    height: 56,
                    fill: AppColors.primaryBlue,
                    label: 'Create Account',
                    onPressed: _signup,
                    isLoading: auth.isSubmitting,
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Back to Login',
                    onPressed: () => context.go('/business/login'),
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
