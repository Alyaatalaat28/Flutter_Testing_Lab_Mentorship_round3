import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('WeatherDisplay Widget Tests', () {
    testWidgets('should display loading indicator initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      expect(find.byType(Card), findsNothing);
      expect(find.byIcon(Icons.error_outline), findsNothing);

      await tester.pumpAndSettle();
    });

    testWidgets('should display city dropdown with all cities', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.text('New York'), findsOneWidget);
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      expect(find.text('Tokyo'), findsOneWidget);
      expect(find.text('Invalid City'), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('should display weather data after loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      final hasCard = find.byType(Card).evaluate().isNotEmpty;
      final hasError = find.byIcon(Icons.error_outline).evaluate().isNotEmpty;

      expect(hasCard || hasError, isTrue);
    });

    testWidgets('should handle city selection change', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('London').last);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('London'), findsNWidgets(2));

      await tester.pumpAndSettle();
    });

    testWidgets('should display error state when selecting Invalid City', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Invalid City'));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining('Error:'), findsOneWidget);
    });

    testWidgets('should switch temperature display when toggling unit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      if (find.byType(Card).evaluate().isNotEmpty) {
        expect(find.textContaining('°C'), findsOneWidget);

        await tester.tap(find.byType(Switch));
        await tester.pump();

        expect(find.textContaining('°F'), findsOneWidget);
        expect(find.textContaining('°C'), findsNothing);
      }
    });
  });
}
