import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import the file containing the WeatherDisplay code
import 'package:flutter_testing_lab/widgets/weather_display.dart'; 

void main() {
  group('Unit Tests: Weather Logic', () {
    // --- Test the temperature conversion logic ---
    group('Temperature Conversion', () {
      final state = WeatherDisplayState();

      test('celsiusToFahrenheit converts correctly', () {
        expect(state.celsiusToFahrenheit(0), 32.0);
        expect(state.celsiusToFahrenheit(100), 212.0);
        expect(state.celsiusToFahrenheit(-10), 14.0);
      });

      test('fahrenheitToCelsius converts correctly', () {
        expect(state.fahrenheitToCelsius(32), 0.0);
        expect(state.fahrenheitToCelsius(212), 100.0);
        expect(state.fahrenheitToCelsius(14), -10.0);
      });
    });

    // --- Test the data model and parsing logic ---
    group('WeatherData Model', () {
      test('fromJson creates a valid object from full data', () {
        final json = {
          'city': 'London',
          'temperature': 15.0,
          'description': 'Rainy',
          'humidity': 85,
          'windSpeed': 8.5,
          'icon': '🌧️',
        };

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.city, 'London');
        expect(weatherData.temperatureCelsius, 15.0);
        expect(weatherData.description, 'Rainy');
      });

      test('fromJson handles incomplete data with default values', () {
        final json = {'city': 'Tokyo', 'temperature': 25.0}; // Missing fields

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.city, 'Tokyo');
        expect(weatherData.temperatureCelsius, 25.0);
        expect(weatherData.description, 'No description'); // Default value
        expect(weatherData.humidity, 0); // Default value
        expect(weatherData.icon, '❓'); // Default value
      });

      test('fromJson throws an exception for null data', () {
        // Expect the fromJson factory to throw an Exception when given null
        expect(() => WeatherData.fromJson(null), throwsA(isA<Exception>()));
      });
    });
  });

  group('Widget Tests: WeatherDisplay UI', () {
    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

      // At first, the loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the simulated API call (2 seconds) to finish
      await tester.pump(const Duration(seconds: 2));

      // After loading, the indicator should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
      // And the weather card for 'New York' should be visible
      expect(find.text('New York'), findsOneWidget);
    });

    testWidgets('shows error message when API call fails', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

      // Find the dropdown and select the city that causes an error
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle(); // Wait for animation

      await tester.tap(find.text('Invalid City').last);
      await tester.pump(); // Start the loading state

      // The loading indicator should now be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the API call to fail
      await tester.pump(const Duration(seconds: 2));

      // The loading indicator should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
      // An error message should be displayed
      expect(find.text('Failed to load weather data. Please try again.'), findsOneWidget);
    });
    
     testWidgets('toggling switch changes temperature unit', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

      // Wait for the initial load to complete
      await tester.pump(const Duration(seconds: 2));

      // Initially, temperature is in Celsius for New York (22.5°C)
      expect(find.text('22.5°C'), findsOneWidget);
      expect(find.text('72.5°F'), findsNothing);

      // Tap the switch to change to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Now, the temperature should be in Fahrenheit
      expect(find.text('22.5°C'), findsNothing);
      expect(find.text('72.5°F'), findsOneWidget);
    });
  });
}