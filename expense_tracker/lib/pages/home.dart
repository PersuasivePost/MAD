import 'dart:math' as math;

import 'package:expense_tracker/services/support_widgets.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _showThisYear = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Ashvatth Joshi',
                        style: AppWidget.headlineTextStyle(20.0),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.asset(
                      'images/boy1.jpg',
                      height: 52.0,
                      width: 52.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28.0),
              Text(
                'Manage your\nexpenses',
                style: AppWidget.headlineTextStyle(30.0),
              ),

              const SizedBox(height: 18.0),

              // Expenses card with donut and legend
              Container(
                width: width,
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.black12, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Expenses',
                          style: AppWidget.headlineTextStyle(20.0),
                        ),
                        Text(
                          '\$300',
                          style: const TextStyle(
                            color: Color(0xffee6856),
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    const Text(
                      '1 Sept 2025 - 30 Sept 2025',
                      style: TextStyle(
                        color: Color.fromARGB(148, 0, 0, 0),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 14.0),

                    Row(
                      children: [
                        // donut chart
                        SizedBox(
                          width: 140,
                          height: 120,
                          child: Center(child: DonutChart(size: 110)),
                        ),
                        const SizedBox(width: 12.0),
                        // legend
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              LegendItem(
                                color: Color(0xffee6856),
                                label: 'Shopping',
                                amount: '\$500',
                              ),
                              SizedBox(height: 8.0),
                              LegendItem(
                                color: Color(0xff69c56b),
                                label: 'Grocery',
                                amount: '\$300',
                              ),
                              SizedBox(height: 8.0),
                              LegendItem(
                                color: Color(0xff2aa6b8),
                                label: 'Others',
                                amount: '\$200',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18.0),

              // Toggle buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showThisYear = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color: !_showThisYear
                              ? const Color(0xffee6856)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: !_showThisYear
                                ? const Color(0xffee6856)
                                : Colors.black26,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'This Month',
                            style: TextStyle(
                              color: !_showThisYear
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showThisYear = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color: _showThisYear
                              ? const Color(0xffee6856)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: _showThisYear
                                ? const Color(0xffee6856)
                                : Colors.black26,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'This Year',
                            style: TextStyle(
                              color: _showThisYear
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18.0),

              // Income / Expenses cards
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      title: 'Income',
                      value: '+\$5000',
                      accentColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: InfoCard(
                      title: 'Expenses',
                      value: '+\$5000',
                      accentColor: const Color(0xffee6856),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18.0),

              // Bottom banner
              Container(
                width: width,
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xfff39b91),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    const Expanded(
                      child: Text(
                        'Your expense plan looks good',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        Text(amount, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accentColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 8.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: 0.6,
              color: accentColor,
              backgroundColor: accentColor.withOpacity(0.18),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class DonutChart extends StatelessWidget {
  final double size;

  const DonutChart({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _DonutPainter());
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final stroke = radius * 0.38;

    final rect = Rect.fromCircle(center: center, radius: radius - stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    // segments (values: 50%, 30%, 20%) -> angles
    final full = 2 * math.pi;
    final angles = [0.5 * full, 0.3 * full, 0.2 * full];
    final colors = [
      const Color(0xffee6856),
      const Color(0xff69c56b),
      const Color(0xff2aa6b8),
    ];

    double start = -math.pi / 2;
    for (int i = 0; i < angles.length; i++) {
      paint.color = colors[i];
      canvas.drawArc(rect, start, angles[i], false, paint);
      start += angles[i];
    }

    // inner circle to create donut hole
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius - stroke - 4, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
