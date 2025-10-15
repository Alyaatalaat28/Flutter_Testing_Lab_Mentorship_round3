import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utils/weather_utils.dart';

void main() {
  group('temperature conversions', () {
    test('celsius to fahrenheit', () {
      expect(celsiusToFahrenheit(0), 32);
      expect(celsiusToFahrenheit(100), closeTo(212, 0.0001));
      expect(celsiusToFahrenheit(-40), closeTo(-40, 0.0001));
    });

    test('fahrenheit to celsius', () {
      expect(fahrenheitToCelsius(32), closeTo(0, 0.0001));
      expect(fahrenheitToCelsius(212), closeTo(100, 0.0001));
      expect(fahrenheitToCelsius(-40), closeTo(-40, 0.0001));
    });
  });

  group('parseWeatherData', () {
    test('parses valid data', () {
      final json = {
        'city': 'Testville',
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 50,
        'windSpeed': 5.5,
        'icon': '☀️'
      };

      final data = parseWeatherData(json);
      expect(data, isNotNull);
      expect(data!.city, 'Testville');
      expect(data.temperatureCelsius, 20.0);
    });

    test('returns null for missing fields', () {
      final json = {'temperature': 20.0};
      expect(parseWeatherData(json), isNull);
      expect(parseWeatherData(null), isNull);
    });

    test('handles numeric fields provided as strings', () {
      final json = {
        'city': 'StrTown',
        'temperature': '18.5',
        'humidity': '42',
        'windSpeed': '3.2'
      };

      final data = parseWeatherData(json);
      expect(data, isNotNull);
      expect(data!.temperatureCelsius, closeTo(18.5, 0.001));
      expect(data.humidity, 42);
    });
  });
}
