import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';
void main() {
  testWidgets('shows loading then weather card on success', (WidgetTester tester) async {
    // fake fetcher returns valid full data quickly
    Future<Map<String, dynamic>?> fakeFetcher(String city) async {
      await Future.delayed(const Duration(milliseconds: 10));
      return {
        'city': city,
        'temperature': 20,
        'description': 'Sunny',
        'humidity': 55,
        'windSpeed': 4.4,
        'icon': '☀️'
      };
    }

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: WeatherDisplay(fetcher: fakeFetcher))));

    // initial loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // wait for fetcher to complete
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle();

    // after load, weather card appears
    expect(find.text('Sunny'), findsOneWidget);
    expect(find.text('20.0°C'), findsOneWidget);
  });

  testWidgets('shows error message when fetcher returns null', (WidgetTester tester) async {
    Future<Map<String, dynamic>?> nullFetcher(String city) async {
      await Future.delayed(const Duration(milliseconds: 10));
      return null;
    }

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: WeatherDisplay(fetcher: nullFetcher))));

    // initial loader
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle();

    // should show error text
    expect(find.textContaining('No data returned'), findsOneWidget);
  });

  testWidgets('shows error when fetcher returns incomplete json', (WidgetTester tester) async {
    Future<Map<String, dynamic>?> badFetcher(String city) async {
      await Future.delayed(const Duration(milliseconds: 10));
      return {'city': city, 'temperature': 10}; // incomplete
    }

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: WeatherDisplay(fetcher: badFetcher))));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle();

    expect(find.textContaining('Incomplete weather data'), findsOneWidget);
  });
}
