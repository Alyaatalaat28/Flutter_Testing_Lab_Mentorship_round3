// weather_display_complete.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test key constants for widget testing
class WeatherDisplayKeys {
  static const String loadingIndicator = 'loadingIndicator';
  static const String errorMessage = 'errorMessage';
  static const String weatherCard = 'weatherCard';
  static const String temperatureText = 'temperatureText';
  static const String refreshButton = 'refreshButton';
  static const String cityDropdown = 'cityDropdown';
  static const String temperatureSwitch = 'temperatureSwitch';
}

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({super.key});

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  bool _useFahrenheit = false;
  String _selectedCity = 'New York';

  final List<String> _cities = ['New York', 'London', 'Tokyo', 'Invalid City'];

  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  // Simulate API call that sometimes returns null or malformed data
  Future<Map<String, dynamic>?> _fetchWeatherData(String city) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Faster for tests

    if (city == 'Invalid City') {
      return null;
    }

    // Simulate random API failure
    if (DateTime.now().millisecond % 4 == 0) {
      return {'city': city, 'temperature': 22.5}; // Incomplete data
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

  Future<void> _loadWeather() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
      _weatherData = null;
    });

    try {
      final data = await _fetchWeatherData(_selectedCity);
      
      if (!mounted) return;
      
      if (data == null) {
        setState(() {
          _error = 'Failed to load weather data for $_selectedCity';
          _isLoading = false;
        });
        return;
      }

      final weatherData = WeatherData.tryParse(data);
      if (weatherData == null) {
        setState(() {
          _error = 'Invalid weather data format';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _weatherData = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // City selection
          Row(
            children: [
              const Text('City: '),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  key: const Key(WeatherDisplayKeys.cityDropdown),
                  value: _selectedCity,
                  isExpanded: true,
                  items: _cities.map((city) {
                    return DropdownMenuItem(value: city, child: Text(city));
                  }).toList(),
                  onChanged: _isLoading ? null : (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCity = value;
                      });
                      _loadWeather();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                key: const Key(WeatherDisplayKeys.refreshButton),
                onPressed: _isLoading ? null : _loadWeather,
                child: _isLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Temperature unit toggle
          Row(
            children: [
              const Text('Temperature Unit:'),
              const SizedBox(width: 10),
              Switch(
                key: const Key(WeatherDisplayKeys.temperatureSwitch),
                value: _useFahrenheit,
                onChanged: _isLoading ? null : (value) {
                  setState(() {
                    _useFahrenheit = value;
                  });
                },
              ),
              Text(_useFahrenheit ? 'Fahrenheit' : 'Celsius'),
            ],
          ),
          const SizedBox(height: 16),

          // Loading state
          if (_isLoading)
            const Center(
              key: Key(WeatherDisplayKeys.loadingIndicator),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Loading weather data...'),
                ],
              ),
            )
          
          // Error state
          else if (_error != null)
            Card(
              key: const Key(WeatherDisplayKeys.errorMessage),
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadWeather,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          
          // Weather data display
          else if (_weatherData != null)
            Card(
              key: const Key(WeatherDisplayKeys.weatherCard),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _weatherData!.icon,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _weatherData!.city,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _weatherData!.description,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        key: const Key(WeatherDisplayKeys.temperatureText),
                        _useFahrenheit
                            ? '${celsiusToFahrenheit(_weatherData!.temperatureCelsius).toStringAsFixed(1)}°F'
                            : '${_weatherData!.temperatureCelsius.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWeatherDetail(
                          'Humidity',
                          '${_weatherData!.humidity}%',
                          Icons.water_drop,
                        ),
                        _buildWeatherDetail(
                          'Wind Speed',
                          '${_weatherData!.windSpeed} km/h',
                          Icons.air,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          
          // Empty state (should not normally occur)
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text('No weather data available'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
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

  // Safe parsing with validation
  static WeatherData? tryParse(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    try {
      final city = json['city'] as String?;
      final temperature = json['temperature'];
      final description = json['description'] as String?;
      final humidity = json['humidity'];
      final windSpeed = json['windSpeed'];
      final icon = json['icon'] as String?;

      // Validate required fields
      if (city == null || city.isEmpty) return null;
      if (temperature == null) return null;
      if (description == null || description.isEmpty) return null;
      if (humidity == null) return null;
      if (windSpeed == null) return null;
      if (icon == null || icon.isEmpty) return null;

      return WeatherData(
        city: city,
        temperatureCelsius: (temperature as num).toDouble(),
        description: description,
        humidity: (humidity as num).toInt(),
        windSpeed: (windSpeed as num).toDouble(),
        icon: icon,
      );
    } catch (e) {
      return null;
    }
  }

  // Original fromJson for backward compatibility (now with validation)
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['city'] as String,
      temperatureCelsius: (json['temperature'] as num).toDouble(),
      description: json['description'] as String,
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      icon: json['icon'] as String,
    );
  }
}

// Test helper class that can be accessed from tests
class WeatherDisplayTestHelper {
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
}

