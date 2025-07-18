import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A TextInputFormatter that formats the input as a currency value in real-time,
/// allowing for natural, calculator-style input while maintaining cursor position.
class RealtimeCurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Sanitize the new text
    String newSanitizedText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');
    if (newSanitizedText.split('.').length > 2) {
      return oldValue; // Revert if more than one decimal point
    }
    if (newSanitizedText.isEmpty) {
      return const TextEditingValue();
    }

    // 2. Format the sanitized text
    String formattedText = _format(newSanitizedText);

    // 3. Calculate the new cursor position
    int oldCommas = oldValue.text.split(',').length - 1;
    int newCommas = formattedText.split(',').length - 1;
    int commaDifference = newCommas - oldCommas;

    int newCursorOffset = newValue.selection.baseOffset + commaDifference;

    if (newCursorOffset > formattedText.length) {
      newCursorOffset = formattedText.length;
    }
    if (newCursorOffset < 0) {
      newCursorOffset = 0;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }

  String _format(String text) {
    String integerPart;
    String? fractionalPart;
    if (text.contains('.')) {
      final parts = text.split('.');
      integerPart = parts[0];
      fractionalPart = parts.length > 1 ? parts[1] : null;
    } else {
      integerPart = text;
      fractionalPart = null;
    }

    final integerFormatter = NumberFormat('#,##0', 'en_US');
    final formattedIntegerPart = integerFormatter.format(
      int.tryParse(integerPart.isEmpty ? '0' : integerPart) ?? 0,
    );

    if (fractionalPart != null) {
      final truncatedFractional = fractionalPart.length > 1
          ? fractionalPart.substring(0, 1)
          : fractionalPart;
      return '$formattedIntegerPart.$truncatedFractional';
    } else {
      return formattedIntegerPart;
    }
  }
}
