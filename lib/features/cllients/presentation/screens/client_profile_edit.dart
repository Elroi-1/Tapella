import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/core/theme/app_colors.dart';
import 'package:tapella/core/theme/app_spacing.dart';
import 'package:tapella/core/theme/app_text_styles.dart';
import 'package:tapella/core/widgets/app_bar.dart';
import 'package:tapella/core/widgets/app_scaffold.dart';
import 'package:tapella/core/widgets/bottom_navbar.dart';
import 'package:tapella/core/widgets/primary_button.dart';
import 'package:tapella/core/widgets/profile_avatar.dart';
import 'package:tapella/core/widgets/red_button.dart';
import 'package:tapella/core/widgets/text_field.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';
import 'package:tapella/features/profile/data/profile_repository.dart';
import 'package:tapella/features/profile/presentation/widgets/account_actions.dart';

class ClientProfileEdit extends ConsumerStatefulWidget {
  const ClientProfileEdit({super.key});

  @override
  ConsumerState<ClientProfileEdit> createState() => _ClientProfileEditState();
}

class _ClientProfileEditState extends ConsumerState<ClientProfileEdit> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _location;
  late final TextEditingController _bio;
  String? _profileImage;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _name = TextEditingController(text: user?.displayName ?? '');
    _email = TextEditingController(text: user?.email ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
    _location = TextEditingController(text: user?.location ?? '');
    _bio = TextEditingController(text: user?.bio ?? '');
    _profileImage = user?.profileImage;
    Future.microtask(() async {
      try {
        final fresh = await ref.read(profileRepositoryProvider).fetchProfile();
        if (mounted) {
          _name.text = fresh.displayName;
          _email.text = fresh.email;
          _phone.text = fresh.phone ?? '';
          _location.text = fresh.location ?? '';
          _bio.text = fresh.bio ?? '';
          setState(() => _profileImage = fresh.profileImage);
          ref.read(authProvider.notifier).setUser(fresh);
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _location.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await pickProfileImageBase64();
    if (image != null) setState(() => _profileImage = image);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final user = await ref
          .read(profileRepositoryProvider)
          .updateProfile(
            displayName: _name.text.trim(),
            email: _email.text.trim(),
            phone: _phone.text.trim(),
            location: _location.text.trim(),
            bio: _bio.text.trim(),
            profileImage: _profileImage,
          );
      ref.read(authProvider.notifier).setUser(user);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated')));
        context.go('/client/profile');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return AppScaffold(
      extendBody: true,
      padding: EdgeInsets.zero,
      appBar: CustomAppBar(
        onMenuPressed: () => context.go('/client/profile'),
        leading: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        actions: const [],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/client/home');
            case 1:
              context.go('/client/requests');
            case 2:
              context.go('/client/profile');
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          children: [
            ProfileAvatar(
              profileImageBase64: _profileImage,
              showEditBadge: true,
              onTap: _pickImage,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              user?.displayName ?? 'Profile',
              style: AppTextStyles.profileName,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _name,
              label: 'FULL NAME',
              hintText: 'Your name',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _email,
              label: 'EMAIL ADDRESS',
              hintText: 'name@email.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _phone,
              label: 'PHONE NUMBER',
              hintText: '+251900000000',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _location,
              label: 'LOCATION',
              hintText: 'Addis Ababa',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _bio,
              label: 'BIO',
              hintText: 'Tell providers about yourself',
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: _saving ? 'Saving...' : 'Save Changes',
              height: 56,
              width: 277,
              fill: AppColors.primaryBlue,
              isLoading: _saving,
              onPressed: _saving ? null : _save,
            ),
            const SizedBox(height: AppSpacing.lg),
            RedButton(
              label: 'Delete Account',
              height: 56,
              width: 277,
              onPressed: () =>
                  handleDeleteAccount(context, ref, isProvider: false),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
