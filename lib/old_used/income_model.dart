// import 'package:flutter/material.dart';

// class IncomeModel extends ChangeNotifier {
//   // Private variables to hold the actual income values.
//   // They are nullable to represent an empty or invalid state.
//   double? _monthlyIncome;
//   double? _yearlyIncome;

//   // A flag to prevent infinite loops when updating the other field programmatically.
//   // This flag is now managed within the model itself.
//   bool _isUpdatingFromModel = false;

//   // Getters to expose the current income values.
//   // These are read-only from outside the model.
//   double? get monthlyIncome => _monthlyIncome;
//   double? get yearlyIncome => _yearlyIncome;

//   /// Updates the monthly income and calculates the corresponding yearly income.
//   /// Notifies listeners if values change.
//   void updateMonthlyIncome(String value) {
//     // Prevent re-entry if this update was triggered by the model itself.
//     if (_isUpdatingFromModel) return;

//     _isUpdatingFromModel = true; // Set flag to prevent loop

//     final double? parsedMonthly = double.tryParse(value);

//     // Only update if the parsed value is different to avoid unnecessary notifications.
//     if (parsedMonthly != _monthlyIncome) {
//       _monthlyIncome = parsedMonthly;
//       if (parsedMonthly != null && parsedMonthly >= 0) {
//         _yearlyIncome = parsedMonthly * 12;
//       } else {
//         _yearlyIncome = null; // Clear yearly if monthly is invalid/empty
//       }
//       notifyListeners(); // Notify widgets that depend on this model
//     }

//     _isUpdatingFromModel = false; // Reset flag
//   }

//   /// Updates the yearly income and calculates the corresponding monthly income.
//   /// Notifies listeners if values change.
//   void updateYearlyIncome(String value) {
//     // Prevent re-entry if this update was triggered by the model itself.
//     if (_isUpdatingFromModel) return;

//     _isUpdatingFromModel = true; // Set flag to prevent loop

//     final double? parsedYearly = double.tryParse(value);

//     // Only update if the parsed value is different to avoid unnecessary notifications.
//     if (parsedYearly != _yearlyIncome) {
//       _yearlyIncome = parsedYearly;
//       if (parsedYearly != null && parsedYearly >= 0) {
//         _monthlyIncome = parsedYearly / 12;
//       } else {
//         _monthlyIncome = null; // Clear monthly if yearly is invalid/empty
//       }
//       notifyListeners(); // Notify widgets that depend on this model
//     }

//     _isUpdatingFromModel = false; // Reset flag
//   }
// }
