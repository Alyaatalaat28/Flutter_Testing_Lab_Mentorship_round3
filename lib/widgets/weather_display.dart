import 'package:flutter/material.dart';

/// -- Data model with safe parsing --
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

  /// Safe parser: throws FormatException on null/missing/invalid fields.
  factory WeatherData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw const FormatException('Null JSON');
    }

    T require<T>(String key) {
      final v = json[key];
      if (v == null) throw FormatException('Missing "$key"');
      if (T == double) {
        if (v is num) return v.toDouble() as T;
        throw FormatException('"$key" must be num/double');
      }
      if (T == int) {
        if (v is int) return v as T;
        throw FormatException('"$key" must be int');
      }
      if (T == String) {
        if (v is String && v.isNotEmpty) return v as T;
        throw FormatException('"$key" must be non-empty String');
      }
      return v as T;
    }

    return WeatherData(
      city: require<String>('city'),
      temperatureCelsius: require<double>('temperature'),
      description: require<String>('description'),
      humidity: require<int>('humidity'),
      windSpeed: require<double>('windSpeed'),
      icon: require<String>('icon'),
    );
  }
}

/// Pure helpers (easy to unit test)
double celsiusToFahrenheit(double c) => (c * 9 / 5) + 32;        // ✅ fixed
double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;        // ✅ fixed

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({
    super.key,

    /// Optional fetch override for tests
    this.fetchOverride,
    this.initialCity = 'New York',
  });

  /// Allow tests to inject a predictable fetcher
  final Future<Map<String, dynamic>?> Function(String city)? fetchOverride;

  final String initialCity;

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  bool _useFahrenheit = false;
  late String _selectedCity;

  final List<String> _cities = const ['New York', 'London', 'Tokyo', 'Invalid City'];

  // Simulated API when not overridden (sometimes incomplete)
  Future<Map<String, dynamic>?> _defaultFetch(String city) async {
    await Future.delayed(const Duration(seconds: 1));
    if (city == 'Invalid City') return null;

    // Sometimes returns incomplete map
    if (DateTime.now().millisecond % 4 == 0) {
      return {'city': city, 'temperature': 22.5};
    }

    return {
      'city': city,
      'temperature': city == 'London' ? 15.0 : (city == 'Tokyo' ? 25.0 : 22.5),
      'description': city == 'London' ? 'Rainy' : (city == 'Tokyo' ? 'Cloudy' : 'Sunny'),
      'humidity': city == 'London' ? 85 : (city == 'Tokyo' ? 70 : 65),
      'windSpeed': city == 'London' ? 8.5 : (city == 'Tokyo' ? 5.2 : 12.3),
      'icon': city == 'London' ? '🌧️' : (city == 'Tokyo' ? '☁️' : '☀️'),
    };
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
      // keep previous _weatherData to allow UI to show last good result while loading, or clear it?
      // Choose to clear for clarity:
      _weatherData = null;
    });

    try {
      final fetcher = widget.fetchOverride ?? _defaultFetch;
      final map = await fetcher(_selectedCity);

      if (map == null) {
        throw const FormatException('No data returned');
      }

      final parsed = WeatherData.fromJson(map);
      if (!mounted) return;
      setState(() {
        _weatherData = parsed;
        _isLoading = false;
      });
    } on FormatException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Data error: ${e.message}';
        _isLoading = false; // ✅ ensure loading stops on error
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Unexpected error: $e';
        _isLoading = false; // ✅ ensure loading stops on error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialCity;
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
                  key: const Key('cityDropdown'),
                  value: _selectedCity,
                  isExpanded: true,
                  items: _cities
                      .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCity = value);
                      _loadWeather();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                key: const Key('refreshButton'),
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
                key: const Key('unitSwitch'),
                value: _useFahrenheit,
                onChanged: (value) => setState(() => _useFahrenheit = value),
              ),
              Text(_useFahrenheit ? 'Fahrenheit' : 'Celsius'),
            ],
          ),
          const SizedBox(height: 16),

          if (_isLoading && _error == null)
            const Center(child: CircularProgressIndicator())
          else if (_error != null) ...[
            Center(
              child: Column(
                children: [
                  Text(_error!, key: const Key('errorText'), style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    key: const Key('retryButton'),
                    onPressed: _loadWeather,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ] else if (_weatherData != null)
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(_weatherData!.icon, style: const TextStyle(fontSize: 48)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_weatherData!.city,
                                  key: const Key('cityText'),
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              Text(_weatherData!.description,
                                  style: const TextStyle(fontSize: 18, color: Colors.grey)),
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
                        key: const Key('tempText'),
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWeatherDetail('Humidity', '${_weatherData!.humidity}%', Icons.water_drop),
                        _buildWeatherDetail('Wind Speed', '${_weatherData!.windSpeed} km/h', Icons.air),
                      ],
                    ),
                  ],
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
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
