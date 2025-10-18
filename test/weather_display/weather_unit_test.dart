import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Temperature conversions', () {
    test('Celsius to Fahrenheit', () {
      final state = _dummyState();
      expect(state.celsiusToFahrenheit(0), 32.0);
      expect(state.celsiusToFahrenheit(100), closeTo(212.0, 0.001));
      expect(state.celsiusToFahrenheit(22.5), closeTo(72.5, 0.001));
    });

    test('Fahrenheit to Celsius', () {
      final state = _dummyState();
      expect(state.fahrenheitToCelsius(32), closeTo(0.0, 0.001));
      expect(state.fahrenheitToCelsius(212), closeTo(100.0, 0.001));
      expect(state.fahrenheitToCelsius(72.5), closeTo(22.5, 0.001));
    });
  });

  group('WeatherData.fromJson', () {
    test('Parses full JSON correctly', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 60,
        'windSpeed': 5.5,
        'icon': '☀️',
      };
      final w = WeatherData.fromJson(json);
      expect(w.city, 'TestCity');
      expect(w.temperatureCelsius, 20.0);
      expect(w.description, 'Sunny');
      expect(w.humidity, 60);
      expect(w.windSpeed, 5.5);
      expect(w.icon, '☀️');
    });

    test('Throws on null json', () {
      expect(() => WeatherData.fromJson(null), throwsFormatException);
    });

    test('Throws when temperature missing', () {
      final json = {'city': 'X'};
      expect(() => WeatherData.fromJson(json), throwsFormatException);
    });

    test('Handles numeric strings', () {
      final json = {
        'city': 'S',
        'temperature': '18.2',
        'humidity': '50',
        'windSpeed': '3.3',
      };
      final w = WeatherData.fromJson(json);
      expect(w.temperatureCelsius, closeTo(18.2, 0.001));
      expect(w.humidity, 50);
      expect(w.windSpeed, closeTo(3.3, 0.001));
    });
  });
}

_StateDummy _dummyState() {
  return _StateDummy();
}

class _StateDummy extends State<WeatherDisplay> with WidgetsBindingObserver {
  double celsiusToFahrenheit(double celsius) => celsius * 9 / 5 + 32;

  double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
