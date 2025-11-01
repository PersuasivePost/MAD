import 'package:flutter/material.dart';
import 'package:expense_tracker/services/finance_model.dart';

class ExpensePage extends StatefulWidget {
  static const routeName = '/expense';

  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  void initState() {
    super.initState();
    FinanceModel.instance.addListener(_onChange);
  }

  void _onChange() => setState(() {});

  @override
  void dispose() {
    FinanceModel.instance.removeListener(_onChange);
    super.dispose();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Shopping':
        return const Color(0xffee6856);
      case 'Grocery':
        return const Color(0xff69c56b);
      case 'Others':
        return const Color(0xff2aa6b8);
      default:
        return const Color(0xff2aa6b8);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Grocery':
        return Icons.shopping_cart;
      case 'Others':
        return Icons.category;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = FinanceModel.instance.expenses;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Expenses', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff904c6e),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header section with image
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Color(0xff904c6e),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
            ),
            child: Column(
              children: [
                Image.asset('images/expense.png',
                    height: 120, fit: BoxFit.contain),
                const SizedBox(height: 12.0),
                const Text(
                  'Track Your Expenses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Expenses list
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Expenses',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${FinanceModel.instance.totalExpenses.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffee6856),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'No expenses yet',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Tap + to add your first expense',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: items.length,
                    itemBuilder: (c, i) {
                      final it = items[i];
                      final color = _getCategoryColor(it.category);
                      final icon = _getCategoryIcon(it.category);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.2),
                            child: Icon(icon, color: color),
                          ),
                          title: Text(
                            it.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            it.category,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Text(
                            '\$${it.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Color(0xffee6856),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff904c6e),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddExpenseDialog(context),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) async {
    final titleCtl = TextEditingController();
    final amountCtl = TextEditingController();
    String selectedCategory = 'Shopping';
    DateTime selectedDate = DateTime.now();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: const Text(
                'Add Expense',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleCtl,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g., Groceries',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.edit),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: amountCtl,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        hintText: 'e.g., 50.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    // Date picker
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setDialogState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    // Category selection cards
                    _buildCategoryCard(
                      'Shopping',
                      Icons.shopping_bag,
                      const Color(0xffee6856),
                      selectedCategory == 'Shopping',
                      () {
                        setDialogState(() {
                          selectedCategory = 'Shopping';
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    _buildCategoryCard(
                      'Grocery',
                      Icons.shopping_cart,
                      const Color(0xff69c56b),
                      selectedCategory == 'Grocery',
                      () {
                        setDialogState(() {
                          selectedCategory = 'Grocery';
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    _buildCategoryCard(
                      'Others',
                      Icons.category,
                      const Color(0xff2aa6b8),
                      selectedCategory == 'Others',
                      () {
                        setDialogState(() {
                          selectedCategory = 'Others';
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff904c6e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    final a = double.tryParse(amountCtl.text) ?? 0.0;
                    Navigator.of(ctx).pop({
                      'title': titleCtl.text,
                      'amount': a,
                      'category': selectedCategory,
                      'date': selectedDate,
                    });
                  },
                  child:
                      const Text('Add', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      FinanceModel.instance.addExpense(
        result['title']?.isEmpty ?? true ? 'Expense' : result['title'],
        (result['amount'] ?? 0.0) as double,
        result['category'] ?? 'Others',
        date: result['date'] as DateTime?,
      );
    }
  }

  Widget _buildCategoryCard(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey[600]),
            const SizedBox(width: 12.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : Colors.grey[800],
              ),
            ),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }
}
