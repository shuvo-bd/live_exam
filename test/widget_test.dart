import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_exam/app.dart';

void main() {
  testWidgets('converts Celsius and Fahrenheit', (tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    await tester.enterText(find.byKey(const ValueKey('temperatureInput')), '0');
    await tester.tap(find.byKey(const ValueKey('calculateButton')));
    await tester.pumpAndSettle();
    expect(find.text('32.00 °F'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('conversionType')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fahrenheit to Celsius (°F → °C)').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('temperatureInput')),
      '32',
    );
    await tester.tap(find.byKey(const ValueKey('calculateButton')));
    await tester.pumpAndSettle();
    expect(find.text('0.00 °C'), findsOneWidget);
  });

  testWidgets('shows validation messages for empty and invalid values', (
    tester,
  ) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    await tester.tap(find.byKey(const ValueKey('calculateButton')));
    await tester.pumpAndSettle();
    expect(find.text('Please enter a temperature.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('temperatureInput')),
      'not a number',
    );
    await tester.pumpAndSettle();
    expect(find.text('Please enter a valid number.'), findsOneWidget);
  });
}
