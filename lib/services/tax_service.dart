import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';

// Data model for a single tax slab
class TaxSlab {
  final int min;
  final int? max;
  final int fixed;
  final double rate;
  final int excess;

  TaxSlab({
    required this.min,
    this.max,
    required this.fixed,
    required this.rate,
    required this.excess,
  });

  factory TaxSlab.fromJson(Map<String, dynamic> json) {
    return TaxSlab(
      min: json['min'],
      max: json['max'],
      fixed: json['fixed'],
      rate: (json['rate'] as num).toDouble(),
      excess: json['excess'],
    );
  }
}

// Data model for a full year's tax rules
class TaxYear {
  final String year;
  final List<TaxSlab> slabs;
  final Map<String, dynamic>? surcharge;

  TaxYear({required this.year, required this.slabs, this.surcharge});

  factory TaxYear.fromJson(Map<String, dynamic> json) {
    var slabList = json['slabs'] as List;
    List<TaxSlab> slabs = slabList.map((i) => TaxSlab.fromJson(i)).toList();
    return TaxYear(
      year: json['year'],
      slabs: slabs,
      surcharge: json['surcharge'],
    );
  }
}

class TaxService {
  List<TaxYear> _taxYears = [];

  // Load the tax data from the JSON file
  Future<void> loadTaxData() async {
    final String response = await rootBundle.loadString(
      'assets/tax_slabs.json',
    );
    final data = await json.decode(response);
    var yearList = data['tax_years'] as List;
    _taxYears = yearList.map((i) => TaxYear.fromJson(i)).toList();
  }

  List<String> getAvailableYears() {
    return _taxYears.map((e) => e.year).toList();
  }

  // Calculate the tax based on income and selected year
  double calculateTax(String year, double taxableIncome) {
    if (_taxYears.isEmpty) return 0.0;

    final taxYear = _taxYears.firstWhere((e) => e.year == year);
    final slab = taxYear.slabs.firstWhere(
      (s) =>
          taxableIncome >= s.min && (s.max == null || taxableIncome <= s.max!),
      orElse: () => taxYear.slabs.first,
    );

    double tax = slab.fixed + (taxableIncome - slab.excess) * slab.rate;

    // Apply surcharge if applicable
    if (taxYear.surcharge != null &&
        taxableIncome > taxYear.surcharge!['threshold']) {
      tax += tax * taxYear.surcharge!['rate'];
    }

    return tax;
  }

  // --- UPDATED VPS REBATE LOGIC ---
  double calculateVpsRebate({
    required String year,
    required double yearlyIncome,
    required double vpsContribution,
  }) {
    if (yearlyIncome == 0) return 0.0;

    // 1. Calculate the contribution as a percentage of annual income.
    final double contributionPercentage = vpsContribution / yearlyIncome;

    // 2. The rebate percentage is capped at a maximum of 20%.
    final double rebatePercentage = min(contributionPercentage, 0.20);

    // 3. Calculate the gross tax before any rebates.
    final double grossTax = calculateTax(year, yearlyIncome);

    // 4. The final rebate is the capped percentage of the gross tax.
    return grossTax * rebatePercentage;
  }
}
