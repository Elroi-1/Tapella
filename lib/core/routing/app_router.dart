import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';
import 'package:tapella/features/cllients/presentation/screens/client_profile.dart';
import 'package:tapella/features/cllients/presentation/screens/client_profile_edit.dart';
import 'package:tapella/features/cllients/presentation/screens/client_requestpage.dart';
import 'package:tapella/features/cllients/presentation/screens/client_homepage.dart';
import 'package:tapella/features/cllients/presentation/screens/saved_jobs_screen.dart';
import 'package:tapella/features/services/presentation/screens/edit_listing.dart';
import '../../features/screens.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  // Only rebuild router when auth identity changes — not during submit loading.
  ref.watch(
    authProvider.select((s) => (s.initialized, s.user?.id, s.user?.role)),
  );
  final auth = ref.read(authProvider);

  return GoRouter(
    initialLocation: '/client/login',
    redirect: (context, state) {
      if (!auth.initialized) return null;

      final path = state.matchedLocation;
      final isAuthRoute =
          path.contains('/login') ||
          path.contains('/signup') ||
          path.contains('/forgot-password');

      if (!auth.isAuthenticated && !isAuthRoute && path != '/') {
        if (path.startsWith('/business')) return '/business/login';
        return '/client/login';
      }

      if (auth.isAuthenticated && isAuthRoute) {
        if (auth.user!.isProvider) return '/business/home';
        return '/client/home';
      }

      if (auth.isAuthenticated) {
        if (auth.user!.isCustomer && path.startsWith('/business')) {
          return '/client/home';
        }
        if (auth.user!.isProvider && path.startsWith('/client')) {
          return '/business/home';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/client/login'),
      GoRoute(
        path: '/client/login',
        builder: (context, state) => const ClientLoginScreen(),
      ),
      GoRoute(
        path: '/client/forgot-password',
        builder: (context, state) => const PlaceHolderScreen(),
      ),
      GoRoute(
        path: '/client/signup',
        builder: (context, state) => const ClientSignupScreen(),
      ),
      GoRoute(
        path: '/client/home',
        builder: (context, state) => const ClientHomePage(),
      ),
      GoRoute(
        path: '/client/requests',
        builder: (context, state) => const ClientRequestpage(),
      ),
      GoRoute(
        path: '/client/requests/service',
        builder: (context, state) => const PlaceHolderScreen(),
      ),
      GoRoute(
        path: '/client/profile',
        builder: (context, state) => const ClientProfile(),
      ),
      GoRoute(
        path: '/client/profile/edit',
        builder: (context, state) => const ClientProfileEdit(),
      ),
      GoRoute(
        path: '/client/profile/saved',
        builder: (context, state) => const SavedJobsScreen(),
      ),
      GoRoute(
        path: '/business/login',
        builder: (context, state) => const BusinessLoginScreen(),
      ),
      GoRoute(
        path: '/business/signup',
        builder: (context, state) => const BusinessSignupScreen(),
      ),
      GoRoute(
        path: '/business/forgot-password',
        builder: (context, state) => const PlaceHolderScreen(),
      ),
      GoRoute(
        path: '/business/home',
        builder: (context, state) => const BusinessHome(),
      ),
      GoRoute(
        path: '/business/requests',
        builder: (context, state) => const BusinessRequests(),
      ),
      GoRoute(
        path: '/business/new-listing',
        builder: (context, state) => const CreateServiceBody(),
      ),
      GoRoute(
        path: '/business/profile',
        builder: (context, state) => const BusinessProfile(),
      ),
      GoRoute(
        path: '/service/detail/:id',
        builder: (context, state) =>
            ServiceDetail(listingId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/service/detail/alt-1',
        redirect: (_, _) => '/client/home',
      ),
      GoRoute(
        path: '/service/book/alt-1',
        builder: (context, state) => const PlaceHolderScreen(),
      ),
      GoRoute(
        path: '/service/detail/alt-2',
        builder: (context, state) => const PlaceHolderScreen(),
      ),
      GoRoute(
        path: '/business/profile-edit',
        builder: (context, state) => const ProviderEditScreen(),
      ),
      GoRoute(
        path: '/business/listing/edit/:id',
        builder: (context, state) =>
            EditListingScreen(listingId: state.pathParameters['id']!),
      ),
    ],
  );
}
