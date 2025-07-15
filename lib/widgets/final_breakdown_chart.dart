import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tax_calculator/currency_formatter.dart';

/// A widget that displays a donut chart of the income breakdown into
/// Take-home Pay, Tax Paid, and Tax Rebate.
class FinalBreakdownChart extends StatefulWidget {
  final double yearlyIncome;
  final double takeHomePay;
  final double taxDeduction;
  final double taxRebate;

  const FinalBreakdownChart({
    super.key,
    required this.yearlyIncome,
    required this.takeHomePay,
    required this.taxDeduction,
    required this.taxRebate,
  });

  @override
  State<FinalBreakdownChart> createState() => _FinalBreakdownChartState();
}

class _FinalBreakdownChartState extends State<FinalBreakdownChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Define colors for the sections
    final takeHomeColor = colors.primary;
    final taxColor = colors.error;
    final rebateColor = Colors.green.shade600;

    // This is the final value the user sees in their bank account.
    final totalInHand = widget.takeHomePay + widget.taxRebate;

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // FIX: Dismiss the keyboard whenever the chart is touched.
                      FocusManager.instance.primaryFocus?.unfocus();

                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                      });
                    },
                  ),
                  sectionsSpace: 4,
                  centerSpaceRadius: 70, // Adjusts the size of the center hole
                  sections: _buildChartSections(
                    colors: colors,
                    takeHomeColor: takeHomeColor,
                    taxColor: taxColor,
                    rebateColor: rebateColor,
                  ),
                ),
              ),
              // Center Text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total Income', style: textTheme.bodyMedium),
                  Text(
                    CurrencyFormatter.format(widget.yearlyIncome),
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        _IndicatorRow(
          color: taxColor,
          label: 'Tax Paid',
          value: CurrencyFormatter.format(widget.taxDeduction),
        ),
        _IndicatorRow(
          color: takeHomeColor,
          label: 'Take-home Pay (Net)',
          value: CurrencyFormatter.format(widget.takeHomePay),
        ),
        if (widget.taxRebate > 0)
          _IndicatorRow(
            color: rebateColor,
            label: 'Tax Rebate',
            value: CurrencyFormatter.format(widget.taxRebate),
          ),
        const Divider(height: 24),
        _IndicatorRow(
          color: Colors.transparent, // No color dot for the total
          label: 'Total In-Hand',
          value: CurrencyFormatter.format(totalInHand),
          isBold: true,
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildChartSections({
    required ColorScheme colors,
    required Color takeHomeColor,
    required Color taxColor,
    required Color rebateColor,
  }) {
    final isTouched = touchedIndex != -1;
    final safeTakeHomePay = widget.takeHomePay > 0 ? widget.takeHomePay : 0.0;
    final safeTaxDeduction = widget.taxDeduction > 0
        ? widget.taxDeduction
        : 0.0;
    final safeTaxRebate = widget.taxRebate > 0 ? widget.taxRebate : 0.0;

    return [
      // 1. Take-home Pay Slice
      _buildSection(
        value: safeTakeHomePay,
        color: takeHomeColor,
        isTouched: isTouched && touchedIndex == 0,
        textColor: colors.onPrimary,
      ),
      // 2. Tax Paid Slice
      _buildSection(
        value: safeTaxDeduction,
        color: taxColor,
        isTouched: isTouched && touchedIndex == 1,
        textColor: colors.onError,
      ),
      // 3. Tax Rebate Slice
      if (safeTaxRebate > 0)
        _buildSection(
          value: safeTaxRebate,
          color: rebateColor,
          isTouched: isTouched && touchedIndex == 2,
          textColor: Colors.white,
        ),
    ];
  }

  PieChartSectionData _buildSection({
    required double value,
    required Color color,
    required bool isTouched,
    required Color textColor,
  }) {
    final theme = Theme.of(context);
    // Increased radius for a thicker donut
    final radius = isTouched ? 50.0 : 40.0;
    final percentage = (value / widget.yearlyIncome * 100);

    // Threshold to decide when to move the label outside
    const double outsideLabelThreshold = 5.0;
    final bool isLabelOutside = percentage < outsideLabelThreshold;

    return PieChartSectionData(
      value: value,
      color: color,
      radius: radius,
      title: '${percentage.toStringAsFixed(1)}%',
      // Move title outside for small slices
      titlePositionPercentageOffset: isLabelOutside ? 1.5 : 0.6,
      titleStyle: TextStyle(
        fontSize: isTouched ? 16 : 14,
        fontWeight: FontWeight.bold,
        // Use a standard text color if label is outside
        color: isLabelOutside ? theme.textTheme.bodyLarge?.color : textColor,
      ),
    );
  }
}

/// A reusable widget for displaying a row in the chart legend.
class _IndicatorRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final bool isBold;

  const _IndicatorRow({
    required this.color,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: style)),
          Text(value, style: style?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
