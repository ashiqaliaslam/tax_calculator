import 'package:flutter_test/flutter_test.dart';
import 'package:tax_calculator/income_provider.dart'; // Adjust import path as needed

void main() {
  group('IncomeProvider', () {
    late IncomeProvider incomeProvider;

    setUp(() {
      incomeProvider = IncomeProvider();
    });

    test('Initial values should be 0', () {
      expect(incomeProvider.yearlyIncome, 0.0);
      expect(incomeProvider.monthlyIncome, 0.0);
    });

    test('updateYearlyIncome should update both yearly and monthly income', () {
      incomeProvider.updateYearlyIncome(120000.0);
      expect(incomeProvider.yearlyIncome, 120000.0);
      expect(incomeProvider.monthlyIncome, 10000.0);
    });

    test(
      'updateMonthlyIncome should update both monthly and yearly income',
      () {
        incomeProvider.updateMonthlyIncome(15000.0);
        expect(incomeProvider.monthlyIncome, 15000.0);
        expect(incomeProvider.yearlyIncome, 180000.0);
      },
    );

    test('Updating with the same value should not trigger notifyListeners', () {
      int listenerCallCount = 0;
      incomeProvider.addListener(() {
        listenerCallCount++;
      });

      incomeProvider.updateYearlyIncome(60000.0); // First call
      expect(listenerCallCount, 1);

      incomeProvider.updateYearlyIncome(60000.0); // Second call with same value
      expect(listenerCallCount, 1); // Should not increase
    });
  });
}

// import 'package:flutter_test/flutter_test.dart';
// import 'package:tax_calculator/income_provider.dart';
// import 'package:tax_calculator/services/tax_service.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';

// import 'income_provider_test.mocks.dart';

// // This annotation generates the mock file
// @GenerateMocks([TaxService])
// void main() {
//   late MockTaxService mockTaxService;
//   late IncomeProvider incomeProvider;

//   setUp(() {
//     mockTaxService = MockTaxService();
//     // We can't directly inject the mock, so this is a workaround for this structure.
//     // In a more complex app, you'd use a dependency injection framework.
//     // For now, we'll test the logic that uses the service's results.
//     incomeProvider = IncomeProvider();
//   });

//   group('IncomeProvider with Calculations', () {
//     test('Initial calculation values should be 0', () {
//       expect(incomeProvider.taxDeduction, 0);
//       expect(incomeProvider.taxRebate, 0);
//       expect(incomeProvider.takeHomePay, 0);
//     });

//     test('setSelectedYear updates the selected year and notifies listeners', () {
//       int listenerCallCount = 0;
//       incomeProvider.addListener(() {
//         listenerCallCount++;
//       });

//       incomeProvider.setSelectedYear('2023-2024');

//       expect(incomeProvider.selectedYear, '2023-2024');
//       expect(listenerCallCount, 1);
//     });

//     test('updateVpsContribution updates value and notifies listeners', () {
//       int listenerCallCount = 0;
//       incomeProvider.addListener(() {
//         listenerCallCount++;
//       });

//       incomeProvider.updateVpsContribution(50000);

//       expect(incomeProvider.vpsContribution, 50000);
//       expect(listenerCallCount, 1);
//     });

//     // Note: Testing the getters that depend on TaxService is complex without DI.
//     // The core logic is tested in tax_service_test.dart, which is more reliable.
//     // Here, we can test the state changes that trigger those getters.
//     test('Changing income should trigger recalculation implicitly', () {
//       // We can't easily check the result without a mock, but we can verify
//       // that the provider notifies listeners, which should trigger a UI update.
//       int listenerCallCount = 0;
//       incomeProvider.addListener(() {
//         listenerCallCount++;
//       });

//       incomeProvider.updateYearlyIncome(2000000);

//       expect(listenerCallCount, 1);
//       // At this point, the UI would rebuild and display the new calculated values.
//     });
//   });
// }
