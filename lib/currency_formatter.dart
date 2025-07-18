import 'package:intl/intl.dart';

/// A utility class to handle currency formatting and parsing.
class CurrencyFormatter {
  // Formatter for values that have a fractional part.
  static final _decimalCurrencyFormat = NumberFormat.currency(
    locale: 'en_PK',
    // symbol: 'PKR ',
    symbol: '',
    decimalDigits: 1,
  );

  // Formatter for whole numbers (integers).
  static final _integerCurrencyFormat = NumberFormat.currency(
    locale: 'en_PK',
    // symbol: 'PKR ',
    symbol: '',
    decimalDigits: 0,
  );

  /// Formats a double value into a PKR currency string.
  /// It shows decimal places only if they are not zero.
  /// e.g., 1200.50 -> "PKR 1,200.50"
  /// e.g., 1200.00 -> "PKR 1,200"
  static String format(double value) {
    // To avoid floating-point inaccuracies, we check the value in its smallest unit (paisas).
    // If the number of paisas is a multiple of 100, it's a whole number.
    if ((value * 100).round() % 100 != 0) {
      // Has a non-zero fractional part, so use the decimal formatter.
      return _decimalCurrencyFormat.format(value);
    } else {
      // Is a whole number, so use the integer formatter.
      return _integerCurrencyFormat.format(value);
    }
  }

  static String formatNoDecimal(double value) {
    return _integerCurrencyFormat.format(value);
  }

  /// Parses a string (which may contain currency symbols and commas) into a double.
  /// It safely handles both formatted ("PKR 1,234.56") and unformatted ("1234.56") input.
  static double parse(String text) {
    if (text.isEmpty) return 0.0;
    // This regular expression removes any character that is not a digit or a decimal point.
    final sanitizedText = text.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(sanitizedText) ?? 0.0;
  }
}
