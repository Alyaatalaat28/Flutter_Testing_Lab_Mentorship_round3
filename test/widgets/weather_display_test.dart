import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  testWidgets('WeatherDisplay UI and behavior test', (
    WidgetTester tester,
  ) async {
    final weatherRepo = WeatherRepo();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: WeatherDisplay(weatherRepo: weatherRepo)),
      ),
    );

    // ✅ Loading indicator at start
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));

    // ✅ Default city data
    expect(find.text('☀️'), findsOneWidget);
    final initialCard = find.byType(Card);
    expect(
      find.descendant(of: initialCard, matching: find.text('New York')),
      findsOneWidget,
    );

    // ✅ Switch to Fahrenheit
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.textContaining('°F'), findsOneWidget);

    // ✅ Change city to London
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('London').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    // ✅ Verify London data
    final card = find.byType(Card);
    expect(
      find.descendant(of: card, matching: find.text('London')),
      findsOneWidget,
    );
    expect(find.text('🌧️'), findsOneWidget);
  });
}
