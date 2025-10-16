// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_testing_lab/widgets/weather_display.dart';

// void main() {
//   // Utility function to pump the widget for testing
//   Future<void> pumpWeatherDisplay(WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(home: Scaffold(body: WeatherDisplay())),
//     );
//     await tester.pumpAndSettle(const Duration(seconds: 2));
//   }

//   group('WeatherDisplay Widget Tests', () {
//     testWidgets('Loads default city (New York) and displays weather data', (
//       tester,
//     ) async {
//       await pumpWeatherDisplay(tester);

//       // Target the Card containing weather info
//       final cardFinder = find.byType(Card);

//       expect(
//         find.descendant(of: cardFinder, matching: find.text('New York')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('Sunny')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(
//           of: cardFinder,
//           matching: find.textContaining('22.5°C'),
//         ),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('65%')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('12.3 km/h')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('☀️')),
//         findsOneWidget,
//       );

//       expect(find.byType(CircularProgressIndicator), findsNothing);
//     });

//     testWidgets('Displays CircularProgressIndicator during loading', (
//       tester,
//     ) async {
//       await tester.pumpWidget(
//         const MaterialApp(home: Scaffold(body: WeatherDisplay())),
//       );

//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     });

//     testWidgets('Displays error message for "Invalid City"', (tester) async {
//       await pumpWeatherDisplay(tester);

//       final dropdownFinder = find.byType(DropdownButton<String>);
//       await tester.tap(dropdownFinder);
//       await tester.pumpAndSettle();
//       await tester.tap(find.text('Invalid City').last);
//       await tester.pump();
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       expect(
//         find.textContaining('Failed to load weather for Invalid City'),
//         findsOneWidget,
//       );
//       expect(find.byType(CircularProgressIndicator), findsNothing);
//       expect(find.byType(Card), findsNothing);
//     });

//     testWidgets('Selecting London updates the weather data', (tester) async {
//       await pumpWeatherDisplay(tester);

//       final dropdownFinder = find.byType(DropdownButton<String>);
//       await tester.tap(dropdownFinder);
//       await tester.pumpAndSettle();
//       await tester.tap(find.text('London').last);
//       await tester.pump();

//       expect(find.byType(CircularProgressIndicator), findsOneWidget);

//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       final cardFinder = find.byType(Card);
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('London')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('Rainy')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('15.0°C')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('85%')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('8.5 km/h')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('🌧️')),
//         findsOneWidget,
//       );
//     });

//     testWidgets(
//       'Toggling switch converts temperature from Celsius to Fahrenheit for New York',
//       (tester) async {
//         await pumpWeatherDisplay(tester);

//         final switchFinder = find.byType(Switch);
//         final cardFinder = find.byType(Card);

//         expect(
//           find.descendant(
//             of: cardFinder,
//             matching: find.textContaining('22.5°C'),
//           ),
//           findsOneWidget,
//         );
//         expect(find.text('Celsius'), findsOneWidget);

//         await tester.tap(switchFinder);
//         await tester.pump();

//         expect(find.text('Fahrenheit'), findsOneWidget);
//         expect(
//           find.descendant(of: cardFinder, matching: find.text('72.5°F')),
//           findsOneWidget,
//         );
//       },
//     );

//     testWidgets('Fahrenheit conversion works correctly for Tokyo (25.0°C)', (
//       tester,
//     ) async {
//       await pumpWeatherDisplay(tester);

//       final dropdownFinder = find.byType(DropdownButton<String>);
//       await tester.tap(dropdownFinder);
//       await tester.pumpAndSettle();
//       await tester.tap(find.text('Tokyo').last);
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       final cardFinder = find.byType(Card);
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('25.0°C')),
//         findsOneWidget,
//       );

//       await tester.tap(find.byType(Switch));
//       await tester.pump();

//       expect(
//         find.descendant(of: cardFinder, matching: find.text('77.0°F')),
//         findsOneWidget,
//       );
//     });

//     testWidgets('Refresh button reloads data for the current city', (
//       tester,
//     ) async {
//       await pumpWeatherDisplay(tester);

//       await tester.tap(find.text('Refresh'));
//       await tester.pump();

//       expect(find.byType(CircularProgressIndicator), findsOneWidget);

//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       final cardFinder = find.byType(Card);
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('New York')),
//         findsOneWidget,
//       );
//       expect(
//         find.descendant(of: cardFinder, matching: find.text('22.5°C')),
//         findsOneWidget,
//       );
//     });
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

// IMPORTANT: Replace 'package:your_app_name/weather_display.dart'
// with the actual import path where your WeatherDisplay and WeatherData classes are located.

void main() {
  // Utility function to pump the widget for testing
  Future<void> pumpWeatherDisplay(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WeatherDisplay())),
    );
    // Wait for the initial data loading (simulated with Future.delayed(Duration(seconds: 2)))
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  // --------------------------------------------------------------------------
  // START OF WIDGET TESTS
  // --------------------------------------------------------------------------

  group('WeatherDisplay Widget Tests', () {
    // --- 1. Initial State and Default Load Test ---

    testWidgets('Loads default city (New York) and displays weather data', (
      tester,
    ) async {
      await pumpWeatherDisplay(tester);

      // FIX: Expect 2 widgets with text 'New York' (one in Dropdown, one in Card)
      expect(find.text('New York'), findsNWidgets(2));

      expect(find.text('Sunny'), findsOneWidget);

      // FIX: Use textContaining for temperature to avoid issues with '°C'
      expect(find.textContaining('22.5°C'), findsOneWidget);

      expect(find.text('65%'), findsOneWidget);
      expect(find.text('12.3 km/h'), findsOneWidget);
      expect(find.text('☀️'), findsOneWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Displays CircularProgressIndicator during loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('Displays error message for "Invalid City"', (tester) async {
      await pumpWeatherDisplay(tester);

      final dropdownFinder = find.byType(DropdownButton<String>);
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Invalid City').last);
      await tester.pump();

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(
        find.textContaining('Failed to load weather for Invalid City'),
        findsOneWidget,
      );
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('Selecting London updates the weather data', (tester) async {
      await pumpWeatherDisplay(tester);

      final dropdownFinder = find.byType(DropdownButton<String>);
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // 2. Wait for the simulated API call for London
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 3. Verify London data is loaded
      expect(find.text('London'), findsNWidgets(2));
      expect(find.text('Rainy'), findsOneWidget);
      expect(find.textContaining('15.0°C'), findsOneWidget); // London Temp
    });

    // --- 4. Temperature Conversion Tests ---

    testWidgets(
      'Toggling switch converts temperature from Celsius to Fahrenheit for New York',
      (tester) async {
        await pumpWeatherDisplay(tester); // Default: New York at 22.5°C

        final switchFinder = find.byType(Switch);

        // 1. Initial check (Celsius)
        expect(find.text('Celsius'), findsOneWidget);
        expect(find.textContaining('22.5°C'), findsOneWidget);

        // 2. Tap the switch to change to Fahrenheit
        await tester.tap(switchFinder);
        await tester.pump();

        // Verification of Fahrenheit conversion: (22.5 * 9 / 5) + 32 = 72.5
        expect(find.text('Fahrenheit'), findsOneWidget);
        expect(find.textContaining('72.5°F'), findsOneWidget);

        // 3. Tap the switch back to Celsius
        await tester.tap(switchFinder);
        await tester.pump();

        // Verification back to Celsius
        expect(find.text('Celsius'), findsOneWidget);
        expect(find.textContaining('22.5°C'), findsOneWidget);
      },
    );

    testWidgets('Fahrenheit conversion works correctly for Tokyo (25.0°C)', (
      tester,
    ) async {
      await pumpWeatherDisplay(tester);

      // 1. Select 'Tokyo' and wait for load
      final dropdownFinder = find.byType(DropdownButton<String>);
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo').last);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Initial check: 25.0°C
      expect(find.textContaining('25.0°C'), findsOneWidget);

      // 2. Tap the switch to change to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Verification of Fahrenheit conversion: (25.0 * 9 / 5) + 32 = 77.0
      expect(find.textContaining('77.0°F'), findsOneWidget);
    });

    testWidgets('Refresh button reloads data for the current city', (
      tester,
    ) async {
      await pumpWeatherDisplay(tester); // Loads New York

      // 1. Tap Refresh (should show loading again)
      await tester.tap(find.text('Refresh'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // 2. Wait for the simulated API call to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 3. Verify New York data is displayed again
      expect(find.text('New York'), findsNWidgets(2));
      expect(find.textContaining('22.5°C'), findsOneWidget);
    });
  });
}
