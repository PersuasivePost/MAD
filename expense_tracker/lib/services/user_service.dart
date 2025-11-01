import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserService extends ChangeNotifier {
  UserService._();
  static final UserService instance = UserService._();

  String _userName = '';
  String _userEmail = '';

  String get userName => _userName;
  String get userEmail => _userEmail;

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _userName = '';
      _userEmail = '';
      notifyListeners();
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        _userName = data?['name']?.toString() ?? '';
        _userEmail = data?['email']?.toString() ?? user.email ?? '';
      } else {
        _userName = '';
        _userEmail = user.email ?? '';
      }
      notifyListeners();
    } catch (e) {
      _userName = '';
      _userEmail = user.email ?? '';
      notifyListeners();
    }
  }

  void clear() {
    _userName = '';
    _userEmail = '';
    notifyListeners();
  }
}
