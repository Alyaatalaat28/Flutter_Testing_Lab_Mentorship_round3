import 'package:flutter_test/flutter_test.dart';

void main() {
  late WeatherTestHelper helper;

  setUp(() {
    helper = WeatherTestHelper();
  });

  // GROUP: Temperature Conversion Tests
  group('Temperature Conversion', () {
    test('should convert Celsius to Fahrenheit correctly', () {
      // ARRANGE & ACT
      final result1 = helper.celsiusToFahrenheit(0);
      final result2 = helper.celsiusToFahrenheit(100);
      final result3 = helper.celsiusToFahrenheit(25);
      final result4 = helper.celsiusToFahrenheit(-40);

      // ASSERT
      expect(result1, 32.0, reason: '0°C should be 32°F');
      expect(result2, 212.0, reason: '100°C should be 212°F');
      expect(result3, 77.0, reason: '25°C should be 77°F');
      expect(result4, -40.0, reason: '-40°C should be -40°F');
    });

    test('should convert Fahrenheit to Celsius correctly', () {
      // ARRANGE & ACT
      final result1 = helper.fahrenheitToCelsius(32);
      final result2 = helper.fahrenheitToCelsius(212);
      final result3 = helper.fahrenheitToCelsius(77);
      final result4 = helper.fahrenheitToCelsius(-40);

      // ASSERT
      expect(result1, closeTo(0.0, 0.01), reason: '32°F should be 0°C');
      expect(result2, closeTo(100.0, 0.01), reason: '212°F should be 100°C');
      expect(result3, closeTo(25.0, 0.01), reason: '77°F should be 25°C');
      expect(result4, closeTo(-40.0, 0.01), reason: '-40°F should be -40°C');
    });

    test('should handle decimal temperatures in conversions', () {
      // ARRANGE & ACT
      final result1 = helper.celsiusToFahrenheit(22.5);
      final result2 = helper.fahrenheitToCelsius(72.5);

      // ASSERT
      expect(result1, closeTo(72.5, 0.01));
      expect(result2, closeTo(22.5, 0.01));
    });

    test('should handle negative temperatures', () {
      // ARRANGE & ACT
      final result1 = helper.celsiusToFahrenheit(-10);
      final result2 = helper.fahrenheitToCelsius(14);

      // ASSERT
      expect(result1, 14.0);
      expect(result2, closeTo(-10.0, 0.01));
    });

    test('conversions should be reversible', () {
      // ARRANGE
      const celsius = 20.0;

      // ACT: Convert C -> F -> C
      final fahrenheit = helper.celsiusToFahrenheit(celsius);
      final backToCelsius = helper.fahrenheitToCelsius(fahrenheit);

      // ASSERT: Should get back to original value
      expect(backToCelsius, closeTo(celsius, 0.01));
    });
  });

  // GROUP: Weather Data Parsing Tests
  group('Weather Data Parsing', () {
    test('should parse complete weather data correctly', () {
      // ARRANGE: Valid complete data
      final jsonData = {
        'city': 'New York',
        'temperature': 22.5,
        'description': 'Sunny',
        'humidity': 65,
        'windSpeed': 12.3,
        'icon': '☀️',
      };

      // ACT
      final weatherData = WeatherData.fromJson(jsonData);

      // ASSERT
      expect(weatherData.city, 'New York');
      expect(weatherData.temperatureCelsius, 22.5);
      expect(weatherData.description, 'Sunny');
      expect(weatherData.humidity, 65);
      expect(weatherData.windSpeed, 12.3);
      expect(weatherData.icon, '☀️');
    });

    test('should throw error when parsing null data', () {
      // ARRANGE: Null data
      Map<String, dynamic>? jsonData;

      // ACT & ASSERT: Should throw error
      expect(
        () => WeatherData.fromJson(jsonData),
        throwsA(isA<TypeError>()),
        reason: 'Null data should cause an error',
      );
    });

    test('should throw error when missing required fields', () {
      // ARRANGE: Incomplete data (missing description, humidity, windSpeed, icon)
      final jsonData = {
        'city': 'New York',
        'temperature': 22.5,
      };

      // ACT & ASSERT: Should throw error
      expect(
        () => WeatherData.fromJson(jsonData),
        throwsA(anything),
        reason: 'Missing required fields should cause an error',
      );
    });

    test('should handle different city names', () {
      // ARRANGE
      final cities = ['New York', 'London', 'Tokyo', 'Paris'];

      for (final city in cities) {
        final jsonData = {
          'city': city,
          'temperature': 20.0,
          'description': 'Clear',
          'humidity': 50,
          'windSpeed': 10.0,
          'icon': '☀️',
        };

        // ACT
        final weatherData = WeatherData.fromJson(jsonData);

        // ASSERT
        expect(weatherData.city, city);
      }
    });

    test('should handle temperature as int or double', () {
      // ARRANGE: Temperature as int
      final jsonData1 = {
        'city': 'Test',
        'temperature': 25, // int
        'description': 'Sunny',
        'humidity': 60,
        'windSpeed': 5.5,
        'icon': '☀️',
      };

      // ACT
      final weatherData1 = WeatherData.fromJson(jsonData1);

      // ASSERT: Should convert to double
      expect(weatherData1.temperatureCelsius, isA<double>());
      expect(weatherData1.temperatureCelsius, 25.0);
    });

    test('should handle windSpeed as int or double', () {
      // ARRANGE
      final jsonData = {
        'city': 'Test',
        'temperature': 20.0,
        'description': 'Windy',
        'humidity': 55,
        'windSpeed': 10, // int
        'icon': '💨',
      };

      // ACT
      final weatherData = WeatherData.fromJson(jsonData);

      // ASSERT
      expect(weatherData.windSpeed, isA<double>());
      expect(weatherData.windSpeed, 10.0);
    });

    test('should handle edge case values', () {
      // ARRANGE: Extreme values
      final jsonData = {
        'city': 'Antarctica',
        'temperature': -89.2, // Record low
        'description': 'Extremely Cold',
        'humidity': 0,
        'windSpeed': 0.0,
        'icon': '❄️',
      };

      // ACT
      final weatherData = WeatherData.fromJson(jsonData);

      // ASSERT
      expect(weatherData.temperatureCelsius, -89.2);
      expect(weatherData.humidity, 0);
      expect(weatherData.windSpeed, 0.0);
    });
  });

  // GROUP: Data Validation Tests
  group('Data Validation', () {
    test('should identify complete data', () {
      // ARRANGE
      final completeData = {
        'city': 'Test',
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 60,
        'windSpeed': 5.0,
        'icon': '☀️',
      };

      // ACT
      final isComplete = helper.hasRequiredFields(completeData);

      // ASSERT
      expect(isComplete, true);
    });

    test('should identify incomplete data missing description', () {
      // ARRANGE
      final incompleteData = {
        'city': 'Test',
        'temperature': 20.0,
        'humidity': 60,
        'windSpeed': 5.0,
        'icon': '☀️',
      };

      // ACT
      final isComplete = helper.hasRequiredFields(incompleteData);

      // ASSERT
      expect(isComplete, false);
    });

    test('should identify incomplete data missing humidity', () {
      // ARRANGE
      final incompleteData = {
        'city': 'Test',
        'temperature': 20.0,
        'description': 'Sunny',
        'windSpeed': 5.0,
        'icon': '☀️',
      };

      // ACT
      final isComplete = helper.hasRequiredFields(incompleteData);

      // ASSERT
      expect(isComplete, false);
    });

    test('should identify incomplete data missing windSpeed', () {
      // ARRANGE
      final incompleteData = {
        'city': 'Test',
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 60,
        'icon': '☀️',
      };

      // ACT
      final isComplete = helper.hasRequiredFields(incompleteData);

      // ASSERT
      expect(isComplete, false);
    });

    test('should identify incomplete data missing icon', () {
      // ARRANGE
      final incompleteData = {
        'city': 'Test',
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 60,
        'windSpeed': 5.0,
      };

      // ACT
      final isComplete = helper.hasRequiredFields(incompleteData);

      // ASSERT
      expect(isComplete, false);
    });

    test('should handle null as incomplete data', () {
      // ACT
      final isComplete = helper.hasRequiredFields(null);

      // ASSERT
      expect(isComplete, false);
    });
  });
}

// ============================================
// TEST HELPER CLASSES
// ============================================

class WeatherTestHelper {
  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  bool hasRequiredFields(Map<String, dynamic>? data) {
    if (data == null) return false;

    return data.containsKey('description') &&
        data.containsKey('humidity') &&
        data.containsKey('windSpeed') &&
        data.containsKey('icon');
  }
}

class WeatherData {
  final String city;
  final double temperatureCelsius;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;

  WeatherData({
    required this.city,
    required this.temperatureCelsius,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic>? json) {
    return WeatherData(
      city: json!['city'],
      temperatureCelsius: json['temperature'].toDouble(),
      description: json['description'],
      humidity: json['humidity'],
      windSpeed: json['windSpeed'].toDouble(),
      icon: json['icon'],
    );
  }
}
