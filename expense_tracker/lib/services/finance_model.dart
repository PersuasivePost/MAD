import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FinanceItem {
  final String title;
  final double amount;
  final String category; // for expenses
  final DateTime date;

  FinanceItem(
      {required this.title,
      required this.amount,
      this.category = '',
      DateTime? date})
      : date = date ?? DateTime.now();
}

class FinanceModel extends ChangeNotifier {
  FinanceModel._();
  static final FinanceModel instance = FinanceModel._();

  final List<FinanceItem> _expenses = [];
  final List<FinanceItem> _incomes = [];
  String? _userId;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _expensesSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _incomesSub;

  List<FinanceItem> get expenses => List.unmodifiable(_expenses);
  List<FinanceItem> get incomes => List.unmodifiable(_incomes);

  void addExpense(String title, double amount, String category) {
    // If attached to a user, write to Firestore; snapshot listener will update local state.
    if (_userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('expenses')
          .add({
        'title': title,
        'amount': amount,
        'category': category,
        'date': DateTime.now().toIso8601String(),
      });
      return;
    }

    _expenses
        .add(FinanceItem(title: title, amount: amount, category: category));
    notifyListeners();
  }

  void addIncome(String title, double amount) {
    if (_userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('incomes')
          .add({
        'title': title,
        'amount': amount,
        'date': DateTime.now().toIso8601String(),
      });
      return;
    }

    _incomes.add(FinanceItem(title: title, amount: amount));
    notifyListeners();
  }

  double get totalExpenses => _expenses.fold(0.0, (s, e) => s + e.amount);
  double get totalIncome => _incomes.fold(0.0, (s, e) => s + e.amount);

  // Filter methods for time periods
  double totalExpensesForPeriod(bool isYear) {
    final now = DateTime.now();
    final start =
        isYear ? DateTime(now.year, 1, 1) : DateTime(now.year, now.month, 1);
    return _expenses
        .where((e) => e.date.isAfter(start))
        .fold(0.0, (s, e) => s + e.amount);
  }

  double totalIncomeForPeriod(bool isYear) {
    final now = DateTime.now();
    final start =
        isYear ? DateTime(now.year, 1, 1) : DateTime(now.year, now.month, 1);
    return _incomes
        .where((e) => e.date.isAfter(start))
        .fold(0.0, (s, e) => s + e.amount);
  }

  Map<String, double> categoryTotals(List<String> categories,
      {bool isYear = false}) {
    final now = DateTime.now();
    final start =
        isYear ? DateTime(now.year, 1, 1) : DateTime(now.year, now.month, 1);

    final map = <String, double>{};
    for (final c in categories) {
      map[c] = 0.0;
    }

    final filteredExpenses = _expenses.where((e) => e.date.isAfter(start));

    for (final e in filteredExpenses) {
      if (map.containsKey(e.category)) {
        map[e.category] = map[e.category]! + e.amount;
      } else {
        map['Others'] = (map['Others'] ?? 0.0) + e.amount;
      }
    }
    return map;
  }

  /// Attach model to a Firestore-backed user. This sets up listeners for
  /// expenses and incomes and keeps local lists synchronized.
  void attachForUser(String uid) {
    if (_userId == uid) return;
    _userId = uid;
    _expensesSub?.cancel();
    _incomesSub?.cancel();
    _expenses.clear();
    _incomes.clear();

    _expensesSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .snapshots()
        .listen((snap) {
      _expenses
        ..clear()
        ..addAll(snap.docs.map((d) {
          final data = d.data();
          return FinanceItem(
            title: data['title']?.toString() ?? '',
            amount: (data['amount'] is num)
                ? (data['amount'] as num).toDouble()
                : double.tryParse(data['amount']?.toString() ?? '0') ?? 0.0,
            category: data['category']?.toString() ?? 'Others',
            date: DateTime.tryParse(data['date']?.toString() ?? '') ??
                DateTime.now(),
          );
        }));
      notifyListeners();
    });

    _incomesSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('incomes')
        .snapshots()
        .listen((snap) {
      _incomes
        ..clear()
        ..addAll(snap.docs.map((d) {
          final data = d.data();
          return FinanceItem(
            title: data['title']?.toString() ?? '',
            amount: (data['amount'] is num)
                ? (data['amount'] as num).toDouble()
                : double.tryParse(data['amount']?.toString() ?? '0') ?? 0.0,
            date: DateTime.tryParse(data['date']?.toString() ?? '') ??
                DateTime.now(),
          );
        }));
      notifyListeners();
    });
  }

  /// Detach listeners and clear user data.
  void detach() {
    _expensesSub?.cancel();
    _incomesSub?.cancel();
    _expensesSub = null;
    _incomesSub = null;
    _userId = null;
    _expenses.clear();
    _incomes.clear();
    notifyListeners();
  }
}
