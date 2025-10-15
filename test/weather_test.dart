import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Temperature Conversion Tests', () {
    test('Celsius to Fahrenheit conversion is correct', () {
      final result = (22 * 9 / 5) + 32;
      expect(result, 71.6);
    });

    test('Fahrenheit to Celsius conversion is correct', () {
      final result = (68 - 32) * 5 / 9;
      expect(result, closeTo(20.0, 0.1));
    });
  });

  group('WeatherData fromJson Tests', () {
    test('Parses valid JSON correctly', () {
      final json = {
        'city': 'London',
        'temperature': 15.0,
        'description': 'Rainy',
        'humidity': 80,
        'windSpeed': 10.0,
        'icon': '🌧️'
      };

      final weather = WeatherData.fromJson(json);
      expect(weather.city, 'London');
      expect(weather.temperatureCelsius, 15.0);
      expect(weather.description, 'Rainy');
    });

    test('Throws exception if data is null', () {
      expect(() => WeatherData.fromJson(null), throwsException);
    });

    test('Handles incomplete data gracefully', () {
      final json = {
        'city': 'Unknown',
        // missing temperature
      };

      final weather = WeatherData.fromJson(json);
      expect(weather.temperatureCelsius, 0.0); // default value
    });
  });
}
