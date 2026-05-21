import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/core/models/booking_model.dart';
import 'package:tapella/core/theme/app_colors.dart';
import 'package:tapella/core/theme/app_text_styles.dart';
import 'package:tapella/features/bookings/presentation/providers/bookings_provider.dart';
import 'package:tapella/core/widgets/past_jobs.dart';
import 'package:tapella/core/widgets/provider_req_card.dart';
import 'package:tapella/core/widgets/new_jobs_card.dart';
import 'package:tapella/core/widgets/app_bar.dart';
import 'package:tapella/core/widgets/app_scaffold.dart';
import 'package:tapella/core/widgets/bottom_navbar.dart';
import 'package:tapella/core/widgets/profile_avatar.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';

class BusinessRequests extends ConsumerWidget {
  const BusinessRequests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(providerStatsProvider);
    final authUser = ref.watch(authProvider).user;

    return AppScaffold(
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
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
        },
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Requests',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'TRACK AND MANAGE YOUR SERVICE ORDERS',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: statsAsync.when(
                data: (stats) => _buildTabs(context, ref, stats),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context, WidgetRef ref, ProviderStats stats) {
    final incoming = stats.pendingBookings
        .where((b) => b.status == 'pending')
        .toList();
    final accepted = stats.pendingBookings
        .where((b) => b.status == 'accepted')
        .toList();
    final past = stats.completedBookings;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelStyle: AppTextStyles.cardTitle.copyWith(fontSize: 14),
            unselectedLabelStyle: AppTextStyles.cardSub.copyWith(fontSize: 14),
            indicatorColor: AppColors.primaryBlue,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: const [
              Tab(text: "Incoming"),
              Tab(text: "Past Jobs"),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              children: [
                _buildIncomingList(context, ref, incoming, accepted),
                _buildPastJobsList(context, ref, past),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomingList(
    BuildContext context,
    WidgetRef ref,
    List<BookingModel> incoming,
    List<BookingModel> accepted,
  ) {
    final allActive = [...incoming, ...accepted];
    if (allActive.isEmpty) {
      return const Center(
        child: Text(
          "No incoming requests",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: allActive.length,
      itemBuilder: (context, index) {
        final booking = allActive[index];
        if (booking.status == 'accepted') {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BusinessReqCard(
              name: booking.customerName,
              profileImage: booking.customerPhoto,
              status: booking.status,
              proffession: booking.listingTitle,
              dateTime:
                  DateTime.tryParse(booking.scheduledDate ?? '') ??
                  DateTime.now(),
              location: 'Addis Ababa',
              category: 'Service',
              onComplete: (amount) async {
                try {
                  await ref
                      .read(bookingActionsProvider)
                      .complete(booking.id, amount: amount);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Job marked as completed'),
                        ),
                      );
                    }
                  });
                } catch (e) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error completing job: $e')),
                      );
                    }
                  });
                }
              },
              onDelete: () async {
                try {
                  await ref.read(bookingActionsProvider).reject(booking.id);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Job removed')),
                      );
                    }
                  });
                } catch (e) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  });
                }
              },
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NewJob(
            name: booking.customerName,
            profileImage: booking.customerPhoto,
            status: booking.status,
            proffession: booking.listingTitle,
            dateTime:
                DateTime.tryParse(booking.scheduledDate ?? '') ??
                DateTime.now(),
            location: 'Addis Ababa',
            category: 'Service',
            onAccept: () async {
              try {
                await ref.read(bookingActionsProvider).accept(booking.id);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Job accepted')),
                    );
                  }
                });
              } catch (e) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                });
              }
            },
            onReject: () async {
              try {
                await ref.read(bookingActionsProvider).reject(booking.id);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Job rejected')),
                    );
                  }
                });
              } catch (e) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                });
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildPastJobsList(
    BuildContext context,
    WidgetRef ref,
    List<BookingModel> past,
  ) {
    if (past.isEmpty) {
      return const Center(
        child: Text("No past jobs", style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: past.length,
      itemBuilder: (context, index) {
        final booking = past[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PastJob(
            name: booking.customerName,
            profileImage: booking.customerPhoto,
            status: booking.status,
            proffession: booking.listingTitle,
            dateTime:
                DateTime.tryParse(booking.scheduledDate ?? '') ??
                DateTime.now(),
            location: 'Addis Ababa',
            category: 'Service',
            money: booking.amountEtb,
          ),
        );
      },
    );
  }
}
