import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/pages/login.dart';
import 'package:expense_tracker/pages/signup.dart';
import 'package:flutter/material.dart';
import 'pages/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Login(),
    );
  }
}
