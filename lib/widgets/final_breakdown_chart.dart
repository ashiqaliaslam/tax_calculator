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
          label: 'Tax Deductible',
          infoMessage:
              """Tax Deductible under section 149 (specified in the Income Tax Ordinance,

On account of Salary,""",
          value: CurrencyFormatter.formatNoDecimal(widget.taxDeduction),
          monthlyValue: CurrencyFormatter.formatNoDecimal(
            widget.taxDeduction / 12,
          ),
        ),
        _IndicatorRow(
          color: takeHomeColor,
          label: 'Take-home Pay',
          infoMessage:
              'This Take-home pay is calculated on default tax slabs (means this calculation is without Tax Credit due to VPS investment)',
          value: CurrencyFormatter.formatNoDecimal(widget.takeHomePay),
          monthlyValue: CurrencyFormatter.formatNoDecimal(
            widget.takeHomePay / 12,
          ),
        ),
        if (widget.taxRebate > 0)
          _IndicatorRow(
            color: rebateColor,
            label: 'Tax Rebate',
            infoMessage:
                'As per Section 63 of the Income Tax Ordinance, 2001, you can claim a tax credit on investments made in a Voluntary Pension Scheme (VPS). This credit directly reduces your final tax liability, promoting savings for retirement.',
            value: CurrencyFormatter.formatNoDecimal(widget.taxRebate),
            monthlyValue: CurrencyFormatter.formatNoDecimal(
              widget.taxRebate / 12,
            ),
          ),
        const Divider(height: 24),
        _IndicatorRow(
          color: Colors.transparent, // No color dot for the total
          label: 'Total In-Hand',
          infoMessage:
              'In-Hand = Take-home Pay + Tax Credit (Tax Credit due to Investment in VPS)',
          value: CurrencyFormatter.formatNoDecimal(totalInHand),
          monthlyValue: CurrencyFormatter.formatNoDecimal(totalInHand / 12),
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
  final String monthlyValue;
  final bool isBold;
  final String infoMessage;

  const _IndicatorRow({
    required this.color,
    required this.label,
    required this.value,
    required this.monthlyValue,
    this.isBold = false,
    required this.infoMessage,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: style)),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(label),
                      content: Text(infoMessage),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.info_outline),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text('Yearly:'),
                    SizedBox(width: 2),
                    Text(
                      value,
                      style: style?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Monthly:'),
                    SizedBox(width: 2),
                    Text(
                      monthlyValue,
                      style: style?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
