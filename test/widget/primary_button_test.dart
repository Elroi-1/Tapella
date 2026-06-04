import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapella/core/widgets/primary_button.dart';

void main() {
  testWidgets('PrimaryButton renders label and responds to taps', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Test Button',
            onPressed: () => tapped = true,
            height: 56,
            width: 200,
            fill: Colors.blue,
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
    expect(tapped, isFalse);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
