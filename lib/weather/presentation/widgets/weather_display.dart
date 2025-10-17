import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing_lab/weather/presentation/manager/cubit/weather_cubit.dart';
import 'package:flutter_testing_lab/weather/presentation/widgets/city_and_refres_button_widge.dart';
import 'package:flutter_testing_lab/weather/presentation/widgets/temperature_togel_widget.dart';
import 'package:flutter_testing_lab/weather/presentation/widgets/weather_card_widet.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({super.key});

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        final cubit = context.watch<WeatherCubit>();
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is WeatherError) {
          return Center(child: Text(state.message));
        }
        if (state is WeatherLoaded ||
            state is WeatherInitial ||
            state is WeatherUnitToggled) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CityAndRefresButtonWidge(cubit: cubit),
                  const SizedBox(height: 16),
                  TemperatureTogelWidge(),
                  const SizedBox(height: 16),
                  if (cubit.isLoading && cubit.error == null)
                    const Center(child: CircularProgressIndicator())
                  else if (cubit.weatherData != null)
                    WeatherCardWidet(
                      weatherData: cubit.weatherData!,
                      useFahrenheit: cubit.useFahrenheit,
                    ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
