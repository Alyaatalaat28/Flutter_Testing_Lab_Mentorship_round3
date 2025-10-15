import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/helpers/weather_fun.dart';

void main() {
  group('WeatherHelper - Temperature Conversions', () {
    test('converts Celsius to Fahrenheit correctly', () {
      expect(WeatherHelper.celsiusToFahrenheit(0), 32);

      expect(WeatherHelper.celsiusToFahrenheit(100), 212);

      expect(WeatherHelper.celsiusToFahrenheit(-40), -40);

      expect(WeatherHelper.celsiusToFahrenheit(20), 68);

      expect(WeatherHelper.celsiusToFahrenheit(22.5), 72.5);
      expect(WeatherHelper.celsiusToFahrenheit(15.0), 59.0);
    });

    test('converts Fahrenheit to Celsius correctly', () {
      expect(WeatherHelper.fahrenheitToCelsius(32), 0);

      expect(WeatherHelper.fahrenheitToCelsius(212), 100);

      expect(WeatherHelper.fahrenheitToCelsius(-40), -40);

      expect(WeatherHelper.fahrenheitToCelsius(68), 20);
    });
  });
}
