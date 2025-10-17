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
    return WeatherData(
      city: json!['city'],
      temperatureCelsius: json['temperature'].toDouble(),
      description: json['description'],
      humidity: json['humidity'], 
      windSpeed: json['windSpeed'].toDouble(), 
      icon: json['icon'], 
    );
  }
}