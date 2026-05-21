import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/core/theme/app_colors.dart';
import 'package:tapella/core/theme/app_spacing.dart';
import 'package:tapella/core/theme/app_text_styles.dart';
import 'package:tapella/core/widgets/app_bar.dart';
import 'package:tapella/core/widgets/app_scaffold.dart';
import 'package:tapella/core/widgets/bottom_navbar.dart';
import 'package:tapella/core/widgets/glass_card.dart';
import 'package:tapella/core/widgets/primary_button.dart';
import 'package:tapella/core/widgets/profile_avatar.dart';
import 'package:tapella/core/widgets/red_button.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';
import 'package:tapella/features/profile/presentation/widgets/account_actions.dart';
import 'package:tapella/features/services/presentation/providers/listings_provider.dart';

class BusinessProfile extends ConsumerStatefulWidget {
  const BusinessProfile({super.key});

  @override
  ConsumerState<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends ConsumerState<BusinessProfile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authProvider.notifier).refreshProfile());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    final myListings = ref.watch(myListingsProvider);

    return AppScaffold(
      extendBody: true,
      padding: EdgeInsets.zero,
      appBar: CustomAppBar(
        leading: const Icon(Icons.menu_rounded, color: AppColors.textWhite),
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
            const SizedBox(height: AppSpacing.md),
            Text('Account Settings', style: AppTextStyles.profileHeader),
            const SizedBox(height: 4),
            Text(
              'Manage your profile and preferences',
              style: AppTextStyles.profileSubHeader,
            ),
            const SizedBox(height: 16),
            ProfileAvatar(profileImageBase64: user?.profileImage),
            Text(user?.displayName ?? '—', style: AppTextStyles.profileName),
            if (user?.profession != null) ...[
              const SizedBox(height: 4),
              Text(
                user!.profession!.toUpperCase(),
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(user?.email ?? '', style: AppTextStyles.bodySm),
            const SizedBox(height: 24),
            Text('My Services', style: AppTextStyles.profileHeader),
            const SizedBox(height: 16),
            myListings.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('$e'),
              data: (listings) {
                if (listings.isEmpty) {
                  return const Text(
                    'No listings yet',
                    style: TextStyle(color: Colors.grey),
                  );
                }
                return Column(
                  children: listings.map((l) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        child: ListTile(
                          title: Text(
                            l.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${l.category} • ★ ${l.ratingAvg.toStringAsFixed(1)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.white54,
                          ),
                          onTap: () =>
                              context.go('/business/listing/edit/${l.id}'),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'New Listing',
              height: 56,
              width: 277,
              fill: AppColors.primaryBlue,
              onPressed: () => context.go('/business/new-listing'),
            ),
            const SizedBox(height: 16),
            _ProfileMenuCard(
              icon: Icons.person_outline,
              title: 'Personal Information',
              subtitle: 'Name, email, and bio',
              onTap: () => context.go('/business/profile-edit'),
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: 'Log Out',
              height: 56,
              width: 277,
              fill: AppColors.primaryBlue,
              onPressed: () => handleLogout(context, ref, isProvider: true),
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

class _ProfileMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryTint.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primaryTint, size: 22),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.cardSub),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
