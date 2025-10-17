import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Temperature Conversion Tests', () {
    test('Celsius to Fahrenheit conversion', () {
      expect(WeatherDisplayTestHelper.celsiusToFahrenheit(0), 32.0);
      expect(WeatherDisplayTestHelper.celsiusToFahrenheit(100), 212.0);
      expect(WeatherDisplayTestHelper.celsiusToFahrenheit(-40), -40.0);
      expect(WeatherDisplayTestHelper.celsiusToFahrenheit(37), closeTo(98.6, 0.1));
    });

    test('Fahrenheit to Celsius conversion', () {
      expect(WeatherDisplayTestHelper.fahrenheitToCelsius(32), 0.0);
      expect(WeatherDisplayTestHelper.fahrenheitToCelsius(212), 100.0);
      expect(WeatherDisplayTestHelper.fahrenheitToCelsius(-40), -40.0);
      expect(WeatherDisplayTestHelper.fahrenheitToCelsius(98.6), closeTo(37.0, 0.1));
    });
  });

  group('WeatherData Parsing Tests', () {
    test('Valid data parsing', () {
      final validData = {
        'city': 'Test City',
        'temperature': 20.5,
        'description': 'Sunny',
        'humidity': 65,
        'windSpeed': 10.2,
        'icon': '☀️',
      };

      final weatherData = WeatherData.tryParse(validData);
      
      expect(weatherData, isNotNull);
      expect(weatherData!.city, 'Test City');
      expect(weatherData.temperatureCelsius, 20.5);
      expect(weatherData.description, 'Sunny');
      expect(weatherData.humidity, 65);
      expect(weatherData.windSpeed, 10.2);
      expect(weatherData.icon, '☀️');
    });

    test('Null data returns null', () {
      expect(WeatherData.tryParse(null), isNull);
    });

    test('Missing required fields returns null', () {
      final incompleteData = {
        'city': 'Test City',
        'temperature': 20.5,
        // Missing description, humidity, windSpeed, icon
      };

      expect(WeatherData.tryParse(incompleteData), isNull);
    });

    test('Invalid data types returns null', () {
      final invalidData = {
        'city': 'Test City',
        'temperature': 'not_a_number', // Should be number
        'description': 'Sunny',
        'humidity': 65,
        'windSpeed': 10.2,
        'icon': '☀️',
      };

      expect(WeatherData.tryParse(invalidData), isNull);
    });

    test('Empty city returns null', () {
      final emptyCityData = {
        'city': '',
        'temperature': 20.5,
        'description': 'Sunny',
        'humidity': 65,
        'windSpeed': 10.2,
        'icon': '☀️',
      };

      expect(WeatherData.tryParse(emptyCityData), isNull);
    });
  });
}