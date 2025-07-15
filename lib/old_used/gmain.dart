// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Tax Calculator',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //       ),
// //       home: const MyHomePage(title: 'Tax Calculator'),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key, required this.title});

// //   final String title;

// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     TextEditingController _monthlyIncomeController = TextEditingController();
// //     TextEditingController _yearlyIncomeController = TextEditingController();

// //     setState(() {
// //       _monthlyIncomeController = _yearlyIncomeController.text / 12;
// //     });
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// //         title: Text(widget.title),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 16),
// //               child: TextField(
// //                 decoration: InputDecoration(
// //                   border: OutlineInputBorder(),
// //                   labelText: 'Monthly Income',
// //                 ),
// //                 keyboardType: TextInputType.number,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:tax_calculator/custom_text_field.dart'; // Required for FilteringTextInputFormatter

// void main() {
//   // Runs the Flutter application.
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Defines the root of the application, using MaterialApp for basic app setup.
//     return MaterialApp(
//       title: 'Income Calculator', // Title for the app
//       theme: ThemeData(
//         primarySwatch: Colors.blue, // Defines the primary color for the app
//         fontFamily: 'Inter', // Setting a default font family
//       ),
//       home: const IncomeCalculatorPage(), // Sets the initial screen of the app
//     );
//   }
// }

// class IncomeCalculatorPage extends StatefulWidget {
//   const IncomeCalculatorPage({super.key});

//   @override
//   State<IncomeCalculatorPage> createState() => _IncomeCalculatorPageState();
// }

// class _IncomeCalculatorPageState extends State<IncomeCalculatorPage> {
//   // TextEditingController for the monthly income input field.
//   final TextEditingController _monthlyIncomeController =
//       TextEditingController();
//   // TextEditingController for the yearly income input field.
//   final TextEditingController _yearlyIncomeController = TextEditingController();

//   // State variables to store the actual double values of monthly and yearly income.
//   // These will be available for further calculations.
//   double? _currentMonthlyIncome;
//   double? _currentYearlyIncome;

//   // A flag to prevent infinite loops when updating text fields programmatically.
//   // When one field is updated by code, this flag is set to true,
//   // preventing the other field's listener from triggering another calculation.
//   bool _updatingFromCode = false;

//   @override
//   void initState() {
//     super.initState();
//     // Add listeners to both text controllers.
//     // These listeners will be called whenever the text in the respective controller changes.
//     _monthlyIncomeController.addListener(_onMonthlyIncomeChanged);
//     _yearlyIncomeController.addListener(_onYearlyIncomeChanged);
//   }

//   @override
//   void dispose() {
//     // Remove listeners to prevent memory leaks.
//     _monthlyIncomeController.removeListener(_onMonthlyIncomeChanged);
//     _yearlyIncomeController.removeListener(_onYearlyIncomeChanged);
//     // Dispose of the controllers to free up resources.
//     _monthlyIncomeController.dispose();
//     _yearlyIncomeController.dispose();
//     super.dispose();
//   }

//   // This method is called when the monthly income text field changes.
//   void _onMonthlyIncomeChanged() {
//     // If the change was initiated by code (i.e., from the yearly income update),
//     // we return immediately to prevent an infinite loop.
//     if (_updatingFromCode) {
//       return;
//     }

//     // Set the flag to true to indicate that an update is about to happen programmatically.
//     _updatingFromCode = true;

//     final String text = _monthlyIncomeController.text;
//     // Attempt to parse the input text to a double.
//     final double? monthlyIncome = double.tryParse(text);

//     // Update state variables and the other text field.
//     setState(() {
//       _currentMonthlyIncome = monthlyIncome;
//       if (monthlyIncome != null && monthlyIncome >= 0) {
//         _currentYearlyIncome = monthlyIncome * 12;
//         // Only update the yearly controller if the new value is different to avoid
//         // unnecessary rebuilds and potential cursor jumps.
//         if (_yearlyIncomeController.text !=
//             _currentYearlyIncome!.toStringAsFixed(2)) {
//           _yearlyIncomeController.text = _currentYearlyIncome!.toStringAsFixed(
//             2,
//           );
//         }
//       } else {
//         _currentYearlyIncome =
//             null; // Clear yearly income if monthly is invalid/empty
//         _yearlyIncomeController.text = '';
//       }
//     });

//     // Reset the flag to false, indicating that programmatic update is complete.
//     _updatingFromCode = false;
//   }

//   // This method is called when the yearly income text field changes.
//   void _onYearlyIncomeChanged() {
//     // Prevent infinite loop if update is programmatic.
//     if (_updatingFromCode) {
//       return;
//     }

//     // Set the flag to true.
//     _updatingFromCode = true;

//     final String text = _yearlyIncomeController.text;
//     final double? yearlyIncome = double.tryParse(text);

//     // Update state variables and the other text field.
//     setState(() {
//       _currentYearlyIncome = yearlyIncome;
//       if (yearlyIncome != null && yearlyIncome >= 0) {
//         _currentMonthlyIncome = yearlyIncome / 12;
//         // Only update the monthly controller if the new value is different.
//         if (_monthlyIncomeController.text !=
//             _currentMonthlyIncome!.toStringAsFixed(2)) {
//           _monthlyIncomeController.text = _currentMonthlyIncome!
//               .toStringAsFixed(2);
//         }
//       } else {
//         _currentMonthlyIncome =
//             null; // Clear monthly income if yearly is invalid/empty
//         _monthlyIncomeController.text = '';
//       }
//     });

//     // Reset the flag to false.
//     _updatingFromCode = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Income Calculator',
//           style: TextStyle(color: Colors.white), // Text color for app bar title
//         ),
//         backgroundColor: Colors.blueAccent, // Background color for app bar
//         elevation: 4, // Shadow below the app bar
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(15), // Rounded bottom corners for app bar
//           ),
//         ),
//       ),
//       body: Container(
//         // Add a subtle gradient background to the body
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.white, Colors.blue],
//           ),
//         ),
//         padding: const EdgeInsets.all(20.0), // Padding around the content
//         child: Column(
//           crossAxisAlignment:
//               CrossAxisAlignment.stretch, // Stretch children horizontally
//           children: <Widget>[
//             // Monthly Income Text Field
//             CustomTextField(
//               monthlyIncomeController: _monthlyIncomeController,
//               hintText: 'Enter Monthly Income',
//               labelText: 'Monthly Income',
//               icon: Icons.attach_money,
//             ),
//             const SizedBox(height: 25), // Spacer between the two input fields
//             CustomTextField(
//               monthlyIncomeController: _yearlyIncomeController,
//               hintText: 'Enter Yearly Income',
//               labelText: 'Yearly Income',
//               icon: Icons.money,
//             ),
//             // Yearly Income Text Field
//             TextField(
//               controller: _yearlyIncomeController,
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//               decoration: InputDecoration(
//                 labelText: 'Yearly Income',
//                 hintText: 'Automatically calculated or enter yearly income',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.9),
//                 prefixIcon: const Icon(
//                   Icons.trending_up,
//                   color: Colors.orange,
//                 ), // Icon for yearly trend
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 15,
//                   horizontal: 20,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(
//                     color: Colors.blueAccent,
//                     width: 2,
//                   ),
//                 ),
//                 floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
//               ),
//               style: const TextStyle(fontSize: 18, color: Colors.black87),
//               inputFormatters: <TextInputFormatter>[
//                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//               ],
//             ),
//             const SizedBox(height: 30), // Spacer before the instructional text
//             // Display the stored values for demonstration
//             Text(
//               _currentMonthlyIncome != null
//                   ? 'Stored Monthly: \$${_currentMonthlyIncome!.toStringAsFixed(2)}'
//                   : 'Stored Monthly: N/A',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.indigo,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               _currentYearlyIncome != null
//                   ? 'Stored Yearly: \$${_currentYearlyIncome!.toStringAsFixed(2)}'
//                   : 'Stored Yearly: N/A',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.indigo,
//               ),
//             ),
//             const SizedBox(height: 30), // Spacer before the instructional text
//             // Instructional text for the user.
//             const Text(
//               'Enter income in either field, and the other will update automatically. '
//               'Values are rounded to two decimal places.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 color: Colors.blueGrey,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart'; // Required for FilteringTextInputFormatter

// // void main() {
// //   // Runs the Flutter application.
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     // Defines the root of the application, using MaterialApp for basic app setup.
// //     return MaterialApp(
// //       title: 'Income Calculator', // Title for the app
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue, // Defines the primary color for the app
// //         fontFamily: 'Inter', // Setting a default font family
// //       ),
// //       home: const IncomeCalculatorPage(), // Sets the initial screen of the app
// //     );
// //   }
// // }

// // class IncomeCalculatorPage extends StatefulWidget {
// //   const IncomeCalculatorPage({super.key});

// //   @override
// //   State<IncomeCalculatorPage> createState() => _IncomeCalculatorPageState();
// // }

// // class _IncomeCalculatorPageState extends State<IncomeCalculatorPage> {
// //   // TextEditingController for the monthly income input field.
// //   final TextEditingController _monthlyIncomeController =
// //       TextEditingController();
// //   // TextEditingController for the yearly income input field.
// //   final TextEditingController _yearlyIncomeController = TextEditingController();

// //   // A flag to prevent infinite loops when updating text fields programmatically.
// //   // When one field is updated by code, this flag is set to true,
// //   // preventing the other field's listener from triggering another calculation.
// //   bool _updatingFromCode = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Add listeners to both text controllers.
// //     // These listeners will be called whenever the text in the respective controller changes.
// //     _monthlyIncomeController.addListener(_onMonthlyIncomeChanged);
// //     _yearlyIncomeController.addListener(_onYearlyIncomeChanged);
// //   }

// //   @override
// //   void dispose() {
// //     // Remove listeners to prevent memory leaks.
// //     _monthlyIncomeController.removeListener(_onMonthlyIncomeChanged);
// //     _yearlyIncomeController.removeListener(_onYearlyIncomeChanged);
// //     // Dispose of the controllers to free up resources.
// //     _monthlyIncomeController.dispose();
// //     _yearlyIncomeController.dispose();
// //     super.dispose();
// //   }

// //   // This method is called when the monthly income text field changes.
// //   void _onMonthlyIncomeChanged() {
// //     // If the change was initiated by code (i.e., from the yearly income update),
// //     // we return immediately to prevent an infinite loop.
// //     if (_updatingFromCode) {
// //       return;
// //     }

// //     // Set the flag to true to indicate that an update is about to happen programmatically.
// //     _updatingFromCode = true;

// //     final String text = _monthlyIncomeController.text;
// //     // Attempt to parse the input text to a double.
// //     // double.tryParse returns null if the string is not a valid double.
// //     final double? monthlyIncome = double.tryParse(text);

// //     // Check if the parsed monthly income is a valid non-negative number.
// //     if (monthlyIncome != null && monthlyIncome >= 0) {
// //       final double yearlyIncome = monthlyIncome * 12;
// //       // Update the yearly income controller's text.
// //       // We use toStringAsFixed(2) to format the double to two decimal places.
// //       // Only update if the new value is different from the current to avoid
// //       // unnecessary rebuilds and potential cursor jumps.
// //       if (_yearlyIncomeController.text != yearlyIncome.toStringAsFixed(2)) {
// //         _yearlyIncomeController.text = yearlyIncome.toStringAsFixed(2);
// //       }
// //     } else if (text.isEmpty) {
// //       // If the monthly income field is empty, clear the yearly income field.
// //       _yearlyIncomeController.text = '';
// //     }
// //     // If input is invalid (e.g., non-numeric characters), the yearly field will not update.
// //     // You could add error handling here, e.g., showing a validation message.

// //     // Reset the flag to false, indicating that programmatic update is complete.
// //     _updatingFromCode = false;
// //   }

// //   // This method is called when the yearly income text field changes.
// //   void _onYearlyIncomeChanged() {
// //     // Prevent infinite loop if update is programmatic.
// //     if (_updatingFromCode) {
// //       return;
// //     }

// //     // Set the flag to true.
// //     _updatingFromCode = true;

// //     final String text = _yearlyIncomeController.text;
// //     final double? yearlyIncome = double.tryParse(text);

// //     // Check if the parsed yearly income is a valid non-negative number.
// //     if (yearlyIncome != null && yearlyIncome >= 0) {
// //       final double monthlyIncome = yearlyIncome / 12;
// //       // Update the monthly income controller's text.
// //       // Only update if the new value is different.
// //       if (_monthlyIncomeController.text != monthlyIncome.toStringAsFixed(2)) {
// //         _monthlyIncomeController.text = monthlyIncome.toStringAsFixed(2);
// //       }
// //     } else if (text.isEmpty) {
// //       // If the yearly income field is empty, clear the monthly income field.
// //       _monthlyIncomeController.text = '';
// //     }

// //     // Reset the flag to false.
// //     _updatingFromCode = false;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Income Calculator',
// //           style: TextStyle(color: Colors.white), // Text color for app bar title
// //         ),
// //         backgroundColor: Colors.blueAccent, // Background color for app bar
// //         elevation: 4, // Shadow below the app bar
// //         shape: const RoundedRectangleBorder(
// //           borderRadius: BorderRadius.vertical(
// //             bottom: Radius.circular(15), // Rounded bottom corners for app bar
// //           ),
// //         ),
// //       ),
// //       body: Container(
// //         // Add a subtle gradient background to the body
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             colors: [Colors.white, Colors.blue],
// //           ),
// //         ),
// //         padding: const EdgeInsets.all(20.0), // Padding around the content
// //         child: Column(
// //           crossAxisAlignment:
// //               CrossAxisAlignment.stretch, // Stretch children horizontally
// //           children: <Widget>[
// //             // Monthly Income Text Field
// //             TextField(
// //               controller: _monthlyIncomeController,
// //               // Configure keyboard to show numbers and allow decimals.
// //               keyboardType: const TextInputType.numberWithOptions(
// //                 decimal: true,
// //               ),
// //               decoration: InputDecoration(
// //                 labelText: 'Monthly Income',
// //                 hintText: 'Enter monthly income',
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(
// //                     12,
// //                   ), // Rounded corners for input field
// //                   borderSide: BorderSide.none, // No explicit border line
// //                 ),
// //                 filled: true, // Fill the background
// //                 fillColor: Colors.white.withOpacity(
// //                   0.9,
// //                 ), // Light background color
// //                 prefixIcon: const Icon(
// //                   Icons.attach_money,
// //                   color: Colors.green,
// //                 ), // Icon for currency
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 15,
// //                   horizontal: 20,
// //                 ),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                   borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                   borderSide: const BorderSide(
// //                     color: Colors.blueAccent,
// //                     width: 2,
// //                   ),
// //                 ),
// //                 floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
// //               ),
// //               style: const TextStyle(fontSize: 18, color: Colors.black87),
// //               // Input formatters to allow only numbers and up to two decimal places.
// //               inputFormatters: <TextInputFormatter>[
// //                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //               ],
// //             ),
// //             const SizedBox(height: 25), // Spacer between the two input fields
// //             // Yearly Income Text Field
// //             TextField(
// //               controller: _yearlyIncomeController,
// //               keyboardType: const TextInputType.numberWithOptions(
// //                 decimal: true,
// //               ),
// //               decoration: InputDecoration(
// //                 labelText: 'Yearly Income',
// //                 hintText: 'Automatically calculated or enter yearly income',
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                   borderSide: BorderSide.none,
// //                 ),
// //                 filled: true,
// //                 fillColor: Colors.white.withOpacity(0.9),
// //                 prefixIcon: const Icon(
// //                   Icons.trending_up,
// //                   color: Colors.orange,
// //                 ), // Icon for yearly trend
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 15,
// //                   horizontal: 20,
// //                 ),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                   borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                   borderSide: const BorderSide(
// //                     color: Colors.blueAccent,
// //                     width: 2,
// //                   ),
// //                 ),
// //                 floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
// //               ),
// //               style: const TextStyle(fontSize: 18, color: Colors.black87),
// //               inputFormatters: <TextInputFormatter>[
// //                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //               ],
// //             ),
// //             const SizedBox(height: 30), // Spacer before the instructional text
// //             // Instructional text for the user.
// //             const Text(
// //               'Enter income in either field, and the other will update automatically. '
// //               'Values are rounded to two decimal places.',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontStyle: FontStyle.italic,
// //                 color: Colors.blueGrey,
// //                 fontSize: 14,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
