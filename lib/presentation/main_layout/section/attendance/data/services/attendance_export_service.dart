import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AttendanceExportService {
  const AttendanceExportService._();

  static const _headers = [
    'الموظف',
    'القسم',
    'الحالة',
    'موعد الحضور',
    'موعد الانصراف',
    'الحضور',
    'الانصراف',
  ];

  static String _statusText(DayStatus s) => switch (s) {
    DayStatus.present => 'حاضر',
    DayStatus.absent => 'غائب',
    DayStatus.weeklyOff => 'إجازة أسبوعية',
    DayStatus.holiday => 'إجازة رسمية',
    DayStatus.upcoming => 'لم يحن بعد',
  };

  static List<List<String>> _table(List<DailyAttendanceRow> rows) => [
    for (final r in rows)
      [
        r.employeeName,
        r.department,
        _statusText(r.status),
        r.scheduledIn,
        r.scheduledOut,
        r.checkIn ?? '-',
        r.checkOut ?? '-',
      ],
  ];

  static String _dateText(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  // ------------------------------------------------------------ Excel
  static Future<void> exportExcel({
    required List<DailyAttendanceRow> rows,
    required DateTime date,
  }) async {
    final excel = Excel.createExcel();
    const sheetName = 'الحضور';
    excel.rename(excel.getDefaultSheet()!, sheetName);
    final sheet = excel[sheetName];
    sheet.isRTL = true;

    sheet.appendRow([for (final h in _headers) TextCellValue(h)]);
    for (final row in _table(rows)) {
      sheet.appendRow([for (final cell in row) TextCellValue(cell)]);
    }

    final bytes = excel.save();
    if (bytes == null) throw Exception('تعذر إنشاء ملف Excel');

    await FileSaver.instance.saveFile(
      name: 'attendance_${_dateText(date)}',
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'xlsx',
      mimeType: MimeType.microsoftExcel,
    );
  }

  static Future<void> exportPdf({
    required List<DailyAttendanceRow> rows,
    required DateTime date,
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
            'تقرير الحضور اليومي - ${_dateText(date)}',
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
            data: _table(rows),
            headerStyle: pw.TextStyle(font: bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.center,
            cellPadding: const pw.EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 3,
            ),
          ),
        ],
      ),
    );

    await FileSaver.instance.saveFile(
      name: 'attendance_${_dateText(date)}',
      bytes: await doc.save(),
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
  }
}