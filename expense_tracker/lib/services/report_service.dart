import 'dart:io';
import 'dart:math' as math;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:expense_tracker/services/finance_model.dart';
import 'package:expense_tracker/services/user_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportService {
  /// Request storage permissions if needed
  static Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), request different permissions
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // Try to request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      // If still not granted, try manageExternalStorage (for Android 11+)
      if (!status.isGranted) {
        final manageStatus = await Permission.manageExternalStorage.request();
        if (manageStatus.isGranted) {
          return true;
        }
      }

      // Even if permission denied, we can still try - the package handles it
      print('Storage permission status: $status');
      return true; // Allow attempt anyway
    }
    return true; // iOS or other platforms
  }

  /// Get the directory to save report files.
  /// Saves directly to public Downloads folder!
  static Future<Directory?> _getReportDirectory() async {
    try {
      if (Platform.isAndroid) {
        // Direct path to Downloads folder
        final Directory downloadsDir =
            Directory('/storage/emulated/0/Download');

        // Check if it exists, if not create it
        if (!await downloadsDir.exists()) {
          try {
            await downloadsDir.create(recursive: true);
            print('Created Downloads directory');
          } catch (e) {
            print('Could not create Downloads directory: $e');
          }
        }

        // Verify it exists now
        if (await downloadsDir.exists()) {
          print('Using Downloads directory: ${downloadsDir.path}');
          return downloadsDir;
        }

        print('Downloads directory does not exist, using fallback');
      }

      // Fallback for iOS or if Downloads doesn't work
      print('Using app documents directory as fallback');
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      print('Error getting downloads directory: $e');
      // Ultimate fallback
      try {
        return await getApplicationDocumentsDirectory();
      } catch (e2) {
        print('Failed to get documents directory: $e2');
        return null;
      }
    }
  }

  static Future<String?> generatePDFReport({required bool isYear}) async {
    try {
      // Request storage permission first
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        print('Storage permission not granted');
        return null;
      }

      final pdf = pw.Document();
      final now = DateTime.now();
      final userName = UserService.instance.userName.isNotEmpty
          ? UserService.instance.userName
          : 'User';

      // Get data
      final totalExpense = FinanceModel.instance.totalExpensesForPeriod(isYear);
      final totalIncome = FinanceModel.instance.totalIncomeForPeriod(isYear);
      final categoryTotals = FinanceModel.instance.categoryTotals(
        ['Shopping', 'Grocery', 'Others'],
        isYear: isYear,
      );

      final expenses = FinanceModel.instance.expenses;
      final incomes = FinanceModel.instance.incomes;

      // Filter by period
      final start =
          isYear ? DateTime(now.year, 1, 1) : DateTime(now.year, now.month, 1);
      final filteredExpenses =
          expenses.where((e) => e.date.isAfter(start)).toList();
      final filteredIncomes =
          incomes.where((i) => i.date.isAfter(start)).toList();

      final periodName = isYear
          ? 'Year ${now.year}'
          : 'Month ${_getMonthName(now.month)} ${now.year}';

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header
              pw.Header(
                level: 0,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Expense Tracker Report',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.purple900,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Generated for: $userName',
                      style: const pw.TextStyle(
                          fontSize: 14, color: PdfColors.grey700),
                    ),
                    pw.Text(
                      'Period: $periodName',
                      style: const pw.TextStyle(
                          fontSize: 14, color: PdfColors.grey700),
                    ),
                    pw.Text(
                      'Date: ${now.day}/${now.month}/${now.year}',
                      style: const pw.TextStyle(
                          fontSize: 12, color: PdfColors.grey600),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Summary Cards
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard('Total Income',
                      '\$${totalIncome.toStringAsFixed(2)}', PdfColors.green),
                  _buildSummaryCard('Total Expenses',
                      '\$${totalExpense.toStringAsFixed(2)}', PdfColors.red),
                  _buildSummaryCard(
                      'Balance',
                      '\$${(totalIncome - totalExpense).toStringAsFixed(2)}',
                      PdfColors.blue),
                ],
              ),

              pw.SizedBox(height: 30),

              // Pie Chart Section
              pw.Text(
                'Expense Breakdown by Category',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 15),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Pie Chart
                  pw.Container(
                    width: 200,
                    height: 200,
                    child: pw.CustomPaint(
                      painter: (canvas, size) {
                        _drawPieChart(
                          canvas,
                          size,
                          categoryTotals,
                        );
                      },
                    ),
                  ),
                  pw.SizedBox(width: 40),
                  // Legend
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('Shopping',
                            categoryTotals['Shopping'] ?? 0, PdfColors.red300),
                        pw.SizedBox(height: 8),
                        _buildLegendItem('Grocery',
                            categoryTotals['Grocery'] ?? 0, PdfColors.green300),
                        pw.SizedBox(height: 8),
                        _buildLegendItem('Others',
                            categoryTotals['Others'] ?? 0, PdfColors.blue300),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Expense Table
              if (filteredExpenses.isNotEmpty) ...[
                pw.Text(
                  'Expense Details',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.purple900),
                  cellAlignment: pw.Alignment.centerLeft,
                  data: [
                    ['Date', 'Title', 'Category', 'Amount'],
                    ...filteredExpenses.map((e) => [
                          '${e.date.day}/${e.date.month}/${e.date.year}',
                          e.title,
                          e.category,
                          '\$${e.amount.toStringAsFixed(2)}',
                        ]),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],

              // Income Table
              if (filteredIncomes.isNotEmpty) ...[
                pw.Text(
                  'Income Details',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.green700),
                  cellAlignment: pw.Alignment.centerLeft,
                  data: [
                    ['Date', 'Title', 'Amount'],
                    ...filteredIncomes.map((i) => [
                          '${i.date.day}/${i.date.month}/${i.date.year}',
                          i.title,
                          '\$${i.amount.toStringAsFixed(2)}',
                        ]),
                  ],
                ),
              ],
            ];
          },
        ),
      );

      // Save file
      final directory = await _getReportDirectory();
      if (directory == null) {
        print(
            'Error: Could not determine a valid directory for saving the report');
        return null;
      }

      final fileName =
          'ExpenseReport_${periodName.replaceAll(' ', '_')}_${now.day}_${now.month}_${now.year}.pdf';
      final file = File('${directory.path}/$fileName');

      try {
        await file.writeAsBytes(await pdf.save());
        print('PDF Report saved successfully to: ${file.path}');
        return file.path;
      } catch (writeError) {
        print('Error writing PDF file: $writeError');
        return null;
      }
    } catch (e) {
      print('Error generating PDF: $e');
      return null;
    }
  }

  static Future<String?> generateCSVReport({required bool isYear}) async {
    try {
      // Request storage permission first
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        print('Storage permission not granted');
        return null;
      }

      final now = DateTime.now();
      final userName = UserService.instance.userName.isNotEmpty
          ? UserService.instance.userName
          : 'User';

      final totalExpense = FinanceModel.instance.totalExpensesForPeriod(isYear);
      final totalIncome = FinanceModel.instance.totalIncomeForPeriod(isYear);

      final expenses = FinanceModel.instance.expenses;
      final incomes = FinanceModel.instance.incomes;

      final start =
          isYear ? DateTime(now.year, 1, 1) : DateTime(now.year, now.month, 1);
      final filteredExpenses =
          expenses.where((e) => e.date.isAfter(start)).toList();
      final filteredIncomes =
          incomes.where((i) => i.date.isAfter(start)).toList();

      final periodName = isYear
          ? 'Year ${now.year}'
          : 'Month ${_getMonthName(now.month)} ${now.year}';

      List<List<dynamic>> rows = [];

      // Header
      rows.add(['Expense Tracker Report']);
      rows.add(['User', userName]);
      rows.add(['Period', periodName]);
      rows.add(['Generated', '${now.day}/${now.month}/${now.year}']);
      rows.add([]);

      // Summary
      rows.add(['Summary']);
      rows.add(['Total Income', totalIncome.toStringAsFixed(2)]);
      rows.add(['Total Expenses', totalExpense.toStringAsFixed(2)]);
      rows.add(['Balance', (totalIncome - totalExpense).toStringAsFixed(2)]);
      rows.add([]);

      // Expenses
      if (filteredExpenses.isNotEmpty) {
        rows.add(['Expenses']);
        rows.add(['Date', 'Title', 'Category', 'Amount']);
        for (var e in filteredExpenses) {
          rows.add([
            '${e.date.day}/${e.date.month}/${e.date.year}',
            e.title,
            e.category,
            e.amount.toStringAsFixed(2),
          ]);
        }
        rows.add([]);
      }

      // Incomes
      if (filteredIncomes.isNotEmpty) {
        rows.add(['Incomes']);
        rows.add(['Date', 'Title', 'Amount']);
        for (var i in filteredIncomes) {
          rows.add([
            '${i.date.day}/${i.date.month}/${i.date.year}',
            i.title,
            i.amount.toStringAsFixed(2),
          ]);
        }
      }

      String csv = const ListToCsvConverter().convert(rows);

      // Save file
      final directory = await _getReportDirectory();
      if (directory == null) {
        print(
            'Error: Could not determine a valid directory for saving the report');
        return null;
      }

      final fileName =
          'ExpenseReport_${periodName.replaceAll(' ', '_')}_${now.day}_${now.month}_${now.year}.csv';
      final file = File('${directory.path}/$fileName');

      try {
        await file.writeAsString(csv);
        print('CSV Report saved successfully to: ${file.path}');
        return file.path;
      } catch (writeError) {
        print('Error writing CSV file: $writeError');
        return null;
      }
    } catch (e) {
      print('Error generating CSV: $e');
      return null;
    }
  }

  static pw.Widget _buildSummaryCard(
      String title, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color, width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          pw.Text(title, style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
                fontSize: 16, fontWeight: pw.FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildLegendItem(
      String label, double amount, PdfColor color) {
    return pw.Row(
      children: [
        pw.Container(
          width: 16,
          height: 16,
          decoration: pw.BoxDecoration(
            color: color,
            shape: pw.BoxShape.circle,
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
        pw.Spacer(),
        pw.Text('\$${amount.toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static void _drawPieChart(
    PdfGraphics canvas,
    PdfPoint size,
    Map<String, double> categoryTotals,
  ) {
    final center = PdfPoint(size.x / 2, size.y / 2);
    final radius = math.min(size.x, size.y) / 2;

    final shopping = categoryTotals['Shopping'] ?? 0.0;
    final grocery = categoryTotals['Grocery'] ?? 0.0;
    final others = categoryTotals['Others'] ?? 0.0;
    final total = shopping + grocery + others;

    if (total <= 0) return;

    final values = [shopping, grocery, others];
    final colors = [PdfColors.red300, PdfColors.green300, PdfColors.blue300];

    double startAngle = -math.pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;

      canvas
        ..setFillColor(colors[i])
        ..moveTo(center.x, center.y);

      // Draw arc
      final steps = 50;
      for (int j = 0; j <= steps; j++) {
        final angle = startAngle + (sweepAngle * j / steps);
        final x = center.x + radius * math.cos(angle);
        final y = center.y + radius * math.sin(angle);
        canvas.lineTo(x, y);
      }

      canvas
        ..lineTo(center.x, center.y)
        ..fillPath();

      startAngle += sweepAngle;
    }
  }

  static String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}
