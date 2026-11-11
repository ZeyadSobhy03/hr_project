import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';

import '../../../data/model/employee.dart';

class EmployeesTable extends StatelessWidget {
  const EmployeesTable({
    super.key,
    required this.employees,
    required this.onEdit,
    required this.onDelete,
    this.showSalary = true,
  });

  final List<Employee> employees;
  final ValueChanged<Employee> onEdit;
  final ValueChanged<Employee> onDelete;

  final bool showSalary;

  static const double _minWidth = 900;

  static const _salaryTitle = 'الراتب';
  static const _actionsTitle = 'العمليات';

  static const _columns = <(String, int)>[
    ('م', 1),
    ('الاسم', 3),
    ('القسم', 2),
    ('رقم التليفون', 3),
    (_salaryTitle, 2),
    ('تاريخ التعاقد', 3),
    (_actionsTitle, 4),
  ];

  static const _headerStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: ColorManger.textPrimary,
  );

  static const _cellStyle = TextStyle(
    fontSize: 13,
    color: ColorManger.textPrimary,
  );

  List<(String, int)> get _visibleColumns => showSalary
      ? _columns
      : _columns.where((c) => c.$1 != _salaryTitle).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManger.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManger.cardBorder),
      ),
      child: LayoutBuilder(
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
                  if (employees.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text('لا يوجد موظفين', style: _cellStyle),
                    ),
                  for (int i = 0; i < employees.length; i++)
                    _dataRow(i + 1, employees[i]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _headerRow() {
    return Container(
      color: ColorManger.tableHeader,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          for (final c in _visibleColumns)
            Expanded(flex: c.$2, child: Text(c.$1, style: _headerStyle)),
        ],
      ),
    );
  }

  Widget _dataRow(int index, Employee e) {
    final values = <String, String>{
      'م': '$index',
      'الاسم': e.name,
      'القسم': e.department ?? '-',
      'رقم التليفون': e.phone,
      _salaryTitle: e.salary ?? '-',
      'تاريخ التعاقد': e.hireDate,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorManger.rowDivider)),
      ),
      child: Row(
        children: [
          for (final c in _visibleColumns)
            Expanded(
              flex: c.$2,
              child: c.$1 == _actionsTitle
                  ? Row(
                children: [
                  CustomButton(
                    text: 'تعديل',
                    type: ButtonType.table,
                    onPressed: () => onEdit(e),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    text: 'حذف',
                    type: ButtonType.danger,
                    onPressed: () => onDelete(e),
                  ),
                ],
              )
                  : Text(values[c.$1] ?? '', style: _cellStyle),
            ),
        ],
      ),
    );
  }
}