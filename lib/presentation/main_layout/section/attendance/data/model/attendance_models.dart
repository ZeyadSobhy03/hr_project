import '../../../../../../core/utils/app_format.dart';

enum DayStatus { present, absent, weeklyOff, holiday, upcoming }

class DailyAttendanceRow {
  const DailyAttendanceRow({
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.status,
    required this.scheduledIn,
    required this.scheduledOut,
    this.attendanceId,
    this.checkIn,
    this.checkOut,
  });

  final String employeeId;
  final String employeeName;
  final String department;
  final DayStatus status;
  final String scheduledIn;
  final String scheduledOut;
  final String? attendanceId;
  final String? checkIn;
  final String? checkOut;

  factory DailyAttendanceRow.fromJson(Map<String, dynamic> j) {
    String? t(String k) =>
        j[k] == null ? null : AppFormat.timeFromDb(j[k] as String);
    return DailyAttendanceRow(
      employeeId: j['employee_id'] as String,
      employeeName: j['employee_name'] as String,
      department: j['department_name'] as String,
      attendanceId: j['attendance_id'] as String?,
      checkIn: t('check_in'),
      checkOut: t('check_out'),
      scheduledIn: t('scheduled_in')!,
      scheduledOut: t('scheduled_out')!,
      status: switch (j['status'] as String) {
        'present' => DayStatus.present,
        'weekly_off' => DayStatus.weeklyOff,
        'holiday' => DayStatus.holiday,
        'upcoming' => DayStatus.upcoming,
        _ => DayStatus.absent,
      },
    );
  }
}

class PagedDaily {
  const PagedDaily({required this.items, required this.total});
  final List<DailyAttendanceRow> items;
  final int total;
}