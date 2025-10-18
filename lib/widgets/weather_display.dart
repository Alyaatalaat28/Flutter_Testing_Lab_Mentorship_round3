import 'package:flutter/material.dart';

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

  // ISSUE RESOLVED: Temperature conversion was missing +32
  // This caused incorrect Fahrenheit values (e.g., 0°C showed as 0°F instead of 32°F)
  // FIX: Added +32 to the conversion formula
  // WHY: The correct formula is: F = (C × 9/5) + 32
  // This is the standard Celsius to Fahrenheit conversion formula
  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  // ISSUE RESOLVED: Fahrenheit to Celsius had wrong operator precedence
  // Due to missing parentheses, calculation was: fahrenheit - (32 * 5 / 9) = fahrenheit - 17.78
  // FIX: Added parentheses to ensure correct order: (fahrenheit - 32) * 5 / 9
  // WHY: The correct formula is: C = (F - 32) × 5/9
  // Without parentheses, subtraction happens last due to operator precedence
  // Example: 32°F should = 0°C, but without parens: 32 - 17.78 = 14.22°C (wrong!)
  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  // ISSUE RESOLVED: API simulation sometimes returned incomplete data
  // Missing fields (description, humidity, windSpeed, icon) caused app crashes
  // FIX: Always return complete data with all required fields or null
  // WHY: Incomplete data causes null reference errors when accessing missing fields
  // Now either returns complete weather data or null for proper error handling
  Future<Map<String, dynamic>?> _fetchWeatherData(String city) async {
    await Future.delayed(const Duration(seconds: 2));

    if (city == 'Invalid City') {
      return null;
    }

    // Always return complete data (removed incomplete data scenario)
    // All fields are now guaranteed to be present
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

  // ISSUE RESOLVED: setState called without mounted check after async operation
  // Also missing error handling for null data or parsing errors
  // FIX: Added mounted checks before all setState calls + try-catch error handling
  // WHY: Widget might be disposed while async operation is running
  // setState after dispose causes "setState() called after dispose()" error
  Future<void> _loadWeather() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final data = await _fetchWeatherData(_selectedCity);

      // ISSUE RESOLVED: Added mounted check before setState in async callback
      // FIX: Only call setState if widget is still in the tree
      if (mounted) {
        setState(() {
          _weatherData = WeatherData.fromJson(data);
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      // Handle errors from null data or parsing failures
      if (mounted) {
        setState(() {
          _weatherData = null;
          _isLoading = false;
          _error = 'Failed to load weather data: ${e.toString()}';
        });
      }
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
                  value: _selectedCity,
                  isExpanded: true,
                  items: _cities.map((city) {
                    return DropdownMenuItem(value: city, child: Text(city));
                  }).toList(),
                  onChanged: (value) {
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
                onPressed: _loadWeather,
                child: const Text('Refresh'),
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
                value: _useFahrenheit,
                onChanged: (value) {
                  setState(() {
                    _useFahrenheit = value;
                  });
                },
              ),
              Text(_useFahrenheit ? 'Fahrenheit' : 'Celsius'),
            ],
          ),
          const SizedBox(height: 16),

          if (_isLoading && _error == null)
            const Center(child: CircularProgressIndicator())
          // ISSUE RESOLVED: Error messages were never displayed to user
          // FIX: Added error display UI when _error is not null
          // WHY: Users need to see error messages when data loading fails
          // Provides better UX by informing users of issues
          else if (_error != null)
            Center(
              child: Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Colors.red[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWeather,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_weatherData != null)
            Card(
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

  // ISSUE RESOLVED: fromJson used ! operator without null checks
  // This caused app crashes when data was null or incomplete
  // FIX: Added proper null safety with null checks and error handling
  // WHY: API can return null data (e.g., for invalid cities or network errors)
  // Throws descriptive error instead of crashing with null reference exception
  factory WeatherData.fromJson(Map<String, dynamic>? json) {
    // Check if json is null
    if (json == null) {
      throw ArgumentError('Weather data cannot be null');
    }

    // Validate all required fields are present
    if (!json.containsKey('city') || !json.containsKey('temperature')) {
      throw ArgumentError('Missing required fields in weather data');
    }

    return WeatherData(
      city: json['city'] as String? ?? 'Unknown',
      temperatureCelsius: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? 'No description',
      humidity: json['humidity'] as int? ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 0.0,
      icon: json['icon'] as String? ?? '🌡️',
    );
  }
}