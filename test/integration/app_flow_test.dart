import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapella/core/domain/cache_result.dart';
import 'package:tapella/features/auth/domain/usecases/auth_usecases.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';
import 'package:tapella/features/services/domain/usecases/listings_usecases.dart';
import 'package:tapella/features/services/presentation/providers/listings_provider.dart';
import 'package:tapella/main.dart';
import 'package:tapella/core/widgets/bottom_navbar.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/fixtures.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  late FakeAuthRepository authRepository;
  late FakeProfileRepository profileRepository;
  late FakeListingsRepository listingsRepository;

  setUp(() {
    authRepository = FakeAuthRepository();
    profileRepository = FakeProfileRepository();
    listingsRepository = FakeListingsRepository();

    // Setup auth - customer not logged in initially
    authRepository.restoreSessionResult = null;
    authRepository.loginResult = Fixtures.customer;

    // Setup listings
    listingsRepository.listingsResult = Fixtures.listingsResult();
    listingsRepository.listingByIdResult = const CacheResult(
      data: Fixtures.listing,
    );
  });

  Future<void> pumpApp(WidgetTester tester) async {
    addTearDown(() => binding.setSurfaceSize(null));
    await binding.setSurfaceSize(const Size(900, 1600));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          restoreSessionUseCaseProvider.overrideWithValue(
            RestoreSessionUseCase(authRepository),
          ),
          loginUseCaseProvider.overrideWithValue(LoginUseCase(authRepository)),
          registerUseCaseProvider.overrideWithValue(
            RegisterUseCase(authRepository),
          ),
          logoutUseCaseProvider.overrideWithValue(
            LogoutUseCase(authRepository),
          ),
          fetchProfileUseCaseProvider.overrideWithValue(
            FetchProfileUseCase(profileRepository),
          ),
          updateProfileUseCaseProvider.overrideWithValue(
            UpdateProfileUseCase(profileRepository),
          ),
          deleteAccountUseCaseProvider.overrideWithValue(
            DeleteAccountUseCase(profileRepository),
          ),
          getAllListingsUseCaseProvider.overrideWithValue(
            GetAllListingsUseCase(listingsRepository),
          ),
          getListingDetailsUseCaseProvider.overrideWithValue(
            GetListingDetailsUseCase(listingsRepository),
          ),
          getMyListingsUseCaseProvider.overrideWithValue(
            GetMyListingsUseCase(listingsRepository),
          ),
          createListingUseCaseProvider.overrideWithValue(
            CreateListingUseCase(listingsRepository),
          ),
          updateListingUseCaseProvider.overrideWithValue(
            UpdateListingUseCase(listingsRepository),
          ),
          deleteListingUseCaseProvider.overrideWithValue(
            DeleteListingUseCase(listingsRepository),
          ),
        ],
        child: const TapellaApp(),
      ),
    );
  }

  group('Customer Login and Browse Flow', () {
    testWidgets('Customer can login and view homepage', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      // Wait for app to initialize
      await tester.pumpAndSettle();

      // Should see login screen initially
      expect(find.text('Welcome to Tapella.'), findsOneWidget);

      // Enter credentials
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'name@email.com',
        ),
        'customer@tapella.test',
      );

      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.hintText == '••••••••',
        ),
        'password123',
      );

      await tester.pumpAndSettle();
      // Tap login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // After successful login, should be on homepage
      // Look for search field which is on homepage
      expect(find.text('Search services...'), findsWidgets);
    });

    testWidgets('Customer can search for services', (
      WidgetTester tester,
    ) async {
      authRepository.restoreSessionResult = Fixtures.customer;

      await pumpApp(tester);
      await tester.pumpAndSettle();

      // Should see search field
      expect(find.text('Search services...'), findsWidgets);

      // Enter search query
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Search services...',
        ),
        'plumbing',
      );

      await tester.pumpAndSettle();

      // Tap search button
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify search was performed
      expect(listingsRepository.lastSearch, 'plumbing');
    });
  });

  group('Provider Login and Create Service Flow', () {
    testWidgets('Provider can login and create service', (
      WidgetTester tester,
    ) async {
      authRepository.restoreSessionResult = null;
      authRepository.loginResult = Fixtures.provider;
      listingsRepository.createResult = Fixtures.listing;

      await pumpApp(tester);
      await tester.pumpAndSettle();

      // Should see login options
      expect(find.text('Welcome to Tapella.'), findsOneWidget);

      // Navigate to business login
      await tester.tap(find.text('Business'));
      await tester.pumpAndSettle();

      // Should be on business login now
      expect(find.text('List. Work. Earn.'), findsOneWidget);

      // Login as provider
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'business@email.com',
        ),
        'provider@tapella.test',
      );

      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.hintText == '••••••••',
        ),
        'password123',
      );

      await tester.pumpAndSettle();

      // Tap login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // After login, provider should see dashboard
      // Look for business-specific elements
      expect(find.byType(CustomBottomNavBar), findsWidgets);
    });
  });

  group('Auth State Persistence', () {
    testWidgets('App restores user session on startup', (
      WidgetTester tester,
    ) async {
      // Simulate existing session
      authRepository.restoreSessionResult = Fixtures.customer;

      await pumpApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Should not see login screen if session is restored
      // Should see homepage elements instead
      expect(find.text('Search services...'), findsWidgets);
    });

    testWidgets('App shows login when no session exists', (
      WidgetTester tester,
    ) async {
      // No existing session
      authRepository.restoreSessionResult = null;

      await pumpApp(tester);
      await tester.pumpAndSettle();

      // Should see login screen
      expect(find.text('Welcome to Tapella.'), findsOneWidget);
    });
  });
}
