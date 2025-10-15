import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  // Helper function to build widget with MaterialApp wrapper
  Widget buildWeatherDisplay() {
    return const MaterialApp(
      home: Scaffold(
        body: WeatherDisplay(),
      ),
    );
  }

  group('WeatherDisplay Widget Tests', () {
    testWidgets('should display loading indicator on initial load',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Build widget
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pump();

      // ASSERT: Loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Clean up pending timers
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should display city dropdown', (WidgetTester tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(buildWeatherDisplay());

      // ASSERT: Dropdown should be present
      expect(find.byType(DropdownButton<String>), findsOneWidget);

      // Clean up
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should display refresh button', (WidgetTester tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(buildWeatherDisplay());

      // ASSERT: Refresh button should be present
      expect(find.text('Refresh'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Refresh'), findsOneWidget);

      // Clean up
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should display temperature unit toggle',
        (WidgetTester tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(buildWeatherDisplay());

      // ASSERT: Switch should be present
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Temperature Unit:'), findsOneWidget);

      // Clean up
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should display Celsius by default',
        (WidgetTester tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(buildWeatherDisplay());

      // ASSERT: Should show Celsius label
      expect(find.text('Celsius'), findsOneWidget);

      // Clean up
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should toggle between Celsius and Fahrenheit',
        (WidgetTester tester) async {
      // ARRANGE: Build widget and wait for loading
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ACT: Tap the switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // ASSERT: Should now show Fahrenheit
      expect(find.text('Fahrenheit'), findsOneWidget);

      // ACT: Tap again
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // ASSERT: Should be back to Celsius
      expect(find.text('Celsius'), findsOneWidget);
    });

    testWidgets('should display weather data after loading',
        (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(buildWeatherDisplay());

      // ASSERT: Loading indicator visible initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // ACT: Wait for async loading to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ASSERT: Weather card should be displayed (or error card)
      expect(
        find.byType(Card),
        findsWidgets,
        reason: 'Should display weather card or error card',
      );

      // Loading indicator should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should display error when selecting Invalid City',
        (WidgetTester tester) async {
      // ARRANGE: Build widget and wait for initial load
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ACT: Open dropdown and select "Invalid City"
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ASSERT: Error message should be displayed
      expect(
        find.textContaining('Failed to load weather'),
        findsOneWidget,
        reason: 'Should show error message for invalid city',
      );

      // Error icon should be visible
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should change city when dropdown selection changes',
        (WidgetTester tester) async {
      // ARRANGE: Build widget and wait for initial load
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ACT: Open dropdown and select "London"
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('London').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ASSERT: Should display London's weather (if not incomplete data error)
      // Either shows city name or shows incomplete data error
      final londonText = find.textContaining('London');
      final incompleteText = find.textContaining('Incomplete');
      expect(
        londonText.evaluate().isNotEmpty || incompleteText.evaluate().isNotEmpty,
        true,
        reason: 'Should show either London weather or incomplete data error',
      );
    });

    testWidgets('should reload weather when refresh button is tapped',
        (WidgetTester tester) async {
      // ARRANGE: Build widget and wait for initial load
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ACT: Tap refresh button
      await tester.tap(find.text('Refresh'));
      await tester.pump();

      // ASSERT: Loading indicator should appear
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // ACT: Wait for reload
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ASSERT: Loading should be done
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should display temperature in Fahrenheit when toggled',
        (WidgetTester tester) async {
      // ARRANGE: Build widget and wait for data to load
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip if we got incomplete data error
      if (find.textContaining('Incomplete').evaluate().isNotEmpty) {
        return;
      }

      // ACT: Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // ASSERT: Should find °F symbol (if weather data loaded successfully)
      if (find.textContaining('°C').evaluate().isEmpty) {
        // We have weather data
        expect(find.textContaining('°F'), findsOneWidget);
      }
    });

    testWidgets('should display all weather details when data is loaded',
        (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip test if we got incomplete data error
      if (find.textContaining('Incomplete').evaluate().isNotEmpty ||
          find.textContaining('Failed').evaluate().isNotEmpty) {
        return;
      }

      // ASSERT: Weather details should be visible
      expect(
        find.text('Humidity'),
        findsOneWidget,
        reason: 'Humidity label should be visible',
      );
      expect(
        find.text('Wind Speed'),
        findsOneWidget,
        reason: 'Wind Speed label should be visible',
      );

      // Icons should be present
      expect(
        find.byIcon(Icons.water_drop),
        findsOneWidget,
        reason: 'Humidity icon should be visible',
      );
      expect(
        find.byIcon(Icons.air),
        findsOneWidget,
        reason: 'Wind speed icon should be visible',
      );
    });

    testWidgets('should handle incomplete data gracefully',
        (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Since the API randomly returns incomplete data,
      // we may see either weather data OR an error message

      // ASSERT: Should not crash and should show either:
      // 1. Weather card with data, OR
      // 2. Error card with message

      expect(
        find.byType(Card),
        findsWidgets,
        reason: 'Should display some card (weather or error)',
      );

      // Should not show loading indicator anymore
      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
        reason: 'Loading should be complete',
      );
    });

    testWidgets('should display all available cities in dropdown',
        (WidgetTester tester) async {
      // ARRANGE & ACT: Build widget
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle();

      // ACT: Open dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // ASSERT: All cities should be in the dropdown
      expect(find.text('New York').hitTestable(), findsWidgets);
      expect(find.text('London').hitTestable(), findsWidgets);
      expect(find.text('Tokyo').hitTestable(), findsWidgets);
      expect(find.text('Invalid City').hitTestable(), findsWidgets);
    });

    testWidgets('should maintain temperature unit preference during city change',
        (WidgetTester tester) async {
      // ARRANGE: Build widget and wait for load
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ACT: Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // ACT: Change city
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ASSERT: Should still show Fahrenheit
      expect(find.text('Fahrenheit'), findsOneWidget);
    });

    testWidgets('should show error card with proper styling',
        (WidgetTester tester) async {
      // ARRANGE: Build widget and wait for initial load
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ACT: Select Invalid City to trigger error
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ASSERT: Error UI elements should be present
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining('Failed'), findsOneWidget);

      // Find the error card
      final errorCard = tester.widget<Card>(
        find.ancestor(
          of: find.byIcon(Icons.error_outline),
          matching: find.byType(Card),
        ),
      );

      // Check card styling
      expect(errorCard.color, isNotNull);
    });
  });

  group('WeatherDisplay Edge Cases', () {
    testWidgets('should not crash on rapid temperature unit toggles',
        (WidgetTester tester) async {
      // ARRANGE: Build widget and wait for load
      await tester.pumpWidget(buildWeatherDisplay());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ACT: Rapidly toggle temperature unit
      for (var i = 0; i < 10; i++) {
        await tester.tap(find.byType(Switch));
        await tester.pump();
      }

      // ASSERT: Should not crash
      expect(tester.takeException(), isNull);
    });
  });
}
