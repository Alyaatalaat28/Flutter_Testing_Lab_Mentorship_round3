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
    if (json == null ||
        json['city'] == null ||
        json['temperature'] == null ||
        json['description'] == null ||
        json['humidity'] == null ||
        json['windSpeed'] == null ||
        json['icon'] == null) {
      throw Exception('Incomplete or null weather data');
    }

    return WeatherData(
      city: json['city'],
      temperatureCelsius: (json['temperature'] as num).toDouble(),
      description: json['description'],
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      icon: json['icon'],
    );
  }
}
