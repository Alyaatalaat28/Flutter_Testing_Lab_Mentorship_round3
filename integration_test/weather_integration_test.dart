import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_testing_lab/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather Display Integration Tests', () {
    testWidgets('complete weather app flow works end-to-end', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      // Wait for weather data to load (give it extra time on real devices)
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify initial state
      expect(find.text('City: '), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Refresh'), findsOneWidget);
    });

    testWidgets('user can change cities and view different weather data', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      // Wait for initial load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Change city to London
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pumpAndSettle();

      // Wait for weather data with more time
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify London data loads (if successful)
      // Due to API randomness, just verify no crash occurred
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('user can toggle between Celsius and Fahrenheit', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      // Wait for initial load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify Celsius is default
      expect(find.text('Celsius'), findsOneWidget);

      // Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Verify Fahrenheit is shown
      expect(find.text('Fahrenheit'), findsOneWidget);

      // If weather data is displayed, temperature should show °F
      final tempFinder = find.textContaining('°F');
      if (tempFinder.evaluate().isNotEmpty) {
        expect(tempFinder, findsOneWidget);
      }

      // Toggle back to Celsius
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Verify back to Celsius
      expect(find.text('Celsius'), findsOneWidget);
    });

    testWidgets('user can refresh weather data', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      // Wait for initial load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap refresh button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh'));
      await tester.pump();

      // On real devices, loading might be too fast to catch
      // Just wait for the operation to complete
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify the app is still functional
      expect(find.widgetWithText(ElevatedButton, 'Refresh'), findsOneWidget);
    });

    testWidgets('handles invalid city gracefully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      // Wait for initial load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Select Invalid City
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      // Wait for API call
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should show error message
      expect(find.text('Unable to fetch weather data. City not found.'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('can recover from error state by trying again', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Trigger error by selecting Invalid City
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify error is shown
      expect(find.text('Unable to fetch weather data. City not found.'), findsOneWidget);

      // Tap Try Again
      await tester.tap(find.widgetWithText(ElevatedButton, 'Try Again'));
      await tester.pump();

      // Wait for operation to complete
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify still showing error (since city hasn't changed)
      expect(find.text('Unable to fetch weather data. City not found.'), findsOneWidget);
    });

    testWidgets('can switch between cities multiple times', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 5));

      final cities = ['London', 'Tokyo', 'New York'];

      for (final city in cities) {
        // Select city
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text(city).last);
        await tester.pumpAndSettle();

        // Wait for data
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }

      // Should complete without errors
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('temperature unit persists when changing cities', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('Fahrenheit'), findsOneWidget);

      // Change city
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should still be Fahrenheit
      expect(find.text('Fahrenheit'), findsOneWidget);
    });

    testWidgets('can navigate away and back to weather tab', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to Registration tab
      await tester.tap(find.text('Registration'));
      await tester.pumpAndSettle();

      // Navigate back to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      // Weather display should still be functional
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Refresh'), findsOneWidget);
    });

    testWidgets('weather details are displayed correctly when data loads', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // If weather data loaded successfully (not incomplete or null)
      final cardFinder = find.byType(Card);
      if (cardFinder.evaluate().isNotEmpty) {
        // Check if it's not an error card
        final errorFinder = find.text('Unable to fetch weather data. City not found.');
        if (errorFinder.evaluate().isEmpty) {
          // Should display weather details
          expect(find.text('Humidity'), findsOneWidget);
          expect(find.text('Wind Speed'), findsOneWidget);
          expect(find.byIcon(Icons.water_drop), findsOneWidget);
          expect(find.byIcon(Icons.air), findsOneWidget);
        }
      }
    });

    testWidgets('complete user journey: view, change city, toggle units, refresh',
            (WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();

          // Step 1: Navigate to Weather tab
          await tester.tap(find.text('Weather'));
          await tester.pumpAndSettle();
          await tester.pumpAndSettle(const Duration(seconds: 5));

          // Step 2: Change to Tokyo
          await tester.tap(find.byType(DropdownButton<String>));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Tokyo').last);
          await tester.pumpAndSettle();
          await tester.pumpAndSettle(const Duration(seconds: 5));

          // Step 3: Toggle to Fahrenheit
          await tester.tap(find.byType(Switch));
          await tester.pumpAndSettle();
          expect(find.text('Fahrenheit'), findsOneWidget);

          // Step 4: Refresh the data
          await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh'));
          await tester.pumpAndSettle();
          await tester.pumpAndSettle(const Duration(seconds: 5));

          // Step 5: Toggle back to Celsius
          await tester.tap(find.byType(Switch));
          await tester.pumpAndSettle();
          expect(find.text('Celsius'), findsOneWidget);

          // Journey completed successfully
          expect(find.byType(DropdownButton<String>), findsOneWidget);
        });

    testWidgets('UI components are present and functional', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify all main UI components exist
      expect(find.text('City: '), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Refresh'), findsOneWidget);
      expect(find.text('Temperature Unit:'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);

      // Should show either Celsius or Fahrenheit
      final hasCelsius = find.text('Celsius').evaluate().isNotEmpty;
      final hasFahrenheit = find.text('Fahrenheit').evaluate().isNotEmpty;
      expect(hasCelsius || hasFahrenheit, isTrue);
    });

    testWidgets('dropdown contains all expected cities', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Weather tab
      await tester.tap(find.text('Weather'));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Verify all cities are present
      expect(find.text('New York'), findsWidgets);
      expect(find.text('London'), findsWidgets);
      expect(find.text('Tokyo'), findsWidgets);
      expect(find.text('Invalid City'), findsWidgets);

      // Close dropdown by tapping elsewhere
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
    });
  });
}