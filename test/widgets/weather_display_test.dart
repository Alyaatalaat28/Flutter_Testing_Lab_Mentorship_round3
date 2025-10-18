import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Weather Display - Unit Tests', () {
    late dynamic weatherState;

    setUp(() {
      final widget = const WeatherDisplay();
      weatherState = widget.createState();
    });

    group('Temperature Conversion', () {
      test('should convert Celsius to Fahrenheit correctly', () {
        expect(weatherState.celsiusToFahrenheit(0.0), 32.0);
        expect(weatherState.celsiusToFahrenheit(100.0), 212.0);
        expect(weatherState.celsiusToFahrenheit(-40.0), -40.0);
        expect(weatherState.celsiusToFahrenheit(25.0), 77.0);
      });

      test('should convert Fahrenheit to Celsius correctly', () {
        expect(weatherState.fahrenheitToCelsius(32.0), 0.0);
        expect(weatherState.fahrenheitToCelsius(212.0), 100.0);
        expect(weatherState.fahrenheitToCelsius(-40.0), -40.0);
        expect(weatherState.fahrenheitToCelsius(77.0), 25.0);
      });
    });

    group('WeatherData.fromJson', () {
      test('should parse complete valid JSON', () {
        final json = {
          'city': 'London',
          'temperature': 15.0,
          'description': 'Rainy',
          'humidity': 85,
          'windSpeed': 8.5,
          'icon': '🌧️',
        };

        final weather = WeatherData.fromJson(json);

        expect(weather.city, 'London');
        expect(weather.temperatureCelsius, 15.0);
        expect(weather.description, 'Rainy');
      });

      test('should throw error for null JSON', () {
        expect(() => WeatherData.fromJson(null), throwsA(isA<ArgumentError>()));
      });

      test('should use default values for missing optional fields', () {
        final json = {
          'city': 'Tokyo',
          'temperature': 25.0,
        };

        final weather = WeatherData.fromJson(json);

        expect(weather.city, 'Tokyo');
        expect(weather.temperatureCelsius, 25.0);
        expect(weather.description, 'No description');
      });
    });
  });

  group('Weather Display - Widget Tests', () {
    testWidgets('should display loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should display weather data after loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('New York'), findsWidgets);
      expect(find.textContaining('°'), findsWidgets);
    });

    testWidgets('should toggle between Celsius and Fahrenheit',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Celsius'), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('Fahrenheit'), findsOneWidget);
    });

    testWidgets('should change city when dropdown selection changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('London'), findsWidgets);
    });

    testWidgets('should display error for invalid city and allow retry',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should refresh weather data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Refresh'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}
