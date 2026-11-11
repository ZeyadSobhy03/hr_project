import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart' hide TextSpan;
import 'package:flutter/widgets.dart' show TextSpan;
import 'package:hr_project/core/errors/app_exception.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_record.dart';


class ParsedImport {
  const ParsedImport({required this.rows, required this.errors});
  final List<ImportRow> rows;
  final List<ImportError> errors;
}


class AttendanceImportService {
  const AttendanceImportService._();

  static const _presentWords = {'حاضر', 'حضور', 'present', 'p'};
  static const _absentWords = {'غائب', 'غايب', 'غياب', 'absent', 'a'};

  static ParsedImport parse(Uint8List bytes) {
    final Excel excel;
    try {
      excel = Excel.decodeBytes(bytes);
    } catch (_) {
      throw const AppException('الملف غير صالح، اختر ملف Excel بصيغة xlsx');
    }
    if (excel.tables.isEmpty) {
      throw const AppException('الملف فاضي');
    }

    final sheet = excel.tables.values.first;
    final rows = <ImportRow>[];
    final errors = <ImportError>[];

    for (var i = 1; i < sheet.rows.length; i++) {
      final cells = sheet.rows[i];
      final n = i + 1;

      final nameV = _at(cells, 0);
      final dateV = _at(cells, 1);
      final statusV = _at(cells, 2);
      final inV = _at(cells, 3);
      final outV = _at(cells, 4);

      if ([nameV, dateV, statusV, inV, outV].every(_isBlank)) continue;

      final name = _text(nameV);
      final date = _date(dateV);

      ImportError fail(String message) => ImportError(
        n,
        message,
        employeeName: name,
        date: date != null ? _ymd(date) : _text(dateV),
        status: _text(statusV),
        checkIn: _time(inV) ?? _text(inV),
        checkOut: _time(outV) ?? _text(outV),
      );

      if (name.isEmpty) {
        errors.add(fail('اسم الموظف مطلوب'));
        continue;
      }

      if (date == null) {
        errors.add(fail('التاريخ غير صحيح'));
        continue;
      }

      final status = _status(statusV);
      if (status == null) {
        errors.add(fail('الحالة يجب أن تكون حاضر أو غائب'));
        continue;
      }

      if (status == ImportStatus.absent) {
        rows.add(ImportRow(
          rowNumber: n,
          employeeName: name,
          date: date,
          status: status,
        ));
        continue;
      }

      if (_isBlank(inV)) {
        errors.add(fail('وقت الحضور مطلوب للموظف الحاضر'));
        continue;
      }
      final checkIn = _time(inV);
      if (checkIn == null) {
        errors.add(fail('وقت الحضور غير صحيح'));
        continue;
      }
      String? checkOut;
      if (!_isBlank(outV)) {
        checkOut = _time(outV);
        if (checkOut == null) {
          errors.add(fail('وقت الانصراف غير صحيح'));
          continue;
        }
        if (checkOut.compareTo(checkIn) <= 0) {
          errors.add(fail('وقت الانصراف يجب أن يكون بعد وقت الحضور'));
          continue;
        }
      }

      rows.add(ImportRow(
        rowNumber: n,
        employeeName: name,
        date: date,
        status: status,
        checkIn: checkIn,
        checkOut: checkOut,
      ));
    }

    return ParsedImport(rows: rows, errors: errors);
  }


  static CellValue? _at(List<Data?> row, int i) =>
      i < row.length ? row[i]?.value : null;

  static bool _isBlank(CellValue? v) => _text(v).isEmpty;

  static String _text(CellValue? v) {
    if (v == null) return '';
    final dynamic raw = v is TextCellValue ? v.value : v.toString();
    final s = raw is TextSpan ? raw.toPlainText() : raw.toString();
    return _latinDigits(s).trim();
  }

  static String _latinDigits(String s) =>
      s.replaceAllMapped(RegExp('[٠-٩۰-۹]'), (m) {
        final c = m[0]!.codeUnitAt(0);
        return String.fromCharCode(
            c >= 0x06F0 ? c - 0x06F0 + 48 : c - 0x0660 + 48);
      });

  static ImportStatus? _status(CellValue? v) {
    final s = _text(v).toLowerCase();
    if (_presentWords.contains(s)) return ImportStatus.present;
    if (_absentWords.contains(s)) return ImportStatus.absent;
    return null;
  }

  static DateTime? _date(CellValue? v) {
    if (v == null) return null;
    if (v is DateCellValue) return _valid(v.year, v.month, v.day);
    if (v is DateTimeCellValue) return _valid(v.year, v.month, v.day);
    if (v is IntCellValue) return _serial(v.value.toDouble());
    if (v is DoubleCellValue) return _serial(v.value);

    final s = _text(v);
    var m = RegExp(r'^(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})').firstMatch(s);
    if (m != null) {
      return _valid(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!));
    }
    m = RegExp(r'^(\d{1,2})[-/.](\d{1,2})[-/.](\d{4})').firstMatch(s);
    if (m != null) {
      return _valid(int.parse(m[3]!), int.parse(m[2]!), int.parse(m[1]!));
    }
    return null;
  }

  static DateTime? _serial(double d) {
    if (d < 20000 || d > 80000) return null;
    final dt = DateTime.utc(1899, 12, 30).add(Duration(days: d.floor()));
    return DateTime(dt.year, dt.month, dt.day);
  }

  static DateTime? _valid(int y, int m, int d) {
    final dt = DateTime(y, m, d);
    return dt.year == y && dt.month == m && dt.day == d ? dt : null;
  }

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  static String? _time(CellValue? v) {
    if (v == null) return null;
    if (v is TimeCellValue) return _hm(v.hour, v.minute);
    if (v is DateTimeCellValue) return _hm(v.hour, v.minute);
    if (v is DoubleCellValue) {
      if (v.value < 0 || v.value >= 1) return null;
      final total = (v.value * 1440).round();
      return _hm((total ~/ 60) % 24, total % 60);
    }

    final s = _text(v);
    final m = RegExp(
      r'^(\d{1,2}):(\d{2})(?::\d{2})?\s*(AM|PM|ص|م)?$',
      caseSensitive: false,
    ).firstMatch(s);
    if (m == null) return null;

    var h = int.parse(m[1]!);
    final min = int.parse(m[2]!);
    final suffix = m[3]?.toUpperCase();
    if (min > 59 || h > 23) return null;
    if (suffix != null) {
      if (h < 1 || h > 12) return null;
      if (h == 12) h = 0;
      if (suffix == 'PM' || suffix == 'م') h += 12;
    }
    return _hm(h, min);
  }

  static String _hm(int h, int m) =>
      '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}