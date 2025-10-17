import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/weather/presentation/manager/cubit/weather_cubit.dart'; 

void main() {
  late WeatherCubit cubit;

  setUp(() {
    cubit = WeatherCubit();
  });

  tearDown(() {
    cubit.close();
  });

  test('fahrenheitToCelsius should convert correctly', () {
    final result = cubit.fahrenheitToCelsius(212);
    expect(result, 100);
  });

  test('refreshTogel should toggle useFahrenheit value', () {
    final initial = cubit.useFahrenheit;
    cubit.refreshTogel();
    expect(cubit.useFahrenheit, !initial);
  });

  test('fetchWeatherData should return valid data for a valid city', () async {
    final result = await cubit.fetchWeatherData('London');
    expect(result, isNotNull);
    expect(result!['city'], 'London');
  });

  test('fetchWeatherData should return null for Invalid City', () async {
    final result = await cubit.fetchWeatherData('Invalid City');
    expect(result, isNull);
  });

  test('loadWeather should emit WeatherLoaded on success', () async {
    cubit.selectedCity = 'London';
    await cubit.loadWeather();
    expect(cubit.state, isA<WeatherLoaded>());
  });

  test('loadWeather should emit WeatherError on failure', () async {
    cubit.selectedCity = 'Invalid City';
    await cubit.loadWeather();
    expect(cubit.state, isA<WeatherError>());
  });
}
