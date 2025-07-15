import 'package:flutter_test/flutter_test.dart';
import 'package:tax_calculator/currency_formatter.dart'; // Adjust import if needed

void main() {
  group('CurrencyFormatter', () {
    // --- Test the format() method ---
    group('format', () {
      test('should format whole numbers without decimal places', () {
        expect(CurrencyFormatter.format(1200), '1,200');
        expect(CurrencyFormatter.format(1234567), '1,234,567');
        expect(CurrencyFormatter.format(0), '0');
      });

      test('should format numbers with decimals to two places', () {
        expect(CurrencyFormatter.format(1200.5), '1,200.50');
        expect(CurrencyFormatter.format(1234.56), '1,234.56');
        expect(
          CurrencyFormatter.format(1234.567),
          '1,234.57',
        ); // Checks rounding
      });

      test('should handle edge cases gracefully', () {
        expect(CurrencyFormatter.format(0.5), '0.50');
        expect(CurrencyFormatter.format(999999.99), '999,999.99');
      });
    });

    // --- Test the parse() method ---
    group('parse', () {
      test('should parse formatted strings correctly', () {
        expect(CurrencyFormatter.parse('1,200'), 1200.0);
        expect(CurrencyFormatter.parse('1,234,567'), 1234567.0);
        expect(CurrencyFormatter.parse('1,200.50'), 1200.50);
      });

      test('should parse unformatted strings correctly', () {
        expect(CurrencyFormatter.parse('1200'), 1200.0);
        expect(CurrencyFormatter.parse('1200.50'), 1200.50);
      });

      test('should return 0.0 for empty or invalid strings', () {
        expect(CurrencyFormatter.parse(''), 0.0);
        expect(CurrencyFormatter.parse('abc'), 0.0);
      });
    });
  });
}
