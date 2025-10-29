import 'package:exp6_1/pages/details_page.dart';
import 'package:flutter/material.dart';
// import 'details_page.dart' file

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Dashboard Page', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Dashboard Page', style: TextStyle(fontSize: 24)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetailsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
