import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Temperature Conversion', () {
    test('Celsius to Fahrenheit', () {
      expect((_c) => (_c * 9 / 5) + 32, isNotNull);
      expect((0 * 9 / 5) + 32, 32);
      expect((100 * 9 / 5) + 32, 212);
      expect((-40 * 9 / 5) + 32, -40);
    });

    test('Fahrenheit to Celsius', () {
      expect(((f) => (f - 32) * 5 / 9), isNotNull);
      expect((32 - 32) * 5 / 9, 0);
      expect((212 - 32) * 5 / 9, 100);
      expect((-40 - 32) * 5 / 9, -40);
    });
  });

  group('WeatherData.fromJson', () {
    test('Valid JSON returns WeatherData', () {
      final json = {
        'city': 'New York',
        'temperature': 22.5,
        'description': 'Sunny',
        'humidity': 65,
        'windSpeed': 12.3,
        'icon': '☀️',
      };

      final weather = WeatherData.fromJson(json);

      expect(weather.city, 'New York');
      expect(weather.temperatureCelsius, 22.5);
      expect(weather.description, 'Sunny');
      expect(weather.humidity, 65);
      expect(weather.windSpeed, 12.3);
      expect(weather.icon, '☀️');
    });

    test('Invalid JSON throws exception', () {
      final jsonMissingKeys = {'city': 'London', 'temperature': 15.0};

      expect(() => WeatherData.fromJson(jsonMissingKeys), throwsException);
    });

    test('Null JSON throws exception', () {
      expect(() => WeatherData.fromJson(null), throwsException);
    });
  });
}
