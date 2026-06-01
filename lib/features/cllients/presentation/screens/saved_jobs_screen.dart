import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tapella/core/widgets/app_bar.dart';
import 'package:tapella/core/widgets/app_scaffold.dart';
import 'package:tapella/core/widgets/bottom_navbar.dart';
import 'package:tapella/core/widgets/service_card.dart';
import 'package:tapella/features/services/presentation/providers/listings_provider.dart';
import 'package:tapella/features/cllients/presentation/providers/saved_listings_provider.dart';

class SavedJobsScreen extends ConsumerWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedIds = ref.watch(savedListingsProvider);
    final listingsState = ref.watch(listingsProvider);

    // Filter available listings by saved IDs
    final savedListings = listingsState.listings
        .where((l) => savedIds.contains(l.id))
        .toList();

    return AppScaffold(
      extendBody: true,
      appBar: CustomAppBar(
        title: 'SAVED SERVICES',
        onMenuPressed: () => context.go('/client/profile'),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            if (savedListings.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Text(
                    'No saved services yet',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            else
              ...savedListings.map((listing) {
                return ServiceCard(
                  name: listing.providerName,
                  location: listing.location,
                  role: listing.title,
                  rating: listing.ratingAvg,
                  description: listing.description,
                  phone: listing.phone,
                  isSaved: true,
                  onCardTap: () => context.go('/service/detail/${listing.id}'),
                  onSaveToggle: () {
                    ref
                        .read(savedListingsProvider.notifier)
                        .toggleSave(listing.id);
                  },
                  onBookNow: () => context.go('/service/detail/${listing.id}'),
                  onCall: listing.phone.isNotEmpty
                      ? () async {
                          final Uri url = Uri.parse('tel:${listing.phone}');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        }
                      : null,
                );
              }),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Highlight profile tab as it's a sub-section
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
