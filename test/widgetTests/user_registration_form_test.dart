import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';
import 'package:mocktail/mocktail.dart';

// Mock the onSubmit callback
class MockOnSubmit extends Mock {
  Future<void> call();
}

void main() {
  late MockOnSubmit mockOnSubmit;

  setUp(() {
    mockOnSubmit = MockOnSubmit();
  });

  Future<void> _pumpForm(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: UserRegistrationForm(onSubmit: mockOnSubmit)),
      ),
    );
  }

  testWidgets('shows error SnackBar when form is empty', (tester) async {
    await _pumpForm(tester);

    await tester.tap(find.text('Register'));
    await tester.pump(); // start animation
    await tester.pump(const Duration(seconds: 2)); // SnackBar duration

    expect(
      find.text('❌ Please correct the errors in the form.'),
      findsOneWidget,
    );
  });

  testWidgets('submits successfully and shows success SnackBar', (
    tester,
  ) async {
    when(() => mockOnSubmit()).thenAnswer((_) async {});

    await _pumpForm(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'john@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'Passw0rd#');
    await tester.enterText(find.byType(TextFormField).at(3), 'Passw0rd#');

    await tester.tap(find.text('Register'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3)); // Wait for SnackBar

    verify(() => mockOnSubmit()).called(1);
    expect(find.text('✅ Registration successful!'), findsOneWidget);
  });

  testWidgets('shows failure SnackBar when onSubmit throws', (tester) async {
    when(() => mockOnSubmit()).thenThrow(Exception('Network error'));

    await _pumpForm(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'john@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'Passw0rd#');
    await tester.enterText(find.byType(TextFormField).at(3), 'Passw0rd#');

    await tester.tap(find.text('Register'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    verify(() => mockOnSubmit()).called(1);
    expect(find.textContaining('❌ Registration failed:'), findsOneWidget);
  });
}
