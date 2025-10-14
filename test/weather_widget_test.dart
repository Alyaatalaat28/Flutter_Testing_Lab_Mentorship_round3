import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  testWidgets('Shows loading indicator while fetching data', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Shows error message when API fails', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));
    //await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2));

    expect(find.textContaining('Exception'), findsWidgets);
  });

  testWidgets('Shows weather data when loaded successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

    await tester.pump(const Duration(seconds: 2)); // ننتظر انتهاء الـ Future

    expect(find.textContaining('°C'), findsWidgets);
  });
}
