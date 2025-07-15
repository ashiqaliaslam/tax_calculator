// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart'; // Required for FilteringTextInputFormatter
// // import 'package:provider/provider.dart'; // Import the provider package
// // import 'income_model.dart'; // Import your custom IncomeModel

// // void main() {
// //   // Wrap the entire application with ChangeNotifierProvider.
// //   // This makes the IncomeModel instance available to all widgets below it in the tree.
// //   runApp(
// //     ChangeNotifierProvider(
// //       create: (context) =>
// //           IncomeModel(), // Create an instance of your IncomeModel
// //       child: const MyApp(),
// //     ),
// //   );
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Income Calculator',
// //       theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
// //       home: const IncomeCalculatorPage(),
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

// //   // This flag is now used to prevent the TextEditingController's listener
// //   // from triggering a model update when the controller's text is set programmatically
// //   // by the model itself.
// //   bool _settingControllerText = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Get the IncomeModel instance without listening for changes (listen: false)
// //     // because we only need to add a listener here, not rebuild the widget.
// //     final incomeModel = Provider.of<IncomeModel>(context, listen: false);

// //     // Add a listener to the IncomeModel. When the model notifies changes,
// //     // we update the TextEditingControllers.
// //     incomeModel.addListener(() {
// //       // Set the flag to true before updating the controller text
// //       _settingControllerText = true;

// //       // Update monthly income controller if the model's value is different
// //       final String newMonthlyText = incomeModel.monthlyIncome != null
// //           ? incomeModel.monthlyIncome!.toStringAsFixed(2)
// //           : '';
// //       if (_monthlyIncomeController.text != newMonthlyText) {
// //         _monthlyIncomeController.text = newMonthlyText;
// //       }

// //       // Update yearly income controller if the model's value is different
// //       final String newYearlyText = incomeModel.yearlyIncome != null
// //           ? incomeModel.yearlyIncome!.toStringAsFixed(2)
// //           : '';
// //       if (_yearlyIncomeController.text != newYearlyText) {
// //         _yearlyIncomeController.text = newYearlyText;
// //       }

// //       // Reset the flag after updating the controller text
// //       _settingControllerText = false;
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     // It's good practice to remove listeners, though Provider handles some disposal.
// //     // However, the listener added in initState to the model needs to be removed
// //     // if the widget is disposed before the model.
// //     // For simplicity with Provider, we often rely on the Provider's lifecycle,
// //     // but explicit removal is safer if the model outlives the widget.
// //     // In this specific setup, the model lives above MyApp, so it outlives this widget.
// //     // If the model was created within this widget's scope, you'd need to remove the listener.
// //     _monthlyIncomeController.dispose();
// //     _yearlyIncomeController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Use Consumer to rebuild only the parts of the widget tree that depend on the model.
// //     // In this case, we're consuming the entire model to get the latest values for display.
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Income Calculator',
// //           style: TextStyle(color: Colors.white),
// //         ),
// //         backgroundColor: Colors.blueAccent,
// //         elevation: 4,
// //         shape: const RoundedRectangleBorder(
// //           borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
// //         ),
// //       ),
// //       body: Container(
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             colors: [Colors.white, Colors.blue],
// //           ),
// //         ),
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: <Widget>[
// //             TextField(
// //               controller: _monthlyIncomeController,
// //               keyboardType: const TextInputType.numberWithOptions(
// //                 decimal: true,
// //               ),
// //               decoration: InputDecoration(
// //                 labelText: 'Monthly Income',
// //                 hintText: 'Enter monthly income',
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                   borderSide: BorderSide.none,
// //                 ),
// //                 filled: true,
// //                 fillColor: Colors.white.withOpacity(0.9),
// //                 prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
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
// //               onChanged: (value) {
// //                 // When the user types, call the model's update method.
// //                 // We check _settingControllerText to prevent calling the model
// //                 // when the controller's text is being set programmatically by the model itself.
// //                 if (!_settingControllerText) {
// //                   Provider.of<IncomeModel>(
// //                     context,
// //                     listen: false,
// //                   ).updateMonthlyIncome(value);
// //                 }
// //               },
// //             ),
// //             const SizedBox(height: 25),

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
// //                 prefixIcon: const Icon(Icons.trending_up, color: Colors.orange),
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
// //               onChanged: (value) {
// //                 // When the user types, call the model's update method.
// //                 if (!_settingControllerText) {
// //                   Provider.of<IncomeModel>(
// //                     context,
// //                     listen: false,
// //                   ).updateYearlyIncome(value);
// //                 }
// //               },
// //             ),
// //             const SizedBox(height: 30),

// //             // Use Consumer to listen to changes in the IncomeModel and rebuild
// //             // only the Text widgets that display the stored values.
// //             Consumer<IncomeModel>(
// //               builder: (context, incomeModel, child) {
// //                 return Column(
// //                   children: [
// //                     Text(
// //                       incomeModel.monthlyIncome != null
// //                           ? 'Stored Monthly: \$${incomeModel.monthlyIncome!.toStringAsFixed(2)}'
// //                           : 'Stored Monthly: N/A',
// //                       textAlign: TextAlign.center,
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.indigo,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 5),
// //                     Text(
// //                       incomeModel.yearlyIncome != null
// //                           ? 'Stored Yearly: \$${incomeModel.yearlyIncome!.toStringAsFixed(2)}'
// //                           : 'Stored Yearly: N/A',
// //                       textAlign: TextAlign.center,
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.indigo,
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //             const SizedBox(height: 30),

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

// import 'package:flutter/material.dart';
// import 'package:tax_calculator/custom_text_field.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: IncomeConverter());
//   }
// }

// class IncomeConverter extends StatefulWidget {
//   const IncomeConverter({super.key});

//   @override
//   State<IncomeConverter> createState() => _IncomeConverterState();
// }

// class _IncomeConverterState extends State<IncomeConverter> {
//   final TextEditingController monthlyController = TextEditingController();
//   final TextEditingController yearlyController = TextEditingController();

//   String? currentlyEditing;

//   void updateMonthly(String value) {
//     if (currentlyEditing == 'yearly') return;
//     currentlyEditing = 'monthly';

//     final double? monthly = double.tryParse(value);
//     if (monthly != null) {
//       final yearly = monthly * 12;
//       yearlyController.text = yearly.toStringAsFixed(2);
//     } else {
//       yearlyController.text = '';
//     }

//     currentlyEditing = null;
//   }

//   void updateYearly(String value) {
//     if (currentlyEditing == 'monthly') return;
//     currentlyEditing = 'yearly';

//     final double? yearly = double.tryParse(value);
//     if (yearly != null) {
//       final monthly = yearly / 12;
//       monthlyController.text = monthly.toStringAsFixed(2);
//     } else {
//       monthlyController.text = '';
//     }

//     currentlyEditing = null;
//   }

//   @override
//   void dispose() {
//     monthlyController.dispose();
//     yearlyController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Income Converter")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(border: Border.all()),
//               padding: EdgeInsets.all(8),
//               child: Column(
//                 children: [
//                   CustomTextField(
//                     monthlyIncomeController: monthlyController,
//                     labelText: 'Monthly Income',
//                     hintText: 'Please Enter Monthly Income',
//                     icon: Icons.attach_money,
//                   ),
//                   SizedBox(height: 20),
//                   CustomTextField(
//                     monthlyIncomeController: yearlyController,
//                     labelText: 'Yearly Income',
//                     hintText: 'Please Enter Yearly Income',
//                     icon: Icons.money_off,
//                   ),
//                 ],
//               ),
//             ),
//             TextField(
//               controller: monthlyController,
//               // keyboardType: const TextInputType.numberWithOptions(
//               //   decimal: true,
//               // ),
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Monthly Income"),
//               onChanged: updateMonthly,
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: yearlyController,
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//               decoration: const InputDecoration(labelText: "Yearly Income"),
//               onChanged: updateYearly,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
