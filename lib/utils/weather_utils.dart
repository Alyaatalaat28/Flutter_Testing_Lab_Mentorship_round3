import '../widgets/weather_display.dart' show WeatherData;

double celsiusToFahrenheit(double celsius) => (celsius * 9 / 5) + 32;

double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;

/// Safely parse JSON returned from API to WeatherData.
/// Returns null if required fields are missing or of incorrect type.
WeatherData? parseWeatherData(Map<String, dynamic>? json) {
  if (json == null) return null;

  try {
    final city = json['city']?.toString();
    final temp = json['temperature'];
    final desc = json['description']?.toString() ?? 'Unknown';
    final humidity = json['humidity'];
    final windSpeed = json['windSpeed'];
    final icon = json['icon']?.toString() ?? '';

    if (city == null) return null;
    if (temp == null) return null;

    final tempDouble = (temp is num)
        ? temp.toDouble()
        : double.tryParse(temp.toString());
    if (tempDouble == null) return null;

    final humidityInt = (humidity is int)
        ? humidity
        : (int.tryParse(humidity?.toString() ?? '0') ?? 0);
    final windDouble = (windSpeed is num)
        ? windSpeed.toDouble()
        : double.tryParse(windSpeed?.toString() ?? '0.0') ?? 0.0;

    return WeatherData(
      city: city,
      temperatureCelsius: tempDouble,
      description: desc,
      humidity: humidityInt,
      windSpeed: windDouble,
      icon: icon,
    );
  } catch (_) {
    return null;
  }
}
