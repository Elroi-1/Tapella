import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/core/widgets/app_bar.dart';
import 'package:tapella/core/widgets/app_scaffold.dart';
import 'package:tapella/core/widgets/confirm_dialog.dart';
import 'package:tapella/core/widgets/tab_selector.dart';
import 'package:tapella/features/bookings/presentation/providers/bookings_provider.dart';
import '../../../../core/widgets/client_request_card.dart';
import '../../../../core/widgets/bottom_navbar.dart';

import 'package:tapella/core/widgets/profile_avatar.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';

class ClientRequestpage extends ConsumerStatefulWidget {
  const ClientRequestpage({super.key});

  @override
  ConsumerState<ClientRequestpage> createState() => _ClientRequestpageState();
}

class _ClientRequestpageState extends ConsumerState<ClientRequestpage> {
  String selectedTab = 'All';

  Future<void> _cancelBooking(String bookingId) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Cancel Request',
      message: 'Are you sure you want to cancel this service request?',
      confirmLabel: 'Cancel Request',
      isDestructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(bookingActionsProvider).cancel(bookingId);
      // Logic removed here as it is handled by the provider
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(customerBookingsProvider);
    // Explicitly watch the actions provider to prevent disposal during async operations
    ref.watch(bookingActionsProvider);
    final authUser = ref.watch(authProvider).user;

    return AppScaffold(
      extendBody: true,
      appBar: CustomAppBar(
        actions: [
          IconButton(
            onPressed: () => context.go('/client/profile'),
            icon: ProfileAvatar(
              profileImageBase64: authUser?.profileImage,
              size: 32,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Requests',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'TRACK AND MANAGE YOUR SERVICE ORDERS',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  letterSpacing: 0.35,
                ),
              ),
              const SizedBox(height: 16),
              TabSelector(
                selectedTab: selectedTab,
                onTabChanged: (tab) => setState(() => selectedTab = tab),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: bookingsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Text(
                      '$e',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  data: (bookings) {
                    final filtered = selectedTab == 'All'
                        ? bookings
                        : bookings.where((b) {
                            if (selectedTab == 'Rejected') {
                              return b.status == 'rejected' ||
                                  b.status == 'cancelled';
                            }
                            if (selectedTab == 'Completed') {
                              return b.status == 'completed';
                            }
                            return b.status == selectedTab.toLowerCase();
                          }).toList();
                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          'No requests',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        final b = filtered[index];
                        return RequestCard(
                          name: b.providerName,
                          profileImage: b.providerPhoto,
                          status: b.status,
                          proffession: b.listingTitle,
                          dateTime:
                              DateTime.tryParse(b.scheduledDate ?? '') ??
                              DateTime.now(),
                          location: 'Addis Ababa',
                          onTap: () =>
                              context.go('/service/detail/${b.listingId}'),
                          onCancel: b.status == 'pending'
                              ? () => _cancelBooking(b.id)
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
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
    );
  }
}
