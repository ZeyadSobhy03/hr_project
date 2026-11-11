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
  static const double _mobileBreakpoint = 700;
  static const _columns = <(String, int)>[
    ('م', 1), ('اسم الموظف', 4), ('القسم', 3),
    ('وقت الحضور', 3), ('وقت الانصراف', 3), ('الحالة', 4),
  ];

  static const _style = TextStyle(fontSize: 13, color: ColorManger.textPrimary);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < _mobileBreakpoint) return _mobileList();

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


  Widget _mobileList() {
    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('لا يوجد موظفون', style: _style)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) _card(rows[i], i + 1),
      ],
    );
  }

  Widget _card(DailyAttendanceRow r, int n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManger.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorManger.rowDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey.shade200,
                child: Text('$n', style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.employeeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _style.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      r.department,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _style.copyWith(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _timeBox('الحضور', r, r.checkIn, r.scheduledIn, true),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _timeBox('الانصراف', r, r.checkOut, r.scheduledOut, false),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _mobileStatus(r),
        ],
      ),
    );
  }

  Widget _timeBox(
      String label,
      DailyAttendanceRow r,
      String? value,
      String scheduled,
      bool isIn,
      ) {
    final present = r.status == DayStatus.present;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: _style.copyWith(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 2),
          present
              ? InkWell(
            onTap: () => onEditTime(r, isIn),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                value ?? 'لم يسجل',
                style: _style.copyWith(
                  color: ColorManger.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          )
              : Text(scheduled, style: _style),
        ],
      ),
    );
  }

  Widget _mobileStatus(DailyAttendanceRow r) {
    switch (r.status) {
      case DayStatus.present:
      case DayStatus.absent:
        return SizedBox(width: double.infinity, child: _segmented(r));
      default:
        return Center(child: _statusText(r));
    }
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

  Widget _segmented(DailyAttendanceRow r) {
    return SegmentedButton<DayStatus>(
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
    );
  }

  Widget _statusText(DailyAttendanceRow r) {
    switch (r.status) {
      case DayStatus.weeklyOff:
        return const Text('إجازة أسبوعية', style: _style);
      case DayStatus.holiday:
        return const Text('إجازة رسمية', style: _style);
      case DayStatus.upcoming:
        return const Text('لم يحن بعد', style: _style);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _statusCell(DailyAttendanceRow r) {
    switch (r.status) {
      case DayStatus.present:
      case DayStatus.absent:
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: _segmented(r),
        );
      default:
        return _statusText(r);
    }
  }
}