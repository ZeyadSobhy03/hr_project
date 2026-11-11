import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';

import '../../../data/models/salary_record.dart';

class SalaryTable extends StatelessWidget {
  const SalaryTable({
    super.key,
    required this.records,
    required this.onDetails,
  });

  final List<SalaryRecord> records;
  final ValueChanged<SalaryRecord> onDetails;

  static const double _minWidth = 980;

  static const _columns = <(String, int)>[
    ('اسم الموظف', 3),
    ('القسم', 2),
    ('الراتب الأساسي', 2),
    ('أيام الحضور', 2),
    ('أيام الغياب', 2),
    ('الإضافي بالساعات', 2),
    ('الخصم بالساعات', 2),
    ('إجمالي الإضافي', 2),
    ('إجمالي الخصم', 2),
    ('الصافي', 2),
    ('العمليات', 2),
  ];

  static String _fmt(num n) =>
      n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < _minWidth
            ? _minWidth
            : constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: width,
            child: Column(
              children: [
                _headerRow(),
                if (records.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('لا توجد بيانات رواتب للفترة المحددة'),
                  ),
                for (final r in records) _dataRow(r),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _headerRow() {
    return Container(
      color: ColorManger.tableHeader,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          for (final c in _columns)
            Expanded(
              flex: c.$2,
              child: Text(
                c.$1,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ColorManger.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _dataRow(SalaryRecord r) {
    const style = TextStyle(fontSize: 13, color: ColorManger.textPrimary);

    Widget cell(int index, String text, {bool bold = false}) => Expanded(
      flex: _columns[index].$2,
      child: Text(
        text,
        style: bold ? style.copyWith(fontWeight: FontWeight.w700) : style,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorManger.rowDivider)),
      ),
      child: Row(
        children: [
          cell(0, r.employeeName),
          cell(1, r.department),
          cell(2, _fmt(r.baseSalary)),
          cell(3, '${r.attendanceDays}'),
          cell(4, '${r.absenceDays}'),
          cell(5, _fmt(r.overtimeHours)),
          cell(6, _fmt(r.deductionHours)),
          cell(7, _fmt(r.totalOvertime)),
          cell(8, _fmt(r.totalDeduction)),
          cell(9, _fmt(r.netSalary), bold: true),
          Expanded(
            flex: _columns[10].$2,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: CustomButton(
                text: 'تفاصيل',
                type: ButtonType.table,
                onPressed: () => onDetails(r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
