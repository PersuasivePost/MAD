import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8edc2),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 120.0),
            // use the asset key declared in pubspec.yaml
            Image.asset(
              'images/onboard.png',
              // width: MediaQuery.of(context).size.width * 0.7,
              // fit: BoxFit.contain,
            ),
            SizedBox(height: 50.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60.0),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    Text(
                      "Manage your daily\nlife expenses",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                      // style: AppWidget.headlineTextStyle(30.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        bottom: 12.0,
                      ),
                      child: Text(
                        "Expense Tracker helps you keep track of your daily expenses and manage your budget effectively.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: 60.0),
                    Container(
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(60.0),
                        child: Container(
                          child: Center(
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffee6856),
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
