import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing_lab/weather/presentation/manager/cubit/weather_cubit.dart';

class TemperatureTogelWidge extends StatelessWidget {
  const TemperatureTogelWidge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        final cubit = context.watch<WeatherCubit>();

        return Material(
          // ✅ يضمن وجود Material للـ Switch
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Temperature Unit:',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                child: Switch(
                  value: cubit.useFahrenheit,
                  onChanged: (value) => cubit.refreshTogel(),
                ),
              ),
              Flexible(
                child: Text(
                  cubit.useFahrenheit ? 'Fahrenheit' : 'Celsius',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
