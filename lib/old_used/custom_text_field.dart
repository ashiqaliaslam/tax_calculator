import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show TextInputFormatter, FilteringTextInputFormatter;

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required TextEditingController monthlyIncomeController,
    required this.labelText,
    required this.hintText,
    required this.icon,
  }) : _monthlyIncomeController = monthlyIncomeController;

  final TextEditingController _monthlyIncomeController;
  final String labelText;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _monthlyIncomeController,
      // Configure keyboard to show numbers and allow decimals.
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ), // Rounded corners for input field
          borderSide: BorderSide.none, // No explicit border line
        ),
        filled: true, // Fill the background
        // fillColor: Colors.white.withOpacity(0.9), // Light background color
        prefixIcon: Icon(
          icon,
          // Icons.attach_money,
          color: Colors.green,
        ), // Icon for currency
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
      ),
      style: const TextStyle(fontSize: 18, color: Colors.black87),
      // Input formatters to allow only numbers and up to two decimal places.
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
    );
  }
}
