import 'package:flutter/material.dart';
import '../utils/weather_utils.dart';

typedef WeatherFetcher = Future<Map<String, dynamic>?> Function(String city);

class WeatherDisplay extends StatefulWidget {
  /// Optional fetcher injection for testing. If null, uses internal simulated fetcher.
  final WeatherFetcher? fetcher;

  const WeatherDisplay({super.key, this.fetcher});

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

  /// Default simulated fetcher (kept for demo). Tests should inject their own.
  Future<Map<String, dynamic>?> _defaultFetcher(String city) async {
    await Future.delayed(const Duration(seconds: 2));

    if (city == 'Invalid City') {
      return null;
    }

    // Occasionally return "minimal" data to simulate partial response
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
      // keep previous _weatherData visible while loading OR set to null if you prefer blank state
      // _weatherData = null;
    });

    final fetcher = widget.fetcher ?? _defaultFetcher;

    try {
      final data = await fetcher(_selectedCity);

      // Check for null and throw to unify error handling
      if (data == null) {
        throw WeatherException('No data returned from API for "$_selectedCity"');
      }

      final parsed = WeatherData.fromJson(data);

      if (!mounted) return;
      setState(() {
        _weatherData = parsed;
      });
    } on WeatherException catch (we) {
      if (!mounted) return;
      setState(() {
        _error = we.message;
        _weatherData = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load weather data';
        _weatherData = null;
      });
    } finally {
      if (!mounted) return;
      setState(() {
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
                onPressed: _isLoading ? null : _loadWeather,
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
          else if (_error != null)
            Center(
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
          else
            const SizedBox.shrink(),
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
