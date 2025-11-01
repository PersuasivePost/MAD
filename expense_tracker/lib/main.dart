import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/pages/login.dart';
import 'package:expense_tracker/pages/signup.dart';
import 'package:expense_tracker/pages/expense.dart';
import 'package:expense_tracker/pages/income.dart';
import 'package:expense_tracker/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: const Login(),
      routes: {
        Login.routeName: (c) => const Login(),
        Signup.routeName: (c) => const Signup(),
        '/home': (c) => const Home(),
        '/expense': (c) => const ExpensePage(),
        '/income': (c) => const IncomePage(),
        '/profile': (c) => const ProfilePage(),
      },
    );
  }
}
