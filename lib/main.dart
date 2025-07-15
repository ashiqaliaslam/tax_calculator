import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'income_provider.dart';
import 'income_calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the IncomeProvider to the entire widget tree.
    return ChangeNotifierProvider(
      create: (context) => IncomeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tax Calculator',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            prefixIconColor: Colors.teal,
          ),
        ),
        home: const IncomeCalculatorScreen(),
      ),
    );
  }
}
