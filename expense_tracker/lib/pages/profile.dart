import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/services/finance_model.dart';
import 'package:expense_tracker/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    UserService.instance.addListener(_onUserChange);
  }

  void _onUserChange() => setState(() {});

  @override
  void dispose() {
    UserService.instance.removeListener(_onUserChange);
    super.dispose();
  }

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
            Text(
              UserService.instance.userName.isNotEmpty
                  ? UserService.instance.userName
                  : 'Guest',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                // detach Firestore listeners and clear user data
                try {
                  FinanceModel.instance.detach();
                  UserService.instance.clear();
                } catch (_) {}
                if (!mounted) return;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (_) => false);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff904c6e),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () async {
                // confirm before deleting
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete account'),
                    content: const Text(
                        'This will permanently delete your account and all your data (expenses & incomes). This action cannot be undone. Do you want to continue?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm != true) return;

                // show progress using root navigator to ensure we can dismiss it reliably
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  useRootNavigator: true,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                var success = false;
                try {
                  success = await _performAccountDeletion();
                } finally {
                  // always attempt to remove progress dialog first (root navigator)
                  if (mounted) Navigator.of(context, rootNavigator: true).pop();
                }

                if (!mounted) return;
                if (success) {
                  // navigate to login and clear history in next frame to avoid navigator races
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (_) => false);
                  });
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _performAccountDeletion() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')));
      return false;
    }

    final uid = user.uid;

    try {
      // delete subcollections (expenses & incomes)
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      // helper to delete all docs in a collection
      Future<void> _deleteCollection(String name) async {
        final col = userRef.collection(name);
        final snap = await col.get();
        for (final doc in snap.docs) {
          await doc.reference.delete();
        }
      }

      await _deleteCollection('expenses');
      await _deleteCollection('incomes');

      // delete user document if exists
      final doc = await userRef.get();
      if (doc.exists) await userRef.delete();

      // finally delete auth user
      await user.delete();

      // cleanup local state and sign out
      try {
        FinanceModel.instance.detach();
        UserService.instance.clear();
      } catch (_) {}

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('loggedIn');

      return true;
    } on FirebaseAuthException catch (e) {
      // Deleting a user may require recent authentication.
      if (!mounted) return false;
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Please re-login and try account deletion again (recent authentication required).')));
        return false;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
        return false;
      }
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: $e')));
      return false;
    }
  }
}
