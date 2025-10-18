
// ==================== إصلاح 5: تحسين WeatherData Class مع Null Safety ====================
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

  // ==================== Factory Constructor مع Error Handling محسّن ====================
  factory WeatherData.fromJson(Map<String, dynamic>? json) {
    // لو الـ json نفسه null، نرمي exception
    if (json == null) {
      throw ArgumentError('JSON data cannot be null');
    }

    // نتحقق من وجود كل الـ fields المطلوبة
    if (!json.containsKey('city')) {
      throw ArgumentError('Missing required field: city');
    }
    if (!json.containsKey('temperature')) {
      throw ArgumentError('Missing required field: temperature');
    }
    if (!json.containsKey('description')) {
      throw ArgumentError('Missing required field: description');
    }
    if (!json.containsKey('humidity')) {
      throw ArgumentError('Missing required field: humidity');
    }
    if (!json.containsKey('windSpeed')) {
      throw ArgumentError('Missing required field: windSpeed');
    }
    if (!json.containsKey('icon')) {
      throw ArgumentError('Missing required field: icon');
    }

    // نحاول نعمل parse للـ data
    try {
      return WeatherData(
        city: json['city'] as String,
        // نستخدم toDouble() علشان لو جاي int نحوله لـ double
        temperatureCelsius: (json['temperature'] as num).toDouble(),
        description: json['description'] as String,
        humidity: json['humidity'] as int,
        windSpeed: (json['windSpeed'] as num).toDouble(),
        icon: json['icon'] as String,
      );
    } catch (e) {
      // لو حصل error في الـ type casting
      throw ArgumentError('Invalid data types in JSON: ${e.toString()}');
    }
  }

  // ==================== إضافة copyWith للتسهيل في الاختبارات ====================
  WeatherData copyWith({
    String? city,
    double? temperatureCelsius,
    String? description,
    int? humidity,
    double? windSpeed,
    String? icon,
  }) {
    return WeatherData(
      city: city ?? this.city,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      description: description ?? this.description,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      icon: icon ?? this.icon,
    );
  }

  // ==================== إضافة toJson للتسهيل في الاختبارات ====================
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperatureCelsius,
      'description': description,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'icon': icon,
    };
  }

  // ==================== إضافة equality operator للمقارنة في الاختبارات ====================
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeatherData &&
        other.city == city &&
        other.temperatureCelsius == temperatureCelsius &&
        other.description == description &&
        other.humidity == humidity &&
        other.windSpeed == windSpeed &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return city.hashCode ^
        temperatureCelsius.hashCode ^
        description.hashCode ^
        humidity.hashCode ^
        windSpeed.hashCode ^
        icon.hashCode;
  }
}