import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Settings Page', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('View privacy policy (Named Route)'),
            onPressed: () {
              // Add your settings action here
              Navigator.pushNamed(context, '/privacy');
            },
          ),
        ],
      ),
    );
  }
}
