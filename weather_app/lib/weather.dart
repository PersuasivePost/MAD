import 'dart:math';

import 'package:flutter/material.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class WeatherInfo {
  double currentC;
  String condition;
  List<double> forecastC; // 5-day temps in Celsius

  WeatherInfo({
    required this.currentC,
    required this.condition,
    required this.forecastC,
  });
}

class _WeatherAppState extends State<WeatherApp> {
  final List<String> _cities = [
    'New York',
    'London',
    'Tokyo',
    'Mumbai',
    'Sydney',
  ];

  late Map<String, WeatherInfo> _data;
  String _selectedCity = 'New York';
  bool isCelsius = true;

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _data = {
      'New York': WeatherInfo(
        currentC: 20.0,
        condition: 'Cloudy',
        forecastC: [19, 21, 22, 18, 20],
      ),
      'London': WeatherInfo(
        currentC: 15.0,
        condition: 'Rainy',
        forecastC: [14, 13, 16, 15, 14],
      ),
      'Tokyo': WeatherInfo(
        currentC: 25.0,
        condition: 'Sunny',
        forecastC: [26, 27, 25, 24, 26],
      ),
      'Mumbai': WeatherInfo(
        currentC: 30.0,
        condition: 'Sunny',
        forecastC: [31, 30, 29, 32, 31],
      ),
      'Sydney': WeatherInfo(
        currentC: 18.0,
        condition: 'Windy',
        forecastC: [17, 18, 19, 16, 18],
      ),
    };
  }

  IconData _iconForCondition(String cond) {
    final lc = cond.toLowerCase();
    if (lc.contains('sun')) return Icons.wb_sunny;
    if (lc.contains('cloud')) return Icons.cloud;
    if (lc.contains('rain')) return Icons.beach_access;
    if (lc.contains('wind')) return Icons.air;
    return Icons.help_outline;
  }

  double _toF(double c) => (c * 9 / 5) + 32;

  String _formatTemp(double c) {
    if (isCelsius) return '${c.toStringAsFixed(1)} °C';
    return '${_toF(c).toStringAsFixed(1)} °F';
  }

  void _refreshData() {
    // Simulate a refresh by slightly changing temps for the selected city
    setState(() {
      final info = _data[_selectedCity]!;
      info.currentC += (_rnd.nextDouble() * 2 - 1); // +/-1°C
      for (var i = 0; i < info.forecastC.length; i++) {
        info.forecastC[i] += (_rnd.nextDouble() * 2 - 1);
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Weather data refreshed')));
  }

  @override
  Widget build(BuildContext context) {
    final info = _data[_selectedCity]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('weather app'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City selection
            Row(
              children: [
                const Text('Select city: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedCity,
                  items: _cities
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _selectedCity = v;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Current weather card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(_iconForCondition(info.condition), size: 48),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedCity,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTemp(info.currentC),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          info.condition,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              '5-day forecast',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Forecast horizontal list
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  final day = _days[index % _days.length];
                  final tempC = info.forecastC[index];
                  final cond = info.condition; // simple: use same condition
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 8),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Icon(_iconForCondition(cond)),
                            const SizedBox(height: 6),
                            Text(_formatTemp(tempC)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => isCelsius = !isCelsius),
        tooltip: 'Toggle units',
        child: Text(isCelsius ? '°C' : '°F'),
      ),
    );
  }
}
