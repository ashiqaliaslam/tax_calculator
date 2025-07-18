// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:tax_calculator/services/tax_service.dart'; // Adjust import

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   late TaxService taxService;

//   // This setup function runs before each test
//   setUp(() async {
//     taxService = TaxService();
//     // Mock the asset bundle to load our test JSON
//     rootBundle.loadString = (String key) async {
//       // In a real test, you might load a specific test JSON file.
//       // For this example, we assume the main asset is used.
//       // This requires the test to have access to the assets folder.
//       return await ServicesBinding.instance.defaultBinaryMessenger
//               .handlePlatformMessage(
//                 'flutter/assets',
//                 ByteData.sublistView(Uint8List.fromList(key.codeUnits)),
//                 (ByteData? data) {},
//               )
//           as String;
//     };
//     await taxService.loadTaxData();
//   });

//   group('TaxService Calculations for 2025-2026', () {
//     const year = '2025-2026';

//     test('should calculate 0 tax for income under 600,000', () {
//       expect(taxService.calculateTax(year, 500000), 0);
//     });

//     test('should calculate correct tax for slab 2', () {
//       // 1% of amount exceeding 600,000
//       // (1,000,000 - 600,000) * 0.01 = 4,000
//       expect(taxService.calculateTax(year, 1000000), 4000);
//     });

//     test('should calculate correct tax for slab 3', () {
//       // 6,000 + 11% of amount exceeding 1,200,000
//       // 6,000 + (2,000,000 - 1,200,000) * 0.11 = 6,000 + 88,000 = 94,000
//       expect(taxService.calculateTax(year, 2000000), 94000);
//     });

//     test('should apply surcharge for income over 10 million', () {
//       // Tax on 11,000,000: 616,000 + (11,000,000 - 4,100,000) * 0.35 = 3,031,000
//       // Surcharge: 3,031,000 * 0.09 = 272,790
//       // Total: 3,031,000 + 272,790 = 3,303,790
//       expect(taxService.calculateTax(year, 11000000), 3303790);
//     });
//   });

//   group('VPS Rebate Calculation', () {
//     const year = '2025-2026';

//     test('should calculate correct VPS rebate', () {
//       // Gross Tax on 3,000,000: 116,000 + (3,000,000 - 2,200,000) * 0.23 = 290,000
//       // Average Tax Rate: 290,000 / 3,000,000 = 0.09666...
//       // Eligible Investment: 200,000 (lesser of 200k actual, 600k (20% of income))
//       // Rebate: 0.09666 * 200,000 = 19333.33
//       final result = taxService.calculateVpsRebate(
//         year: year,
//         yearlyIncome: 3000000,
//         vpsContribution: 200000,
//       );
//       expect(result, closeTo(19333.33, 0.01));
//     });
//   });
// }
