import 'package:flutter/material.dart';

/// A reusable row for displaying a label and a formatted currency value.
class ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isFinalResult;

  const ResultRow({
    super.key,
    required this.label,
    required this.value,
    this.isFinalResult = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valueStyle = isFinalResult
        ? textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.bodyLarge),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
