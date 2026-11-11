import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_models.dart';

class DailyAttendanceTable extends StatelessWidget {
  const DailyAttendanceTable({
    super.key,
    required this.rows,
    required this.onPresent,
    required this.onAbsent,
    required this.onEditTime,
  });

  final List<DailyAttendanceRow> rows;
  final ValueChanged<DailyAttendanceRow> onPresent;
  final ValueChanged<DailyAttendanceRow> onAbsent;
  final void Function(DailyAttendanceRow row, bool isCheckIn) onEditTime;

  static const double _minWidth = 820;
  static const _columns = <(String, int)>[
    ('م', 1), ('اسم الموظف', 4), ('القسم', 3),
    ('وقت الحضور', 3), ('وقت الانصراف', 3), ('الحالة', 4),
  ];

  static const _style = TextStyle(fontSize: 13, color: ColorManger.textPrimary);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final width = c.maxWidth < _minWidth ? _minWidth : c.maxWidth;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: width,
          child: Column(children: [
            Container(
              color: ColorManger.tableHeader,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(children: [
                for (final col in _columns)
                  Expanded(
                    flex: col.$2,
                    child: Text(col.$1,
                        style: _style.copyWith(fontWeight: FontWeight.w700)),
                  ),
              ]),
            ),
            if (rows.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('لا يوجد موظفون', style: _style),
              ),
            for (var i = 0; i < rows.length; i++) _row(rows[i], i + 1),
          ]),
        ),
      );
    });
  }

  Widget _row(DailyAttendanceRow r, int n) {
    final present = r.status == DayStatus.present;

    Widget text(int i, String t) =>
        Expanded(flex: _columns[i].$2, child: Text(t, style: _style));

    Widget timeCell(int i, String? value, String scheduled, bool isIn) => Expanded(
      flex: _columns[i].$2,
      child: present
          ? Align(
        alignment: AlignmentDirectional.centerStart,
        child: InkWell(
          onTap: () => onEditTime(r, isIn),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              value ?? 'لم يسجل',
              style: _style.copyWith(
                color: ColorManger.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      )
          : Text(scheduled, style: _style),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorManger.rowDivider)),
      ),
      child: Row(children: [
        text(0, '$n'),
        text(1, r.employeeName),
        text(2, r.department),
        timeCell(3, r.checkIn, r.scheduledIn, true),
        timeCell(4, r.checkOut, r.scheduledOut, false),
        Expanded(flex: _columns[5].$2, child: _statusCell(r)),
      ]),
    );
  }

  Widget _statusCell(DailyAttendanceRow r) {
    switch (r.status) {
      case DayStatus.present:
      case DayStatus.absent:
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: SegmentedButton<DayStatus>(
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              selectedBackgroundColor: Colors.blue.shade100,
              selectedForegroundColor: Colors.blue.shade900,
            ),
            showSelectedIcon: false,
            emptySelectionAllowed: false,
            segments: const [
              ButtonSegment(value: DayStatus.present, label: Text('حاضر')),
              ButtonSegment(value: DayStatus.absent, label: Text('غائب')),
            ],
            selected: {r.status},
            onSelectionChanged: (s) {
              if (s.first == r.status) return;
              s.first == DayStatus.present ? onPresent(r) : onAbsent(r);
            },
          ),
        );
      case DayStatus.weeklyOff:
        return const Text('إجازة أسبوعية', style: _style);
      case DayStatus.holiday:
        return const Text('إجازة رسمية', style: _style);
      case DayStatus.upcoming:
        return const Text('لم يحن بعد', style: _style);
    }
  }
}
