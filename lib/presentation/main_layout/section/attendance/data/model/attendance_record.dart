import 'package:hr_project/core/utils/app_format.dart';

class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.department,
    required this.employeeName,
    required this.checkIn,
    required this.checkOut,
    required this.date,
  });

  final String id;
  final String employeeId;
  final String department;
  final String employeeName;
  final String checkIn;
  final String? checkOut;
  final String date;

  factory AttendanceRecord.fromJson(Map<String, dynamic> j) => AttendanceRecord(
    id: j['id'] as String,
    employeeId: j['employee_id'] as String,
    department: j['department_name'] as String,
    employeeName: j['employee_name'] as String,
    checkIn: AppFormat.timeFromDb(j['check_in'] as String),
    checkOut: j['check_out'] == null
        ? null
        : AppFormat.timeFromDb(j['check_out'] as String),
    date: j['work_date'] as String,
  );
}

class AttendanceInput {
  const AttendanceInput({
    required this.employeeId,
    required this.date,
    required this.checkIn,
    this.checkOut,
  });

  final String employeeId;
  final DateTime date;
  final String checkIn;
  final String? checkOut;

  Map<String, dynamic> toJson() => {
    'employee_id': employeeId,
    'work_date': AppFormat.dateToDb(date),
    'check_in': AppFormat.timeToDb(checkIn),
    'check_out': checkOut == null || checkOut!.trim().isEmpty
        ? null
        : AppFormat.timeToDb(checkOut!),
  };
}

class EmployeeOption {
  const EmployeeOption({
    required this.id,
    required this.name,
    required this.department,
  });

  final String id;
  final String name;
  final String department;

  factory EmployeeOption.fromJson(Map<String, dynamic> j) => EmployeeOption(
    id: j['id'] as String,
    name: j['full_name'] as String,
    department: j['department_name'] as String,
  );
}

class PagedAttendance {
  const PagedAttendance({required this.items, required this.total});

  final List<AttendanceRecord> items;
  final int total;
}

enum ImportStatus { present, absent }

class ImportRow {
  const ImportRow({
    required this.rowNumber,
    required this.employeeName,
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
  });

  final int rowNumber;
  final String employeeName;
  final DateTime date;
  final ImportStatus status;
  final String? checkIn;
  final String? checkOut;
}

class ImportResult {
  const ImportResult({
    required this.inserted,
    this.deleted = 0,
    required this.errors,
  });

  final int inserted;
  final int deleted;
  final List<ImportError> errors;
}

class ImportError {
  const ImportError(
    this.rowNumber,
    this.message, {
    this.employeeName,
    this.date,
    this.status,
    this.checkIn,
    this.checkOut,
  });

  final int rowNumber;
  final String message;
  final String? employeeName;
  final String? date;
  final String? status;
  final String? checkIn;
  final String? checkOut;

  /// Fills any missing row data from a parsed [ImportRow].
  ImportError withRow(ImportRow r) => ImportError(
    rowNumber,
    message,
    employeeName: employeeName ?? r.employeeName,
    date: date ?? _ymd(r.date),
    status: status ?? (r.status == ImportStatus.present ? 'حاضر' : 'غائب'),
    checkIn: checkIn ?? r.checkIn,
    checkOut: checkOut ?? r.checkOut,
  );
}

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
