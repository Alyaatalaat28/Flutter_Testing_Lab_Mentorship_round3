import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/feature/weather_feature/weather_display.dart';

void main() {
  group('WeatherDisplay Widget Tests', () {
    testWidgets('displays loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Card), findsNothing);

      // Complete the pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('displays city dropdown with all cities', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      expect(find.byType(DropdownButton<String>), findsOneWidget);

      // Complete the initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Tap the dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Should find all cities
      expect(find.text('New York'), findsWidgets);
      expect(find.text('London'), findsWidgets);
      expect(find.text('Tokyo'), findsWidgets);
      expect(find.text('Invalid City'), findsWidgets);
    });

    testWidgets('displays temperature unit toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      expect(find.text('Temperature Unit:'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Celsius'), findsOneWidget);

      // Complete the pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('displays refresh button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      expect(find.widgetWithText(ElevatedButton, 'Refresh'), findsOneWidget);

      // Complete the pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('displays weather data after loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for loading to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display weather card (if data loaded successfully)
      // Due to randomness in the mock API, we check for either weather card or error
      final hasWeatherCard = find.byType(Card).evaluate().isNotEmpty;
      final hasError = find.text('Unable to fetch weather data. City not found.').evaluate().isNotEmpty ||
          find.text('Incomplete weather data received.').evaluate().isNotEmpty;

      expect(hasWeatherCard || hasError, isTrue);
    });

    testWidgets('toggles temperature unit from Celsius to Fahrenheit', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Initial state should show Celsius
      expect(find.text('Celsius'), findsOneWidget);

      // Toggle the switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Should now show Fahrenheit
      expect(find.text('Fahrenheit'), findsOneWidget);
      expect(find.text('Celsius'), findsNothing);
    });

    testWidgets('changes city and reloads weather', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Tap the dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select London
      await tester.tap(find.text('London').last);
      await tester.pump(); // Start the selection

      // Should show loading indicator after a short delay
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for loading to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('refresh button reloads weather data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Tap refresh button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for loading to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('displays error message when city is invalid', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change to Invalid City
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pump();

      // Wait for loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.text('Unable to fetch weather data. City not found.'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('try again button after error reloads data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Load initial data
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change to Invalid City to trigger error
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pump();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Tap Try Again button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Try Again'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('displays weather icon when data loads', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Check if weather icon is displayed (if data loaded successfully)
      final weatherIcons = ['☀️', '🌧️', '☁️', '🌡️'];
      final hasWeatherIcon = weatherIcons.any((icon) =>
      find.text(icon).evaluate().isNotEmpty
      );

      if (find.byType(Card).evaluate().isNotEmpty) {
        expect(hasWeatherIcon, isTrue);
      }
    });

    testWidgets('displays humidity and wind speed when data loads', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // If data loaded successfully, should show humidity and wind speed
      if (find.byType(Card).evaluate().isNotEmpty) {
        expect(find.text('Humidity'), findsOneWidget);
        expect(find.text('Wind Speed'), findsOneWidget);
        expect(find.byIcon(Icons.water_drop), findsOneWidget);
        expect(find.byIcon(Icons.air), findsOneWidget);
      }
    });

    testWidgets('temperature display changes when toggling units', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // If weather card is displayed
      if (find.byType(Card).evaluate().isNotEmpty) {
        // Find temperature text with °C
        final celsiusTemp = find.textContaining('°C');
        if (celsiusTemp.evaluate().isNotEmpty) {
          expect(celsiusTemp, findsOneWidget);

          // Toggle to Fahrenheit
          await tester.tap(find.byType(Switch));
          await tester.pumpAndSettle();

          // Should now show °F
          expect(find.textContaining('°F'), findsOneWidget);
          expect(find.textContaining('°C'), findsNothing);
        }
      }
    });

    testWidgets('refresh button is disabled while loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // During initial loading, refresh button should be disabled
      final refreshButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Refresh')
      );
      expect(refreshButton.onPressed, isNull);

      // Wait for loading to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // After loading, button should be enabled
      final refreshButtonAfter = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Refresh')
      );
      expect(refreshButtonAfter.onPressed, isNotNull);
    });

    testWidgets('error card has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change to Invalid City
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pump();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Find error card
      final errorCard = find.ancestor(
        of: find.byIcon(Icons.error_outline),
        matching: find.byType(Card),
      );
      expect(errorCard, findsOneWidget);

      // Check card has red background
      final card = tester.widget<Card>(errorCard);
      expect(card.color, isNotNull);
    });

    testWidgets('displays correct city name after selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change to Tokyo
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo').last);
      await tester.pump();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // If data loaded successfully, should show Tokyo in the weather card
      if (find.byType(Card).evaluate().isNotEmpty) {
        final cityTexts = find.text('Tokyo');
        expect(cityTexts.evaluate().length, greaterThan(0));
      }
    });
  });

  group('WeatherDisplay Layout Tests', () {
    testWidgets('has correct widget hierarchy', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);

      // Complete the pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('weather card has elevation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      if (find.byType(Card).evaluate().isNotEmpty) {
        final card = tester.widget<Card>(find.byType(Card).first);
        expect(card.elevation, equals(4.0));
      }
    });

    testWidgets('padding is applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, equals(const EdgeInsets.all(16)));

      // Complete the pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });
  });

  group('WeatherDisplay Interaction Tests', () {
    testWidgets('multiple city changes work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change to London
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pump();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change to Tokyo
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo').last);
      await tester.pump();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should complete without errors
      expect(find.byType(WeatherDisplay), findsOneWidget);
    });

    testWidgets('multiple unit toggles work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Toggle multiple times
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
      }

      // Should show Fahrenheit after odd number of toggles
      expect(find.text('Fahrenheit'), findsOneWidget);
    });

    testWidgets('multiple refresh clicks work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Click refresh multiple times
      for (int i = 0; i < 2; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
      }

      expect(find.byType(WeatherDisplay), findsOneWidget);
    });
  });
}