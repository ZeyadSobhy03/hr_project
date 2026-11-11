import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/presentation/main_layout/section/official_holidays/presentation/view/widgets/holiday_card.dart';

import '../../../data/models/holiday.dart';

class HolidaysTable extends StatelessWidget {
  const HolidaysTable({
    super.key,
    required this.holidays,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Holiday> holidays;
  final ValueChanged<Holiday> onEdit;
  final ValueChanged<Holiday> onDelete;

  static const _headerStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: ColorManger.textPrimary,
  );

  static const _cellStyle = TextStyle(
    fontSize: 13,
    color: ColorManger.textPrimary,
  );
  static const double _mobileBreakpoint = 700;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _mobileBreakpoint) {
          if (holidays.isEmpty) return const Center(child: Text('لا توجد إجازات'));

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),


            itemBuilder: (context, index) {
              final holiday = holidays[index];
              return HolidayCard(
                holiday: holiday,
                onEdit: () => onEdit(holiday),
                onDelete: () => onDelete(holiday),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: holidays.length,
          );
        }
        return Column(
          children: [
            Container(
              color: ColorManger.tableHeader,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: const Row(
                children: [
                  Expanded(child: Text('الاسم', style: _headerStyle)),
                  Expanded(child: Text('التاريخ', style: _headerStyle)),
                  Expanded(child: Text('العمليات', style: _headerStyle)),
                ],
              ),
            ),
            if (holidays.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('لا توجد إجازات رسمية مسجلة'),
              ),
            for (final h in holidays)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ColorManger.rowDivider),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(h.name, style: _cellStyle)),
                    Expanded(child: Text(h.displayDate, style: _cellStyle)),
                    Expanded(
                      child: Row(
                        children: [
                          CustomButton(
                            text: 'تعديل',
                            type: ButtonType.table,
                            onPressed: () => onEdit(h),
                          ),
                          const SizedBox(width: 8),
                          CustomButton(
                            text: 'حذف',
                            type: ButtonType.danger,
                            onPressed: () => onDelete(h),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
