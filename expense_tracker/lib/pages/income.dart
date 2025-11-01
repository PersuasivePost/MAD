import 'package:flutter/material.dart';
import 'package:expense_tracker/services/finance_model.dart';

class IncomePage extends StatefulWidget {
  static const routeName = '/income';

  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
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

  @override
  Widget build(BuildContext context) {
    final items = FinanceModel.instance.incomes;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Income', style: TextStyle(color: Colors.white)),
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
                Image.asset('images/income.png',
                    height: 120, fit: BoxFit.contain),
                const SizedBox(height: 12.0),
                const Text(
                  'Manage Your Income',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Income list
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Income Sources',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${FinanceModel.instance.totalIncome.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff69c56b),
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
                          Icons.account_balance_wallet,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'No income yet',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Tap + to add your first income',
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
                            backgroundColor:
                                const Color(0xff69c56b).withOpacity(0.2),
                            child: const Icon(
                              Icons.trending_up,
                              color: Color(0xff69c56b),
                            ),
                          ),
                          title: Text(
                            it.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            '${it.date.day}/${it.date.month}/${it.date.year}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Text(
                            '+\$${it.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Color(0xff69c56b),
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
        onPressed: () => _showAddIncomeDialog(context),
      ),
    );
  }

  void _showAddIncomeDialog(BuildContext context) async {
    final titleCtl = TextEditingController();
    final amountCtl = TextEditingController();
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
                'Add Income',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtl,
                    decoration: InputDecoration(
                      labelText: 'Source',
                      hintText: 'e.g., Salary, Freelance',
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
                      hintText: 'e.g., 1000.00',
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
                ],
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
      FinanceModel.instance.addIncome(
        result['title']?.isEmpty ?? true ? 'Income' : result['title'],
        (result['amount'] ?? 0.0) as double,
        date: result['date'] as DateTime?,
      );
    }
  }
}
