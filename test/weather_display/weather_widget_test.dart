import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

Widget wrapWithMaterial(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  testWidgets('Shows loading then weather card on success', (
    WidgetTester tester,
  ) async {
    Future<Map<String, dynamic>?> mockFetcher(String city) async {
      return {
        'city': city,
        'temperature': 20.0,
        'description': 'Sunny',
        'humidity': 55,
        'windSpeed': 4.2,
        'icon': '☀️',
      };
    }

    await tester.pumpWidget(
      wrapWithMaterial(WeatherDisplay(fetcher: mockFetcher)),
    );

    expect(find.byKey(const Key('loading')), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('weatherCard')), findsOneWidget);
    expect(find.byKey(const Key('temperatureText')), findsOneWidget);
  });

  testWidgets('Shows error when fetcher returns null', (
    WidgetTester tester,
  ) async {
    Future<Map<String, dynamic>?> mockNull(String city) async => null;

    await tester.pumpWidget(
      wrapWithMaterial(WeatherDisplay(fetcher: mockNull)),
    );

    expect(find.byKey(const Key('loading')), findsOneWidget);

    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('errorText')),
      findsNothing,
    ); // مافيش errorText key في الكود
  });

  testWidgets('Switch toggles temperature unit', (WidgetTester tester) async {
    Future<Map<String, dynamic>?> mockFetcher(String city) async {
      return {
        'city': city,
        'temperature': 0.0,
        'description': 'Cold',
        'humidity': 40,
        'windSpeed': 2.0,
        'icon': '❄️',
      };
    }

    await tester.pumpWidget(
      wrapWithMaterial(WeatherDisplay(fetcher: mockFetcher)),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('°C'), findsOneWidget);

    await tester.tap(find.byKey(const Key('unitSwitch')));
    await tester.pumpAndSettle();

    expect(find.textContaining('°F'), findsOneWidget);
  });
}
