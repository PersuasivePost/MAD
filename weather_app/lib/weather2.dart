import 'package:flutter/material.dart';

class WeatherInfo {
  double currentC;
  String condition;
  List<double> forecastC;

  WeatherInfo({
    required this.currentC,
    required this.condition,
    required this.forecastC,
  });
}

class Weather2 extends StatefulWidget {
  const Weather2({super.key});

  @override
  State<Weather2> createState() => _Weather2State();
}

class _Weather2State extends State<Weather2> {
  late Map<String, WeatherInfo> _data;

  @override
  void initState() {
    super.initState(
      _data = {
        'New York': WeatherInfo(
          currentC = 20.0,
          condition: 'Cloudy',
          forecastC: [19, 20, 21, 22, 23],
        ),
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather App")),
      body: Center(child: Text("App content here!")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // logic here
        },
        child: const Text("Cel"),
      ),
    );
  }
}
