import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/widgets/weater_display/widgets/build_weather_detail.dart';
import 'package:flutter_testing_lab/widgets/weater_display/widgets/weather_data.dart';

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

  // ==================== إصلاح 1: تصحيح معادلة التحويل من سيلسيوس لفهرنهايت ====================
  // المعادلة الصحيحة: F = (C × 9/5) + 32
  // كانت ناقصة الـ +32
  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32; // أضفنا +32
  }

  // ==================== إصلاح 2: تصحيح معادلة التحويل من فهرنهايت لسيلسيوس ====================
  // المعادلة الصحيحة: C = (F - 32) × 5/9
  // كانت المعادلة غلط تماماً (F - 32 * 5 / 9)
  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9; // صححنا الأقواس
  }

  // ==================== محاكاة API Call ====================
  // دي بترجع null أو data ناقصة في بعض الحالات
  Future<Map<String, dynamic>?> _fetchWeatherData(String city) async {
    await Future.delayed(const Duration(seconds: 2));

    // لو المدينة Invalid، نرجع null
    if (city == 'Invalid City') {
      return null;
    }

    // في بعض الأحيان نرجع data ناقصة (مفيش description, humidity, etc)
    if (DateTime.now().millisecond % 4 == 0) {
      return {'city': city, 'temperature': 22.5};
    }

    // Data كاملة
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

  // ==================== إصلاح 3: تحسين إدارة الـ Loading State والـ Error Handling ====================
  Future<void> _loadWeather() async {
    // نتأكد إن الـ widget لسه موجود قبل ما نعمل setState
    if (!mounted) return;

    setState(() {
      _isLoading = true; // نبدأ التحميل
      _error = null; // نمسح أي أخطاء قديمة
    });

    try {
      // نجيب الـ data من الـ API
      final data = await _fetchWeatherData(_selectedCity);

      // نتأكد إن الـ widget لسه موجود بعد الانتظار
      if (!mounted) return;

      setState(() {
        // لو الـ data null (مثلاً Invalid City)
        if (data == null) {
          _error = 'Failed to load weather data. City not found.';
          _weatherData = null;
        } else {
          // نحاول نعمل parse للـ data
          try {
            _weatherData = WeatherData.fromJson(data);
            _error = null; // نمسح الـ error لو نجحت العملية
          } catch (e) {
            // لو حصل error في الـ parsing (data ناقصة مثلاً)
            _error = 'Invalid weather data format: ${e.toString()}';
            _weatherData = null;
          }
        }
        _isLoading = false; // ننهي التحميل
      });
    } catch (e) {
      // لو حصل أي error تاني (network error مثلاً)
      if (!mounted) return;

      setState(() {
        _error = 'An error occurred: ${e.toString()}';
        _weatherData = null;
        _isLoading = false; // ننهي التحميل حتى لو حصل error
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
          // ==================== City Selection ====================
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

          // ==================== Temperature Unit Toggle ====================
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

          // ==================== إصلاح 4: إضافة عرض للـ Error State ====================
          // لو في loading ومفيش error، نعرض الـ loading indicator
          if (_isLoading && _error == null)
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Loading weather data...'),
                ],
              ),
            )
          // لو في error، نعرضه
          else if (_error != null)
            Card(
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadWeather,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          // لو في data، نعرضها
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
                        buildWeatherDetail(
                          'Humidity',
                          '${_weatherData!.humidity}%',
                          Icons.water_drop,
                        ),
                        buildWeatherDetail(
                          'Wind Speed',
                          '${_weatherData!.windSpeed} km/h',
                          Icons.air,
                        ),
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
}
