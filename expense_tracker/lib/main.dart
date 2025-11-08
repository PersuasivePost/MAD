import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/pages/login.dart';
import 'package:expense_tracker/pages/signup.dart';
import 'package:expense_tracker/pages/expense.dart';
import 'package:expense_tracker/pages/income.dart';
import 'package:expense_tracker/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/services/finance_model.dart';
import 'package:expense_tracker/services/user_service.dart';

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
      home: const RootPage(),
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

/// RootPage decides initial screen based on persisted login state and FirebaseAuth.
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _loading = true;
  Widget _child =
      const Scaffold(body: Center(child: CircularProgressIndicator()));

  @override
  void initState() {
    super.initState();
    _determineStartPage();
  }

  Future<void> _determineStartPage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefLogged = prefs.getBool('loggedIn') ?? false;
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && prefLogged) {
        // restore app state for the signed-in user
        try {
          FinanceModel.instance.attachForUser(user.uid);
          await UserService.instance.loadUserData();
        } catch (_) {}
        setState(() {
          _child = const Home();
          _loading = false;
        });
        return;
      }

      // not signed in - ensure prefs are clean
      if (prefLogged) await prefs.remove('loggedIn');
      setState(() {
        _child = const Login();
        _loading = false;
      });
    } catch (e) {
      // on error, fall back to login
      setState(() {
        _child = const Login();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    return _child;
  }
}
