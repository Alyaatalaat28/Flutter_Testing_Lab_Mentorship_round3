import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Temperature conversions', () {
    test('Celsius to Fahrenheit', () {
      expect(celsiusToFahrenheit(0), 32);
      expect(celsiusToFahrenheit(100), 212);
      expect(celsiusToFahrenheit(-40), -40);
      expect(celsiusToFahrenheit(37).toStringAsFixed(2), '98.60');
    });

    test('Fahrenheit to Celsius', () {
      expect(fahrenheitToCelsius(32), 0);
      expect(fahrenheitToCelsius(212), 100);
      expect(fahrenheitToCelsius(-40), -40);
      expect(fahrenheitToCelsius(98.6), closeTo(37, 0.0001));
    });
  });

  group('WeatherData.fromJson', () {
    test('parses valid json', () {
      final data = WeatherData.fromJson({
        'city': 'Cairo',
        'temperature': 30,
        'description': 'Sunny',
        'humidity': 40,
        'windSpeed': 10.5,
        'icon': '☀️',
      });
      expect(data.city, 'Cairo');
      expect(data.temperatureCelsius, 30);
      expect(data.description, 'Sunny');
      expect(data.humidity, 40);
      expect(data.windSpeed, 10.5);
      expect(data.icon, '☀️');
    });

    test('throws on null', () {
      expect(() => WeatherData.fromJson(null), throwsFormatException);
    });

    test('throws on missing fields', () {
      expect(
        () => WeatherData.fromJson({'city': 'Cairo', 'temperature': 30}),
        throwsFormatException,
      );
    });

    test('throws on wrong types', () {
      expect(
        () => WeatherData.fromJson({
          'city': 'Cairo',
          'temperature': 'hot', // wrong type
          'description': 'Sunny',
          'humidity': 40,
          'windSpeed': 10.5,
          'icon': '☀️',
        }),
        throwsFormatException,
      );
    });
  });
}
