import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_testing_lab/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full registration flow on real device', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Fill in registration fields
    await tester.enterText(find.byKey(const Key('nameField')), 'Ahmed Samy');
    await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'Pass@1234');
    await tester.enterText(find.byKey(const Key('confirmPasswordField')), 'Pass@1234');

    await tester.pumpAndSettle();

    // ✅ Scroll to make the register button visible
    await tester.ensureVisible(find.byKey(const Key('registerButton')));

    // Tap the Register button
    await tester.tap(find.byKey(const Key('registerButton')));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify success message
    expect(find.byKey(const Key('successMessage')), findsOneWidget);
    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
