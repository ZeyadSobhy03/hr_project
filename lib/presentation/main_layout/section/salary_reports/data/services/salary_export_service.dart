import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/salary_record.dart';

class SalaryExportService {
  const SalaryExportService._();

  static const _headers = [
    'الموظف',
    'القسم',
    'الراتب الأساسي',
    'أيام الحضور',
    'أيام الغياب',
    'ساعات الإضافي',
    'ساعات التأخير',
    'قيمة الإضافي',
    'إجمالي الخصم',
    'صافي الراتب',
  ];

  static String _amount(num value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);

  static List<List<String>> _table(List<SalaryRecord> records) => [
    for (final r in records)
      [
        r.employeeName,
        r.department,
        _amount(r.baseSalary),
        '${r.attendanceDays}',
        '${r.absenceDays}',
        _amount(r.overtimeHours),
        _amount(r.deductionHours),
        _amount(r.totalOvertime),
        _amount(r.totalDeduction),
        _amount(r.netSalary),
      ],
  ];

  static num _totalNet(List<SalaryRecord> records) =>
      records.fold<num>(0, (sum, r) => sum + r.netSalary);

  static String _fileName(int year, int month) =>
      'salary_report_$year-${month.toString().padLeft(2, '0')}';

  static Future<void> exportExcel({
    required List<SalaryRecord> records,
    required int year,
    required int month,
  }) async {
    final excel = Excel.createExcel();
    const sheetName = 'الرواتب';
    excel.rename(excel.getDefaultSheet()!, sheetName);
    final sheet = excel[sheetName];
    sheet.isRTL = true;

    sheet.appendRow([for (final h in _headers) TextCellValue(h)]);
    for (final r in records) {
      sheet.appendRow([
        TextCellValue(r.employeeName),
        TextCellValue(r.department),
        DoubleCellValue(r.baseSalary.toDouble()),
        IntCellValue(r.attendanceDays),
        IntCellValue(r.absenceDays),
        DoubleCellValue(r.overtimeHours.toDouble()),
        DoubleCellValue(r.deductionHours.toDouble()),
        DoubleCellValue(r.totalOvertime.toDouble()),
        DoubleCellValue(r.totalDeduction.toDouble()),
        DoubleCellValue(r.netSalary.toDouble()),
      ]);
    }
    sheet.appendRow([
      TextCellValue('الإجمالي'),
      for (var i = 0; i < 8; i++) TextCellValue(''),
      DoubleCellValue(_totalNet(records).toDouble()),
    ]);

    final bytes = excel.save();
    if (bytes == null) throw Exception('تعذر إنشاء ملف Excel');

    await FileSaver.instance.saveFile(
      name: _fileName(year, month),
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'xlsx',
      mimeType: MimeType.microsoftExcel,
    );
  }

  static Future<void> exportPdf({
    required List<SalaryRecord> records,
    required int year,
    required int month,
    required String monthName,
  }) async {
    final regular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Cairo-Regular.ttf'),
    );
    final bold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Cairo-Bold.ttf'),
    );

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: regular, bold: bold),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.all(24),
        header: (_) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Text(
            'تقرير الرواتب - $monthName $year',
            style: pw.TextStyle(font: bold, fontSize: 16),
          ),
        ),
        footer: (ctx) => pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text(
            '${ctx.pageNumber} / ${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
        build: (_) => [
          pw.TableHelper.fromTextArray(
            headers: _headers,
            data: _table(records),
            headerStyle: pw.TextStyle(font: bold, fontSize: 9),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.center,
            cellPadding: const pw.EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 3,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'إجمالي صافي الرواتب: ${_amount(_totalNet(records))}',
              style: pw.TextStyle(font: bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );

    await FileSaver.instance.saveFile(
      name: _fileName(year, month),
      bytes: await doc.save(),
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
  }
}