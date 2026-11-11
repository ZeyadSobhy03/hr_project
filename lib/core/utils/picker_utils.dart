import 'package:flutter/material.dart';

import '../resources/colors/color_manger.dart';

Future<void> pickDate(
    BuildContext context,
    TextEditingController controller,
    ) async {
  final picked = await showDatePicker(
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ColorManger.primary,
            onPrimary: Colors.white,
            onSurface: ColorManger.primary,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: ColorManger.primary,
            ),
          ),
        ),
        child: child!,
      );
    },
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1950),
    lastDate: DateTime(2100),
  );
  if (picked != null) {
    final m = picked.month.toString().padLeft(2, '0');
    final d = picked.day.toString().padLeft(2, '0');
    controller.text = '$m/$d/${picked.year}';
  }
}

Future<void> pickTime(
    BuildContext context,
    TextEditingController controller,
    ) async {
  final picked = await showTimePicker(
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ColorManger.primary,
            onPrimary: Colors.white,
            onSurface: ColorManger.primary,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: ColorManger.primary,
            ),
          ),
        ),
        child: child!,
      );
    },
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked != null) {
    final h = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
    final m = picked.minute.toString().padLeft(2, '0');
    final p = picked.period == DayPeriod.am ? 'AM' : 'PM';
    controller.text = '${h.toString().padLeft(2, '0')}:$m $p';
  }
}