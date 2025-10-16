class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => 'WeatherException: $message';
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

  /// Robust factory: validates presence & types, throws WeatherException on problems.
  factory WeatherData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw WeatherException('Response is null');
    }

    // Validate fields exist and can be converted
    final city = json['city'];
    final temp = json['temperature'];
    final description = json['description'];
    final humidity = json['humidity'];
    final windSpeed = json['windSpeed'];
    final icon = json['icon'];

    if (city == null || temp == null || description == null || humidity == null || windSpeed == null || icon == null) {
      throw WeatherException('Incomplete weather data');
    }

    double tempDouble;
    try {
      tempDouble = (temp is num) ? temp.toDouble() : double.parse(temp.toString());
    } catch (e) {
      throw WeatherException('Invalid temperature value');
    }

    double windDouble;
    try {
      windDouble = (windSpeed is num) ? windSpeed.toDouble() : double.parse(windSpeed.toString());
    } catch (e) {
      throw WeatherException('Invalid windSpeed value');
    }

    int humidityInt;
    try {
      humidityInt = (humidity is int) ? humidity : int.parse(humidity.toString());
    } catch (e) {
      throw WeatherException('Invalid humidity value');
    }

    return WeatherData(
      city: city.toString(),
      temperatureCelsius: tempDouble,
      description: description.toString(),
      humidity: humidityInt,
      windSpeed: windDouble,
      icon: icon.toString(),
    );
  }
}

/// Temperature conversion helpers
double celsiusToFahrenheit(double celsius) {
  // Correct formula: (C * 9/5) + 32
  return celsius * 9 / 5 + 32;
}

double fahrenheitToCelsius(double fahrenheit) {
  // Correct formula: (F - 32) * 5/9
  return (fahrenheit - 32) * 5 / 9;
}
