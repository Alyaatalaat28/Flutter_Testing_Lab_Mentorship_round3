import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  testWidgets('shows loading then success', (tester) async {
    final fetcher = (String city) async {
      // add a small delay so the widget shows a loading indicator
      await Future.delayed(const Duration(milliseconds: 50));
      return {
        'city': city,
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 50,
        'windSpeed': 3.4,
        'icon': '☀️'
      };
    };

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: WeatherDisplay(fetcher: fetcher))));

    // initial loading should show progress indicator
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // allow async work to complete
    await tester.pumpAndSettle();

    expect(find.textContaining('°C'), findsOneWidget);
    expect(find.text('Sunny'), findsOneWidget);
  });

  testWidgets('shows error when fetcher returns null', (tester) async {
    final fetcher = (String city) async => null;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: WeatherDisplay(fetcher: fetcher))));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to load weather data'), findsOneWidget);
  });
}
