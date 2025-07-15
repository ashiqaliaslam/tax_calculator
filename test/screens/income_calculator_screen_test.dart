import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tax_calculator/income_calculator_screen.dart';
import 'package:tax_calculator/income_provider.dart';
import 'package:tax_calculator/widgets/income_input_field.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ChangeNotifierProvider(
      create: (_) => IncomeProvider(),
      child: MaterialApp(home: child),
    );
  }

  group('IncomeCalculatorScreen', () {
    testWidgets('should display loading indicator initially', (tester) async {
      await tester.pumpWidget(createTestWidget(const IncomeCalculatorScreen()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(); // Wait for data to load
    });

    testWidgets('should display main UI after data loads', (tester) async {
      await tester.pumpWidget(createTestWidget(const IncomeCalculatorScreen()));
      await tester.pumpAndSettle(); // Wait for data to load

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(
        find.widgetWithText(IncomeInputField, 'Monthly Income'),
        findsOneWidget,
      );
    });

    testWidgets('Changing dropdown updates the selected year', (tester) async {
      await tester.pumpWidget(createTestWidget(const IncomeCalculatorScreen()));
      await tester.pumpAndSettle();

      // Open the dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Tap on the desired year
      await tester.tap(find.text('2023-2024').last);
      await tester.pumpAndSettle();

      // Verify the dropdown shows the new value
      expect(
        find.descendant(
          of: find.byType(DropdownButtonFormField<String>),
          matching: find.text('2023-2024'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Entering VPS contribution updates percentage text', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(const IncomeCalculatorScreen()));
      await tester.pumpAndSettle();

      final yearlyField = find.widgetWithText(
        IncomeInputField,
        'Yearly Income',
      );
      final vpsField = find.widgetWithText(
        IncomeInputField,
        'Contribution in VPS',
      );

      await tester.enterText(yearlyField, '1000000');
      await tester.pumpAndSettle();

      await tester.enterText(vpsField, '50000');
      await tester.pumpAndSettle();

      // 50,000 is 5.00% of 1,000,000
      expect(find.text('5.00% of annual income'), findsOneWidget);
    });
  });
}
