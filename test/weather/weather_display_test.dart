import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/weather/data/weather_data.dart';
import 'package:flutter_testing_lab/weather/presentation/manager/cubit/weather_cubit.dart';
import 'package:flutter_testing_lab/weather/presentation/widgets/weather_display.dart';

void main() {
  testWidgets('shows loading indicator when state is WeatherLoading',
      (tester) async {
    final cubit = WeatherCubit();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const WeatherDisplay(),
        ),
      ),
    );

    cubit.emit(WeatherLoading());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when state is WeatherError',
      (tester) async {
    final cubit = WeatherCubit();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const WeatherDisplay(),
        ),
      ),
    );

    cubit.emit(WeatherError('Error occurred'));
    await tester.pump();

    expect(find.text('Error occurred'), findsOneWidget);
  });

  testWidgets('shows city dropdown and refresh button when loaded',
      (tester) async {
    final cubit = WeatherCubit();
    cubit.emit(WeatherLoaded(
      WeatherData(
        city: 'London',
        description: 'Rainy',
        temperatureCelsius: 15.0,
        humidity: 80,
        windSpeed: 10.0,
        icon: '🌧️',
      ),
      false,
    ));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const WeatherDisplay(),
        ),
      ),
    );

    expect(find.text('City:'), findsOneWidget);
    expect(find.text('Refresh'), findsOneWidget);
  });
}
