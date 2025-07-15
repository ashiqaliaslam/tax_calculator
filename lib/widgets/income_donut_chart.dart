import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tax_calculator/currency_formatter.dart';

/// A widget that displays a concentric donut chart of the income breakdown.
class IncomeDonutChart extends StatefulWidget {
  final double yearlyIncome;
  final double takeHomePay;
  final double taxDeduction;
  final double vpsContribution;

  const IncomeDonutChart({
    super.key,
    required this.yearlyIncome,
    required this.takeHomePay,
    required this.taxDeduction,
    required this.vpsContribution,
  });

  @override
  State<IncomeDonutChart> createState() => _IncomeDonutChartState();
}

class _IncomeDonutChartState extends State<IncomeDonutChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Define colors for the inner ring
    final takeHomeColor = colors.primary;
    final taxColor = colors.error;
    final vpsColor = colors.secondary;

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // This is the outer ring representing "Total Income"
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 90,
                  sections: [
                    PieChartSectionData(
                      color: colors.surfaceContainerHighest,
                      value: 100,
                      title: '',
                      radius: 30,
                    ),
                  ],
                ),
              ),
              // This is the inner ring showing the breakdown
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
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
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: _buildInnerRingSections(
                    colors: colors,
                    takeHomeColor: takeHomeColor,
                    taxColor: taxColor,
                    vpsColor: vpsColor,
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
        const SizedBox(height: 24),
        // Legend
        _IndicatorRow(
          color: takeHomeColor,
          label: 'Take-home Pay',
          value: CurrencyFormatter.format(widget.takeHomePay),
        ),
        _IndicatorRow(
          color: taxColor,
          label: 'Tax Paid',
          value: CurrencyFormatter.format(widget.taxDeduction),
        ),
        if (widget.vpsContribution > 0)
          _IndicatorRow(
            color: vpsColor,
            label: 'VPS Contribution',
            value: CurrencyFormatter.format(widget.vpsContribution),
          ),
      ],
    );
  }

  List<PieChartSectionData> _buildInnerRingSections({
    required ColorScheme colors,
    required Color takeHomeColor,
    required Color taxColor,
    required Color vpsColor,
  }) {
    final isTouched = touchedIndex != -1;
    final safeTakeHomePay = widget.takeHomePay > 0 ? widget.takeHomePay : 0.0;
    final safeTaxDeduction = widget.taxDeduction > 0
        ? widget.taxDeduction
        : 0.0;
    final safeVpsContribution = widget.vpsContribution > 0
        ? widget.vpsContribution
        : 0.0;

    return [
      // Take-home Pay Slice
      PieChartSectionData(
        value: safeTakeHomePay,
        color: takeHomeColor,
        radius: isTouched && touchedIndex == 0 ? 30 : 25,
        title:
            '${(safeTakeHomePay / widget.yearlyIncome * 100).toStringAsFixed(0)}%',
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colors.onPrimary,
        ),
      ),
      // Tax Paid Slice
      PieChartSectionData(
        value: safeTaxDeduction,
        color: taxColor,
        radius: isTouched && touchedIndex == 1 ? 30 : 25,
        title:
            '${(safeTaxDeduction / widget.yearlyIncome * 100).toStringAsFixed(0)}%',
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colors.onError,
        ),
      ),
      // VPS Contribution Slice
      if (safeVpsContribution > 0)
        PieChartSectionData(
          value: safeVpsContribution,
          color: vpsColor,
          radius: isTouched && touchedIndex == 2 ? 30 : 25,
          title:
              '${(safeVpsContribution / widget.yearlyIncome * 100).toStringAsFixed(0)}%',
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colors.onSecondary,
          ),
        ),
    ];
  }
}

/// A reusable widget for displaying a row in the chart legend.
class _IndicatorRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _IndicatorRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;
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
