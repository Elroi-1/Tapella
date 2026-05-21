import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/core/theme/app_colors.dart';
import 'package:tapella/core/widgets/app_bar.dart';
import 'package:tapella/core/widgets/app_scaffold.dart';
import 'package:tapella/core/widgets/bottom_navbar.dart';
import 'package:tapella/core/widgets/confirm_dialog.dart';
import 'package:tapella/core/widgets/primary_button.dart';
import 'package:tapella/core/widgets/provider_card.dart';
import 'package:tapella/core/widgets/provider_req_card.dart';
import 'package:tapella/core/widgets/stat_card.dart';
import 'package:tapella/core/widgets/tab_selector.dart';
import 'package:tapella/features/bookings/presentation/providers/bookings_provider.dart';

import 'package:tapella/core/widgets/profile_avatar.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';

class BusinessHome extends ConsumerStatefulWidget {
  const BusinessHome({super.key});

  @override
  ConsumerState<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends ConsumerState<BusinessHome> {
  final int _currentIndex = 0;
  String selectedTab = 'All';

  Future<void> _completeJob(String bookingId, double? amount) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Finish Job',
      message:
          'Are you sure you want to finish this job and mark it as completed?',
      confirmLabel: 'Finish Job',
    );
    if (!confirmed) return;
    try {
      await ref
          .read(bookingActionsProvider)
          .complete(bookingId, amount: amount);
      ref.invalidate(historyBookingsProvider);
      ref.invalidate(providerStatsProvider);
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Job marked as completed')),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error completing job: $e')));
          }
        });
      }
    }
  }

  Future<void> _deleteJob(String bookingId) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete/Reject Job',
      message:
          'Are you sure you want to reject this job? This will cancel the booking on the client side.',
      confirmLabel: 'Delete Job',
      isDestructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(bookingActionsProvider).reject(bookingId);
      ref.invalidate(historyBookingsProvider);
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Job rejected and deleted')),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error rejecting job: $e')));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(historyBookingsProvider);
    final statsAsync = ref.watch(providerStatsProvider);
    final authUser = ref.watch(authProvider).user;

    return AppScaffold(
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onItemTapped(index),
      ),
      appBar: CustomAppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: IconButton(
              onPressed: () => context.go("/business/profile"),
              icon: ProfileAvatar(
                profileImageBase64: authUser?.profileImage,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            statsAsync.when(
              data: (stats) => ProviderCard(
                title: "Account Status",
                subtitle: "● Active Provider",
                row1: [
                  StatCard(
                    value: stats.averageRating > 0
                        ? stats.averageRating.toStringAsFixed(1)
                        : "N/A",
                    label: "RATING",
                  ),
                  StatCard(value: stats.totalJobs.toString(), label: "JOBS"),
                ],
                row2: [
                  const StatIconCard(
                    icon: Icon(Icons.verified, color: Colors.white),
                    label: "VERIFIED",
                  ),
                  StatCard(
                    value: "ETB ${stats.totalEarnings.toStringAsFixed(0)}",
                    label: "INCOME",
                  ),
                ],
              ),
              loading: () => const ProviderCard(
                title: "Account Status",
                subtitle: "● Active Provider",
                row1: [
                  StatCard(value: "...", label: "RATING"),
                  StatCard(value: "...", label: "JOBS"),
                ],
                row2: [
                  StatIconCard(
                    icon: Icon(Icons.verified, color: Colors.white),
                    label: "VERIFIED",
                  ),
                  StatCard(value: "...", label: "INCOME"),
                ],
              ),
              error: (err, _) => ProviderCard(
                title: "Account Status",
                subtitle: "Error loading stats",
                row1: [
                  const StatCard(value: "!", label: "RATING"),
                  const StatCard(value: "!", label: "JOBS"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: PrimaryButton(
                label: "Add New Listing",
                height: 57,
                width: 200,
                fill: AppColors.primaryBlue,
                onPressed: () => context.go("/business/new-listing"),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Past Jobs",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TabSelector(
              selectedTab: selectedTab,
              tabs: const ['All', 'Accepted', 'Cancelled', 'Rejected'],
              onTabChanged: (tab) => setState(() => selectedTab = tab),
            ),
            const SizedBox(height: 16),
            bookingsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
              data: (bookings) {
                final filtered = bookings.where((b) {
                  if (selectedTab == 'Accepted') {
                    return b.status == 'accepted' || b.status == 'completed';
                  } else if (selectedTab == 'Cancelled') {
                    return b.status == 'cancelled';
                  } else if (selectedTab == 'Rejected') {
                    return b.status == 'rejected';
                  }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'No bookings found in this category',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final b = filtered[index];
                    return BusinessReqCard(
                      name: b.customerName,
                      status: b.status,
                      proffession: b.listingTitle,
                      dateTime:
                          DateTime.tryParse(b.scheduledDate ?? '') ??
                          DateTime.now(),
                      location: 'Addis Ababa',
                      category: 'Service',
                      money: b.amountEtb.toDouble(),
                      onComplete: b.status == 'accepted'
                          ? (amount) => _completeJob(b.id, amount)
                          : null,
                      onDelete: b.status == 'accepted'
                          ? () => _deleteJob(b.id)
                          : null,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/business/home');
        break;
      case 1:
        context.go('/business/requests');
        break;
      case 2:
        context.go('/business/profile');
        break;
    }
  }
}
