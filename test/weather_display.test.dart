import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/functions/weather_display/model/weather_data.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('WeatherData', () {
    test('fromJson creates WeatherData from valid JSON', () {
      final json = {
        'city': 'New York',
        'temperature': 20.5,
        'description': 'Sunny',
        'humidity': 50,
        'windSpeed': 10.0,
        'icon': '☀️',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, 'New York');
      expect(weatherData.temperatureCelsius, 20.5);
      expect(weatherData.description, 'Sunny');
      expect(weatherData.humidity, 50);
      expect(weatherData.windSpeed, 10.0);
      expect(weatherData.icon, '☀️');
    });

    test('fromJson throws Exception on null JSON', () {
      expect(() => WeatherData.fromJson(null), throwsException);
    });

    test('fromJson throws Exception on incomplete JSON', () {
      final json = {'city': 'New York'};

      expect(() => WeatherData.fromJson(json), throwsException);
    });
  });

  testWidgets('Shows loading indicator while loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shows error message on failure', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

    final dropdown = find.byType(DropdownButton<String>);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Invalid City').last);
    await tester.pump();

    await tester.pump(const Duration(seconds: 3));

    expect(find.textContaining('Error'), findsOneWidget);
  });

  testWidgets('Shows weather data on success', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(Card), findsOneWidget);

    expect(find.text('New York'), findsOneWidget);

    expect(find.textContaining('°C'), findsOneWidget);
  });
}
