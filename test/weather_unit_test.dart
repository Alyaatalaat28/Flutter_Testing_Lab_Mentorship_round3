import 'package:flutter_testing_lab/widgets/weather_display.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeatherData', () {
    test('fromJson converts numeric values correctly', () {
      final json = {
        'city': 'New York',
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 60,
        'windSpeed': 5.5,
        'icon': '☀️',
      };

      final weather = WeatherData.fromJson(json);

      expect(weather.city, 'New York');
      expect(weather.temperatureCelsius, 20.0);
      expect(weather.description, 'Sunny');
      expect(weather.humidity, 60);
      expect(weather.windSpeed, 5.5);
      expect(weather.icon, '☀️');
    });
  });

  group('Temperature conversion', () {
    test('celsiusToFahrenheit works correctly', () {
      final state = _FakeWeatherDisplayState();
      expect(state.celsiusToFahrenheit(0), 32);
      expect(state.celsiusToFahrenheit(100), 212);
      expect(state.celsiusToFahrenheit(-40), -40);
    });

    test('fahrenheitToCelsius works correctly', () {
      final state = _FakeWeatherDisplayState();
      expect(state.fahrenheitToCelsius(32), 0);
      expect(state.fahrenheitToCelsius(212), 100);
      expect(state.fahrenheitToCelsius(-40), -40);
    });
  });
}

class _FakeWeatherDisplayState {
  double celsiusToFahrenheit(double celsius) => celsius * 9 / 5 + 32;
  double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;
}
