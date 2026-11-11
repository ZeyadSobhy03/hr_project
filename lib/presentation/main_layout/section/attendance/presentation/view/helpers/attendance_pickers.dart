import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_models.dart';

abstract final class AttendancePickers {
  static Future<DateTime?> pickDate(BuildContext context, DateTime current) {
    return showDatePicker(
      builder: _themed,
      context: context,
      initialDate: current,
      firstDate: DateTime(2008),
      lastDate: DateTime.now(),
    );
  }

  static Future<String?> pickTime(
      BuildContext context,
      DailyAttendanceRow r,
      bool isCheckIn,
      ) async {
    final current = isCheckIn ? r.checkIn : r.checkOut;
    final fallback = isCheckIn ? r.scheduledIn : r.scheduledOut;

    final picked = await showTimePicker(
      context: context,
      initialTime:
      _parseTime(current) ??
          _parseTime(fallback) ??
          const TimeOfDay(hour: 9, minute: 0),
      builder: _themed,
    );
    if (picked == null) return null;

    return '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}';
  }

  static Widget _themed(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: ColorManger.primary,
          onPrimary: ColorManger.white,
          onSurface: ColorManger.black,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: ColorManger.primary),
        ),
      ),
      child: child!,
    );
  }

  static TimeOfDay? _parseTime(String? s) {
    if (s == null) return null;
    final m = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)?$',
      caseSensitive: false,
    ).firstMatch(s.trim());
    if (m == null) return null;
    var h = int.parse(m[1]!);
    final min = int.parse(m[2]!);
    final suffix = m[3]?.toUpperCase();
    if (suffix != null) {
      if (h == 12) h = 0;
      if (suffix == 'PM') h += 12;
    }
    return TimeOfDay(hour: h, minute: min);
  }
}