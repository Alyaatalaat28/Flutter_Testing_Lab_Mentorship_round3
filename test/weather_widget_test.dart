import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  testWidgets('WeatherDisplay Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WeatherDisplay(),
        ),
      ),
    );
    expect(find.text('City:'), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Temperature Unit:'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.textContaining('°C'), findsOneWidget);
    expect(find.textContaining('%'), findsWidgets);
    expect(find.textContaining('km/h'), findsWidgets);
  });

  testWidgets('WeatherDisplay handles invalid city properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WeatherDisplay(),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Invalid City').last);
    await tester.pump(); // start loading
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Failed to load weather data'), findsOneWidget);
  });
}
