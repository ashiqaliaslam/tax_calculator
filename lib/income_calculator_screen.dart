import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_calculator/widgets/final_breakdown_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'income_provider.dart';
import 'currency_formatter.dart';
import 'widgets/income_input_field.dart';

class IncomeCalculatorScreen extends StatefulWidget {
  const IncomeCalculatorScreen({super.key});

  @override
  State<IncomeCalculatorScreen> createState() => _IncomeCalculatorScreenState();
}

class _IncomeCalculatorScreenState extends State<IncomeCalculatorScreen> {
  final _monthlyController = TextEditingController();
  final _yearlyController = TextEditingController();
  final _vpsController = TextEditingController();

  final _monthlyFocusNode = FocusNode();
  final _yearlyFocusNode = FocusNode();
  final _vpsFocusNode = FocusNode();

  late final IncomeProvider _incomeProvider;

  @override
  void initState() {
    super.initState();
    _incomeProvider = Provider.of<IncomeProvider>(context, listen: false);
    _incomeProvider.addListener(_updateTextFields);
    _monthlyFocusNode.addListener(_onFocusChange);
    _yearlyFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    _updateTextFields();
  }

  void _updateTextFields() {
    final monthlyIncome = _incomeProvider.monthlyIncome;
    final yearlyIncome = _incomeProvider.yearlyIncome;

    if (!_monthlyFocusNode.hasFocus) {
      final String newText = monthlyIncome == 0
          ? ''
          : CurrencyFormatter.format(monthlyIncome);
      if (_monthlyController.text != newText) {
        _monthlyController.text = newText;
      }
    }
    if (!_yearlyFocusNode.hasFocus) {
      final String newText = yearlyIncome == 0
          ? ''
          : CurrencyFormatter.format(yearlyIncome);
      if (_yearlyController.text != newText) {
        _yearlyController.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _monthlyController.dispose();
    _yearlyController.dispose();
    _vpsController.dispose();
    _monthlyFocusNode.removeListener(_onFocusChange);
    _yearlyFocusNode.removeListener(_onFocusChange);
    _monthlyFocusNode.dispose();
    _yearlyFocusNode.dispose();
    _vpsFocusNode.dispose();
    _incomeProvider.removeListener(_updateTextFields);
    super.dispose();
  }

  String _formatYearForChip(String year) {
    final parts = year.split('-');
    if (parts.length == 2 && parts[0].length == 4 && parts[1].length == 4) {
      final startYear = parts[0].substring(2);
      final endYear = parts[1].substring(2);
      return 'FY$startYear-$endYear';
    }
    return year;
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // Show a snackbar if the URL can't be launched
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Tax Calculator',
                applicationVersion: '1.0.0',
                applicationLegalese: '©2025 Ashique Ali',
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Text('A simple and elegant income tax calculator.'),
                  ),
                  // Clickable LinkedIn Link
                  InkWell(
                    onTap: () =>
                        _launchURL('https://linkedin.com/in/ashiqaliaslam'),
                    child: Text(
                      'LinkedIn Profile',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Clickable Bio Link
                  InkWell(
                    onTap: () => _launchURL('https://bio.link/ashiqaliaslam'),
                    child: Text(
                      'More Bio Links',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<IncomeProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case ViewState.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewState.error:
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Failed to load tax data.\nPlease check assets/tax_slabs.json and restart the app.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            case ViewState.ready:
              return _buildCalculatorUI(provider);
          }
        },
      ),
    );
  }

  Widget _buildCalculatorUI(IncomeProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        IncomeInputField(
          controller: _monthlyController,
          focusNode: _monthlyFocusNode,
          labelText: 'Monthly Income',
          icon: Icons.calendar_today,
          onChanged: (value) {
            final monthlyIncome = CurrencyFormatter.parse(value);
            provider.updateMonthlyIncome(monthlyIncome);
          },
        ),
        const SizedBox(height: 16),
        IncomeInputField(
          controller: _yearlyController,
          focusNode: _yearlyFocusNode,
          labelText: 'Yearly Income',
          icon: Icons.calendar_month,
          onChanged: (value) {
            final yearlyIncome = CurrencyFormatter.parse(value);
            provider.updateYearlyIncome(yearlyIncome);
          },
        ),
        const SizedBox(height: 16),
        Tooltip(
          message: 'Voluntary Pension Scheme',
          child: IncomeInputField(
            controller: _vpsController,
            focusNode: _vpsFocusNode,
            labelText: 'Contribution in VPS',
            icon: Icons.trending_up,
            onChanged: (value) {
              final vpsContribution = CurrencyFormatter.parse(value);
              provider.updateVpsContribution(vpsContribution);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${provider.vpsPercentage.toStringAsFixed(2)}% of annual income',
                style: textTheme.bodySmall,
              ),
              if (provider.yearlyIncome > 0)
                Text(
                  'Cap: ${CurrencyFormatter.format(provider.yearlyIncome * 0.2)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.secondary,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Tax Year', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: provider.availableYears.length,
            itemBuilder: (context, index) {
              final year = provider.availableYears[index];
              final isSelected = provider.selectedYear == year;
              return ChoiceChip(
                label: Text(_formatYearForChip(year)),
                selected: isSelected,
                showCheckmark: false,
                onSelected: (bool selected) {
                  if (selected) {
                    provider.setSelectedYear(year);
                  }
                },
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
                backgroundColor: colorScheme.surfaceContainer,
                shape: const StadiumBorder(),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 8),
          ),
        ),
        if (provider.yearlyIncome > 0) ...[
          const Divider(height: 32),
          FinalBreakdownChart(
            yearlyIncome: provider.yearlyIncome,
            takeHomePay: provider.takeHomePay,
            taxDeduction: provider.taxDeduction,
            taxRebate: provider.taxRebate,
          ),
        ],
      ],
    );
  }
}
