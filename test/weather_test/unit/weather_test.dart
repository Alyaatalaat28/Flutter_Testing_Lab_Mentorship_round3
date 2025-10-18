import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/feature/weather_feature/weather_display.dart';

void main() {
  group('Temperature Conversion Tests', () {
    test('celsiusToFahrenheit converts 0°C to 32°F', () {
      final state = _WeatherDisplayState();
      expect(state.celsiusToFahrenheit(0), equals(32.0));
    });

    test('celsiusToFahrenheit converts 100°C to 212°F', () {
      final state = _WeatherDisplayState();
      expect(state.celsiusToFahrenheit(100), equals(212.0));
    });

    test('celsiusToFahrenheit converts 25°C to 77°F', () {
      final state = _WeatherDisplayState();
      expect(state.celsiusToFahrenheit(25), equals(77.0));
    });

    test('celsiusToFahrenheit converts -40°C to -40°F', () {
      final state = _WeatherDisplayState();
      expect(state.celsiusToFahrenheit(-40), equals(-40.0));
    });

    test('fahrenheitToCelsius converts 32°F to 0°C', () {
      final state = _WeatherDisplayState();
      expect(state.fahrenheitToCelsius(32), equals(0.0));
    });

    test('fahrenheitToCelsius converts 212°F to 100°C', () {
      final state = _WeatherDisplayState();
      expect(state.fahrenheitToCelsius(212), equals(100.0));
    });

    test('fahrenheitToCelsius converts 77°F to 25°C', () {
      final state = _WeatherDisplayState();
      expect(state.fahrenheitToCelsius(77), equals(25.0));
    });

    test('fahrenheitToCelsius converts -40°F to -40°C', () {
      final state = _WeatherDisplayState();
      expect(state.fahrenheitToCelsius(-40), equals(-40.0));
    });

    test('temperature conversion round trip maintains value', () {
      final state = _WeatherDisplayState();
      const original = 22.5;
      final fahrenheit = state.celsiusToFahrenheit(original);
      final backToCelsius = state.fahrenheitToCelsius(fahrenheit);
      expect(backToCelsius, closeTo(original, 0.001));
    });
  });

  group('WeatherData.fromJson Tests', () {
    test('creates WeatherData from complete JSON', () {
      final json = {
        'city': 'New York',
        'temperature': 22.5,
        'description': 'Sunny',
        'humidity': 65,
        'windSpeed': 12.3,
        'icon': '☀️',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, equals('New York'));
      expect(weatherData.temperatureCelsius, equals(22.5));
      expect(weatherData.description, equals('Sunny'));
      expect(weatherData.humidity, equals(65));
      expect(weatherData.windSpeed, equals(12.3));
      expect(weatherData.icon, equals('☀️'));
    });

    test('creates WeatherData with default values for missing optional fields', () {
      final json = {
        'city': 'London',
        'temperature': 15.0,
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, equals('London'));
      expect(weatherData.temperatureCelsius, equals(15.0));
      expect(weatherData.description, equals('N/A'));
      expect(weatherData.humidity, equals(0));
      expect(weatherData.windSpeed, equals(0.0));
      expect(weatherData.icon, equals('🌡️'));
    });

    test('throws ArgumentError when JSON is null', () {
      expect(
            () => WeatherData.fromJson(null),
        throwsA(isA<ArgumentError>().having(
              (e) => e.message,
          'message',
          contains('cannot be null'),
        )),
      );
    });

    test('throws ArgumentError when city is missing', () {
      final json = {
        'temperature': 22.5,
        'description': 'Sunny',
      };

      expect(
            () => WeatherData.fromJson(json),
        throwsA(isA<ArgumentError>().having(
              (e) => e.message,
          'message',
          contains('Missing required fields'),
        )),
      );
    });

    test('throws ArgumentError when temperature is missing', () {
      final json = {
        'city': 'Tokyo',
        'description': 'Cloudy',
      };

      expect(
            () => WeatherData.fromJson(json),
        throwsA(isA<ArgumentError>().having(
              (e) => e.message,
          'message',
          contains('Missing required fields'),
        )),
      );
    });

    test('handles integer temperature values', () {
      final json = {
        'city': 'Tokyo',
        'temperature': 25, // Integer instead of double
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.temperatureCelsius, equals(25.0));
    });

    test('handles integer windSpeed values', () {
      final json = {
        'city': 'London',
        'temperature': 15.0,
        'windSpeed': 8, // Integer instead of double
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.windSpeed, equals(8.0));
    });
  });

  group('WeatherData.toJson Tests', () {
    test('converts WeatherData to JSON correctly', () {
      final weatherData = WeatherData(
        city: 'Paris',
        temperatureCelsius: 18.5,
        description: 'Partly Cloudy',
        humidity: 70,
        windSpeed: 6.8,
        icon: '⛅',
      );

      final json = weatherData.toJson();

      expect(json['city'], equals('Paris'));
      expect(json['temperature'], equals(18.5));
      expect(json['description'], equals('Partly Cloudy'));
      expect(json['humidity'], equals(70));
      expect(json['windSpeed'], equals(6.8));
      expect(json['icon'], equals('⛅'));
    });

    test('round trip conversion maintains data integrity', () {
      final original = WeatherData(
        city: 'Berlin',
        temperatureCelsius: 12.3,
        description: 'Rainy',
        humidity: 85,
        windSpeed: 15.7,
        icon: '🌧️',
      );

      final json = original.toJson();
      final reconstructed = WeatherData.fromJson(json);

      expect(reconstructed.city, equals(original.city));
      expect(reconstructed.temperatureCelsius, equals(original.temperatureCelsius));
      expect(reconstructed.description, equals(original.description));
      expect(reconstructed.humidity, equals(original.humidity));
      expect(reconstructed.windSpeed, equals(original.windSpeed));
      expect(reconstructed.icon, equals(original.icon));
    });
  });

  group('WeatherData Edge Cases', () {
    test('handles negative temperatures', () {
      final json = {
        'city': 'Moscow',
        'temperature': -15.5,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.temperatureCelsius, equals(-15.5));
    });

    test('handles zero temperature', () {
      final json = {
        'city': 'Oslo',
        'temperature': 0.0,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.temperatureCelsius, equals(0.0));
    });

    test('handles very high humidity', () {
      final json = {
        'city': 'Singapore',
        'temperature': 30.0,
        'humidity': 100,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.humidity, equals(100));
    });

    test('handles zero wind speed', () {
      final json = {
        'city': 'Cairo',
        'temperature': 35.0,
        'windSpeed': 0.0,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.windSpeed, equals(0.0));
    });

    test('handles very long city names', () {
      final json = {
        'city': 'Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch',
        'temperature': 10.0,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.city, equals('Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch'));
    });

    test('handles special characters in description', () {
      final json = {
        'city': 'Paris',
        'temperature': 20.0,
        'description': 'Partly ☁️ with 🌧️ showers',
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.description, equals('Partly ☁️ with 🌧️ showers'));
    });
  });
}

// Helper class to access private state methods for testing
class _WeatherDisplayState {
  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
}