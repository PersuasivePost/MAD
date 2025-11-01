import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/services/finance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('images/boy1.jpg'),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Ashvatth Joshi',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/like.png', height: 28),
                const SizedBox(width: 8.0),
                const Text(
                  'Your plan looks good',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Expenses'),
              onTap: () => Navigator.of(context).pushNamed('/expense'),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Income'),
              onTap: () => Navigator.of(context).pushNamed('/income'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('loggedIn');
                // detach Firestore listeners
                try {
                  FinanceModel.instance.detach();
                } catch (_) {}
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff904c6e),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
