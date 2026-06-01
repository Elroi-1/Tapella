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
import 'package:tapella/core/models/listing_model.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';
import 'package:tapella/features/profile/presentation/widgets/account_actions.dart';

class ProviderEditScreen extends ConsumerStatefulWidget {
  const ProviderEditScreen({super.key});

  @override
  ConsumerState<ProviderEditScreen> createState() => _ProviderEditScreenState();
}

class _ProviderEditScreenState extends ConsumerState<ProviderEditScreen> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _location;
  late final TextEditingController _bio;
  String? _profileImage;
  String? _selectedProfession;
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

    final initialProfession = user?.profession;
    if (appCategories.contains(initialProfession)) {
      _selectedProfession = initialProfession;
    } else {
      _selectedProfession = appCategories.first;
    }

    Future.microtask(() async {
      final fresh = await ref.read(authProvider.notifier).refreshProfile();
      if (mounted && fresh != null) {
        _name.text = fresh.displayName;
        _email.text = fresh.email;
        _phone.text = fresh.phone ?? '';
        _location.text = fresh.location ?? '';
        _bio.text = fresh.bio ?? '';
        final freshProfession = fresh.profession;
        if (appCategories.contains(freshProfession)) {
          _selectedProfession = freshProfession;
        } else {
          _selectedProfession = appCategories.first;
        }
        setState(() => _profileImage = fresh.profileImage);
      }
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
      final user = await ref.read(authProvider.notifier).updateProfile(
            displayName: _name.text.trim(),
            email: _email.text.trim(),
            phone: _phone.text.trim(),
            location: _location.text.trim(),
            bio: _bio.text.trim(),
            profileImage: _profileImage,
            profession: _selectedProfession,
          );
      if (user == null) return;
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated')));
        context.go('/business/profile');
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
        onMenuPressed: () => context.go('/business/profile'),
        leading: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        actions: const [],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/business/home');
            case 1:
              context.go('/business/requests');
            case 2:
              context.go('/business/profile');
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
            const SizedBox(height: 4),
            Text('SERVICE PROVIDER', style: AppTextStyles.profileType),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _name,
              label: 'BUSINESS NAME',
              hintText: 'Your business name',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _email,
              label: 'EMAIL ADDRESS',
              hintText: 'business@email.com',
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
            DropdownButtonFormField<String>(
              initialValue: _selectedProfession,
              dropdownColor: const Color(0xFF151E3D),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'PROFESSION',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: const Icon(Icons.work_outline, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF151E3D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: appCategories.map((cat) {
                return DropdownMenuItem<String>(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedProfession = val;
                });
              },
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
              hintText: 'Describe your services',
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
                  handleDeleteAccount(context, ref, isProvider: true),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
