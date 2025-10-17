import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing_lab/weather/data/weather_data.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  WeatherData? weatherData;
  bool isLoading = false;
  String? error;
  bool useFahrenheit = false;
  String selectedCity = 'New York';

  final List<String> cities = ['New York', 'London', 'Tokyo', 'Invalid City'];

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  void refreshTogel() {
    useFahrenheit = !useFahrenheit;
    emit(WeatherUnitToggled(useFahrenheit));
  }

  Future<Map<String, dynamic>?> fetchWeatherData(String city) async {
    await Future.delayed(const Duration(seconds: 2));

    if (city == 'Invalid City') {
      return null;
    }

    if (DateTime.now().millisecond % 4 == 0) {
      return {'city': city, 'temperature': 22.5};
    }

    return {
      'city': city,
      'temperature': city == 'London' ? 15.0 : (city == 'Tokyo' ? 25.0 : 22.5),
      'description': city == 'London'
          ? 'Rainy'
          : (city == 'Tokyo' ? 'Cloudy' : 'Sunny'),
      'humidity': city == 'London' ? 85 : (city == 'Tokyo' ? 70 : 65),
      'windSpeed': city == 'London' ? 8.5 : (city == 'Tokyo' ? 5.2 : 12.3),
      'icon': city == 'London' ? '🌧️' : (city == 'Tokyo' ? '☁️' : '☀️'),
    };
  }

Future<void> loadWeather() async {
  emit(WeatherLoading());
  final data = await fetchWeatherData(selectedCity);

  if (data == null) {
    emit(WeatherError("Failed to load weather data."));
    return;
  }

  weatherData = WeatherData.fromJson(data);
  emit(WeatherLoaded(weatherData!, useFahrenheit));
}

}
