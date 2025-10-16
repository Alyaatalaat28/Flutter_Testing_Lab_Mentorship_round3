import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

// Import the main file (adjust path as needed)
// import 'package:your_app/weather_display.dart';

void main() {
  group('Temperature Conversion Tests', () {
    test('celsiusToFahrenheit converts correctly', () {
      expect(celsiusToFahrenheit(0), 32.0);
      expect(celsiusToFahrenheit(100), 212.0);
      expect(celsiusToFahrenheit(-40), -40.0);
      expect(celsiusToFahrenheit(25), 77.0);
      expect(celsiusToFahrenheit(37), 98.6);
    });

    test('fahrenheitToCelsius converts correctly', () {
      expect(fahrenheitToCelsius(32), 0.0);
      expect(fahrenheitToCelsius(212), 100.0);
      expect(fahrenheitToCelsius(-40), -40.0);
      expect(fahrenheitToCelsius(77), 25.0);
      expect(fahrenheitToCelsius(98.6), closeTo(37, 0.1));
    });

    test('conversion functions are inverses', () {
      const testValues = [0.0, 25.0, -10.0, 100.0, 37.5];
      for (final celsius in testValues) {
        final fahrenheit = celsiusToFahrenheit(celsius);
        final backToCelsius = fahrenheitToCelsius(fahrenheit);
        expect(backToCelsius, closeTo(celsius, 0.0001));
      }
    });
  });

  group('WeatherData.fromJson Tests', () {
    test('parses valid complete JSON', () {
      final json = {
        'city': 'London',
        'temperature': 15.5,
        'description': 'Rainy',
        'humidity': 85,
        'windSpeed': 12.3,
        'icon': '🌧️',
      };

      final data = WeatherData.fromJson(json);

      expect(data.city, 'London');
      expect(data.temperatureCelsius, 15.5);
      expect(data.description, 'Rainy');
      expect(data.humidity, 85);
      expect(data.windSpeed, 12.3);
      expect(data.icon, '🌧️');
    });

    test('throws FormatException on null JSON', () {
      expect(
        () => WeatherData.fromJson(null),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Null JSON'),
          ),
        ),
      );
    });

    test('throws FormatException on missing city', () {
      final json = {
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 60,
        'windSpeed': 5.0,
        'icon': '☀️',
      };

      expect(
        () => WeatherData.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Missing "city"'),
          ),
        ),
      );
    });

    test('throws FormatException on missing temperature', () {
      final json = {
        'city': 'Tokyo',
        'description': 'Cloudy',
        'humidity': 70,
        'windSpeed': 8.0,
        'icon': '☁️',
      };

      expect(
        () => WeatherData.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Missing "temperature"'),
          ),
        ),
      );
    });

    test('throws FormatException on empty string city', () {
      final json = {
        'city': '',
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 60,
        'windSpeed': 5.0,
        'icon': '☀️',
      };

      expect(
        () => WeatherData.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('"city" must be non-empty String'),
          ),
        ),
      );
    });

    test('accepts integer temperature and converts to double', () {
      final json = {
        'city': 'Paris',
        'temperature': 20, // int instead of double
        'description': 'Clear',
        'humidity': 55,
        'windSpeed': 7.5,
        'icon': '🌤️',
      };

      final data = WeatherData.fromJson(json);
      expect(data.temperatureCelsius, 20.0);
      expect(data.temperatureCelsius, isA<double>());
    });

    test('throws FormatException on wrong type for humidity', () {
      final json = {
        'city': 'Berlin',
        'temperature': 18.0,
        'description': 'Foggy',
        'humidity': '85', // string instead of int
        'windSpeed': 3.2,
        'icon': '🌫️',
      };

      expect(
        () => WeatherData.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('"humidity" must be int'),
          ),
        ),
      );
    });

    test('accepts integer windSpeed and converts to double', () {
      final json = {
        'city': 'Madrid',
        'temperature': 28.0,
        'description': 'Hot',
        'humidity': 40,
        'windSpeed': 10, // int instead of double
        'icon': '🌡️',
      };

      final data = WeatherData.fromJson(json);
      expect(data.windSpeed, 10.0);
      expect(data.windSpeed, isA<double>());
    });
  });

  group('WeatherDisplay Widget Tests', () {
    testWidgets('displays loading indicator initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(
              fetchOverride: (city) async {
                await Future.delayed(const Duration(milliseconds: 100));
                return {
                  'city': city,
                  'temperature': 20.0,
                  'description': 'Sunny',
                  'humidity': 60,
                  'windSpeed': 5.0,
                  'icon': '☀️',
                };
              },
            ),
          ),
        ),
      );

      await tester.pump(); // Trigger the first frame
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the async operation to complete
      await tester.pumpAndSettle();
    });

    testWidgets('displays weather data after successful fetch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(
              fetchOverride: (city) async {
                return {
                  'city': 'Tokyo',
                  'temperature': 25.0,
                  'description': 'Cloudy',
                  'humidity': 70,
                  'windSpeed': 8.5,
                  'icon': '☁️',
                };
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('cityNameText')), findsOneWidget);
      expect(find.text('Tokyo'), findsWidgets);
      expect(find.text('Cloudy'), findsOneWidget);
      expect(find.text('25.0°C'), findsOneWidget);
      expect(find.text('70%'), findsOneWidget);
      expect(find.text('8.5 km/h'), findsOneWidget);
      expect(find.text('☁️'), findsOneWidget);
    });

    testWidgets('displays error message when fetch returns null', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(fetchOverride: (city) async => null),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('errorText')), findsOneWidget);
      expect(find.text('Data error: No data returned'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('displays error message when data is incomplete', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(
              fetchOverride: (city) async {
                return {
                  'city': city,
                  'temperature': 20.0,
                  // Missing required fields
                };
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('errorText')), findsOneWidget);
      expect(find.textContaining('Data error:'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('retry button works after error', (tester) async {
      var attemptCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(
              fetchOverride: (city) async {
                attemptCount++;
                if (attemptCount == 1) {
                  return null; // First attempt fails
                }
                return {
                  'city': 'London',
                  'temperature': 15.0,
                  'description': 'Rainy',
                  'humidity': 85,
                  'windSpeed': 12.0,
                  'icon': '🌧️',
                };
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(const Key('errorText')), findsOneWidget);

      await tester.tap(find.byKey(const Key('retryButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('cityNameText')), findsOneWidget);
      expect(find.text('London'), findsWidgets);
      expect(find.byKey(const Key('errorText')), findsNothing);
    });

    testWidgets('temperature unit toggle works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(
              fetchOverride: (city) async {
                return {
                  'city': 'Paris',
                  'temperature': 20.0,
                  'description': 'Clear',
                  'humidity': 55,
                  'windSpeed': 7.5,
                  'icon': '☀️',
                };
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('20.0°C'), findsOneWidget);

      await tester.tap(find.byKey(const Key('unitSwitch')));
      await tester.pump();

      expect(find.text('68.0°F'), findsOneWidget);
      expect(find.text('20.0°C'), findsNothing);
    });

    testWidgets('city dropdown changes trigger new fetch', (tester) async {
      final fetchedCities = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(
              initialCity: 'New York',
              fetchOverride: (city) async {
                fetchedCities.add(city);
                return {
                  'city': city,
                  'temperature': city == 'London' ? 15.0 : 20.0,
                  'description': 'Clear',
                  'humidity': 60,
                  'windSpeed': 5.0,
                  'icon': '☀️',
                };
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(fetchedCities.contains('New York'), true);

      await tester.tap(find.byKey(const Key('cityDropdown')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('cityText_London')).last);
      await tester.pumpAndSettle();

      expect(fetchedCities.contains('London'), true);
      expect(find.byKey(const Key('cityNameText')), findsOneWidget);
      expect(find.text('London'), findsWidgets);
    });

    testWidgets('refresh button reloads data', (tester) async {
      var fetchCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(
              fetchOverride: (city) async {
                fetchCount++;
                return {
                  'city': city,
                  'temperature': 20.0 + fetchCount,
                  'description': 'Clear',
                  'humidity': 60,
                  'windSpeed': 5.0,
                  'icon': '☀️',
                };
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('21.0°C'), findsOneWidget);

      await tester.tap(find.byKey(const Key('refreshButton')));
      await tester.pumpAndSettle();

      expect(find.text('22.0°C'), findsOneWidget);
      expect(fetchCount, 2);
    });

    testWidgets('loading stops after error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(
              fetchOverride: (city) async {
                await Future.delayed(const Duration(milliseconds: 100));
                throw Exception('Network error');
              },
            ),
          ),
        ),
      );

      // Initial loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Loading should stop, error should show
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byKey(const Key('errorText')), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('full user flow: load, change unit, change city', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(
              initialCity: 'Tokyo',
              fetchOverride: (city) async {
                final temps = {'Tokyo': 25.0, 'London': 15.0, 'New York': 20.0};
                return {
                  'city': city,
                  'temperature': temps[city] ?? 20.0,
                  'description': 'Clear',
                  'humidity': 60,
                  'windSpeed': 5.0,
                  'icon': '☀️',
                };
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(const Key('cityNameText')), findsOneWidget);
      expect(find.text('Tokyo'), findsWidgets);
      expect(find.text('25.0°C'), findsOneWidget);

      // Switch to Fahrenheit
      await tester.tap(find.byKey(const Key('unitSwitch')));
      await tester.pump();
      expect(find.text('77.0°F'), findsOneWidget);

      // Change city
      await tester.tap(find.byKey(const Key('cityDropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('cityText_London')).last);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('cityNameText')), findsOneWidget);
      expect(find.text('London'), findsWidgets);
      expect(find.text('59.0°F'), findsOneWidget); // 15°C in Fahrenheit
    });
  });
}
