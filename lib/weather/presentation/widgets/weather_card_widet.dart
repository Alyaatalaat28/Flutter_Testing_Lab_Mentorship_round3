import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/weather/data/weather_data.dart';
import 'package:flutter_testing_lab/weather/presentation/widgets/build_weather_eetail.dart';

class WeatherCardWidet extends StatelessWidget {
  const WeatherCardWidet({super.key, required this.weatherData, required this.useFahrenheit});
final WeatherData? weatherData;
final bool useFahrenheit ;
  @override
  Widget build(BuildContext context) {
    
  double celsiusToFahrenheit(double celsius) {
    return celsius * 9 / 5;
  }
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(weatherData!.icon, style: const TextStyle(fontSize: 48)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weatherData!.city,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weatherData!.description,
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
                useFahrenheit
                    ? '${celsiusToFahrenheit(weatherData!.temperatureCelsius).toStringAsFixed(1)}°F'
                    : '${weatherData!.temperatureCelsius.toStringAsFixed(1)}°C',
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
                  '${weatherData!.humidity}%',
                  Icons.water_drop,
                ),
                buildWeatherDetail(
                  'Wind Speed',
                  '${weatherData!.windSpeed} km/h',
                  Icons.air,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
