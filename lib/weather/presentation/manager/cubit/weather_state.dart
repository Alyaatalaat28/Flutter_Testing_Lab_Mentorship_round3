part of 'weather_cubit.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherUnitToggled extends WeatherState {
  final bool useFahrenheit;
  WeatherUnitToggled(this.useFahrenheit);
}

final class WeatherLoaded extends WeatherState {
  final WeatherData weatherData;
  final bool useFahrenheit;

  WeatherLoaded(this.weatherData, this.useFahrenheit);
}

final class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}
