import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/style/style_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/core/utils/app_format.dart';

import '../../view_model/attendance_view_model.dart';

class DailyAttendanceFilters extends StatelessWidget {
  const DailyAttendanceFilters({
    super.key,
    required this.searchCtrl,
    required this.date,
    required this.filter,
    required this.isSaving,
    required this.canMarkAll,
    required this.onPickDate,
    required this.onFilterChanged,
    required this.onSearch,
    required this.onMarkAll,
  });

  final TextEditingController searchCtrl;
  final DateTime date;
  final DayFilter filter;
  final bool isSaving;
  final bool canMarkAll;
  final VoidCallback onPickDate;
  final ValueChanged<DayFilter> onFilterChanged;
  final VoidCallback onSearch;
  final VoidCallback onMarkAll;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CustomButton(
          text: AppFormat.dateToDb(date),
          type: ButtonType.secondary,
          icon: Icons.calendar_today,
          onPressed: onPickDate,
        ),
        SegmentedButton<DayFilter>(
          style: SegmentedButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            selectedBackgroundColor: Colors.blue.shade100,
            selectedForegroundColor: Colors.blue.shade900,
          ),
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: DayFilter.all, label: Text('الكل')),
            ButtonSegment(value: DayFilter.present, label: Text('حضروا')),
            ButtonSegment(value: DayFilter.absent, label: Text('غابوا')),
          ],
          selected: {filter},
          onSelectionChanged: (s) => onFilterChanged(s.first),
        ),
        SizedBox(
          width: 240,
          child: TextField(
            controller: searchCtrl,
            decoration: AppStyles.input(hint: 'بحث باسم الموظف أو القسم'),
            onSubmitted: (_) => onSearch(),
          ),
        ),
        CustomButton(text: 'بحث', onPressed: onSearch),
        CustomButton(
          text: 'تسجيل الكل حاضر',
          type: ButtonType.secondary,
          icon: Icons.done_all,
          isLoading: isSaving,
          onPressed: canMarkAll ? onMarkAll : null,
        ),
      ],
    );
  }
}