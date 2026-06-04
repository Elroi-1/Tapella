import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapella/features/auth/presentation/providers/auth_provider.dart';
import 'package:tapella/features/auth/presentation/screens/client_login.dart';

void main() {
  testWidgets('ClientLoginScreen shows login heading and buttons', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authProvider.overrideWithValue(const AuthState())],
        child: MaterialApp(home: const ClientLoginScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Welcome to Tapella.'), findsOneWidget);
    expect(find.text('Find. Book. Done.'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Business'), findsOneWidget);
  });
}
