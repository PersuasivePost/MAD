import 'package:flutter/material.dart';
import 'package:exp6_1/home_page.dart';
import 'package:exp6_1/pages/privacy_policy_page.dart';
import 'package:exp6_1/pages/send_feedback_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Drawer',
      theme: ThemeData(primarySwatch: Colors.blue),

      // routes
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/privacy': (context) => const PrivacyPolicyPage(),
        '/feedback': (context) => const SendFeedbackPage(),
      },
    );
  }
}
