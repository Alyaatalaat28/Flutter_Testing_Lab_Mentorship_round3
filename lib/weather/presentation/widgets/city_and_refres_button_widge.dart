import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/weather/presentation/manager/cubit/weather_cubit.dart';

class CityAndRefresButtonWidge extends StatelessWidget {
  const CityAndRefresButtonWidge({super.key, required this.cubit});
  final WeatherCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('City: '),
        const SizedBox(width: 8),
        Expanded(
          child: Material(
            child: DropdownButton<String>(
              value: cubit.selectedCity,
              isExpanded: true,
              items: cubit.cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  cubit.selectedCity = value;
                  cubit.loadWeather();
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: cubit.loadWeather,
          child: const Text('Refresh', overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
