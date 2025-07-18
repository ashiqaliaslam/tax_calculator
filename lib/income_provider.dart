import 'package:flutter/foundation.dart';
import 'package:tax_calculator/services/tax_service.dart';

enum ViewState { loading, ready, error }

class IncomeProvider with ChangeNotifier {
  final TaxService _taxService = TaxService();

  double _yearlyIncome = 0.0;
  double _vpsContribution = 0.0;
  String _selectedYear = '';
  List<String> _availableYears = [];
  ViewState _state = ViewState.loading;

  IncomeProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      await _taxService.loadTaxData();
      _availableYears = _taxService.getAvailableYears();
      if (_availableYears.isNotEmpty) {
        _selectedYear = _availableYears.first;
      }
      _state = ViewState.ready;
    } catch (e) {
      debugPrint("Error loading tax data: $e");
      _state = ViewState.error;
    }
    notifyListeners();
  }

  // --- Getters for state ---
  ViewState get state => _state;
  double get yearlyIncome => _yearlyIncome;
  double get monthlyIncome => _yearlyIncome / 12.0;
  double get vpsContribution => _vpsContribution;
  String get selectedYear => _selectedYear;
  List<String> get availableYears => _availableYears;

  // --- Getters for calculated values ---
  double get totalTaxableIncome => _yearlyIncome;

  double get vpsPercentage {
    if (_yearlyIncome == 0) return 0.0;
    return (_vpsContribution / _yearlyIncome) * 100;
  }

  double get grossTax {
    if (_state != ViewState.ready || _selectedYear.isEmpty) return 0.0;
    return _taxService.calculateTax(_selectedYear, _yearlyIncome);
  }

  double get taxRebate {
    if (_state != ViewState.ready || _selectedYear.isEmpty) return 0.0;
    return _taxService.calculateVpsRebate(
      year: _selectedYear,
      yearlyIncome: _yearlyIncome,
      vpsContribution: _vpsContribution,
    );
  }

  double get taxDeduction {
    if (_state != ViewState.ready || _selectedYear.isEmpty) return 0.0;
    final finalTax = grossTax - taxRebate;
    return finalTax > 0 ? finalTax : 0.0;
  }

  // UPDATED: takeHomePay is now calculated based on your new model.
  double get takeHomePay {
    // Total Income = takeHomePay + taxDeduction + taxRebate
    return _yearlyIncome - taxDeduction - taxRebate;
  }

  // --- Updaters ---
  void updateYearlyIncome(double newYearlyIncome) {
    if (_yearlyIncome != newYearlyIncome) {
      _yearlyIncome = newYearlyIncome;
      notifyListeners();
    }
  }

  void updateMonthlyIncome(double newMonthlyIncome) {
    final newYearlyIncome = newMonthlyIncome * 12.0;
    if (_yearlyIncome != newYearlyIncome) {
      _yearlyIncome = newYearlyIncome;
      notifyListeners();
    }
  }

  void updateVpsContribution(double newVpsContribution) {
    if (_vpsContribution != newVpsContribution) {
      _vpsContribution = newVpsContribution;
      notifyListeners();
    }
  }

  void setSelectedYear(String year) {
    if (_selectedYear != year) {
      _selectedYear = year;
      notifyListeners();
    }
  }
}
