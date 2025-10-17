import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group("Weather Display Tests", () {
    // Helper
    Future<WeatherDisplayState> setupWeather(WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      return tester.state<WeatherDisplayState>(find.byType(WeatherDisplay));
    }

    testWidgets("should convert temperatures correctly", (tester) async {
      // ARRANGE
      final state = await setupWeather(tester);

      // ACT & ASSERT
      expect(state.celsiusToFahrenheit(0), 32.0);
      expect(state.celsiusToFahrenheit(100), 212.0);
      expect(state.celsiusToFahrenheit(25), 77.0);
      expect(state.fahrenheitToCelsius(32), 0.0);
      expect(state.fahrenheitToCelsius(212), 100.0);
      expect(state.fahrenheitToCelsius(77), 25.0);
    });

    test("should parse complete weather data", () {
      // ARRANGE
      final json = {
        'city': 'London',
        'temperature': 15.0,
        'description': 'Rainy',
        'humidity': 85,
        'windSpeed': 8.5,
        'icon': '🌧️',
      };

      // ACT
      final data = WeatherData.fromJson(json);

      // ASSERT
      expect(data.city, 'London');
      expect(data.temperatureCelsius, 15.0);
      expect(data.description, 'Rainy');
      expect(data.humidity, 85);
      expect(data.windSpeed, 8.5);
    });

    test("should use defaults for missing fields", () {
      // ARRANGE
      final json = {'city': 'Tokyo', 'temperature': 25.0};

      // ACT
      final data = WeatherData.fromJson(json);

      // ASSERT
      expect(data.description, 'No description');
      expect(data.humidity, 0);
      expect(data.windSpeed, 0.0);
      expect(data.icon, '❓');
    });

    test("should throw for missing required fields", () {
      expect(
        () => WeatherData.fromJson({'temperature': 20.0}),
        throwsA(isA<Exception>()),
      );
      expect(
        () => WeatherData.fromJson({'city': 'Paris'}),
        throwsA(isA<Exception>()),
      );
    });

    // Fetch Weather Tests
    testWidgets("should fetch weather for cities", (tester) async {
      // ARRANGE
      final state = await setupWeather(tester);

      // ACT - London
      final londonFuture = state.fetchWeatherData('London');
      await tester.pump(const Duration(seconds: 2)); // Wait for the timer
      final londonData = await londonFuture;

      // ASSERT - London
      expect(londonData!['city'], 'London');
      expect(londonData['temperature'], 15.0);
      expect(londonData['description'], 'Rainy');

      // ACT - Tokyo
      final tokyoFuture = state.fetchWeatherData('Tokyo');
      await tester.pump(const Duration(seconds: 2)); // Wait for the timer
      final tokyoData = await tokyoFuture;

      // ASSERT - Tokyo
      expect(tokyoData!['city'], 'Tokyo');
      expect(tokyoData['temperature'], 25.0);
      expect(tokyoData['description'], 'Cloudy');
    });

    // Widget Tests
    testWidgets("should show loading indicator", (tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );
      await tester.pump();
      // ASSERT
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets("should toggle temperature unit", (tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );
      await tester.pump(const Duration(seconds: 2));

      // ACT
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // ASSERT
      expect(find.text('72.5°F'), findsOneWidget);
      expect(find.text('Fahrenheit'), findsOneWidget);
    });

    testWidgets("should show error for invalid city", (tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );
      await tester.pump(const Duration(seconds: 2));

      // ACT
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      // ASSERT
      expect(find.text('Error: City not found'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    test("should handle extreme temperatures", () {
      final hot = WeatherData.fromJson({'city': 'Desert', 'temperature': 56.7});
      final cold = WeatherData.fromJson({
        'city': 'Arctic',
        'temperature': -89.2,
      });

      expect(hot.temperatureCelsius, 56.7);
      expect(cold.temperatureCelsius, -89.2);
    });

    test("should handle integer to double conversion", () {
      final json = {'city': 'Test', 'temperature': 25, 'windSpeed': 10};
      final data = WeatherData.fromJson(json);

      expect(data.temperatureCelsius, 25.0);
      expect(data.windSpeed, 10.0);
    });
  });
}
