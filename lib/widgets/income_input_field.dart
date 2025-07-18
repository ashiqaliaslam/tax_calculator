import 'package:flutter/material.dart';
import '../currency_input_formatter.dart';

/// A reusable text form field specifically for currency input.
class IncomeInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const IncomeInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(fontWeight: FontWeight.bold),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [RealtimeCurrencyInputFormatter()],
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        suffixText: 'PKR',
        suffixStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),
      onChanged: onChanged,
    );
  }
}
