import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

import '../models/screen_permission.dart';
import '../helpers/permission_helper.dart';
import 'permission_checkbox.dart';

class PermissionsMatrix extends StatelessWidget {
  const PermissionsMatrix({
    super.key,
    required this.values,
    required this.onChanged,
  });

  final List<ScreenPermission> values;
  final ValueChanged<List<ScreenPermission>> onChanged;

  // تحديد عمود بالكامل
  void _toggleColumn(String action) {
    final currentState = PermissionHelper.columnState(values, action);

    onChanged(
      PermissionHelper.setColumn(
        values: values,
        action: action,
        enabled: currentState != true,
      ),
    );
  }

  // تحديد صف واحد فقط
  void _toggleRow(int index) {
    final currentState = PermissionHelper.rowState(values[index]);

    onChanged(
      PermissionHelper.setRow(
        values: values,
        index: index,
        enabled: currentState != true,
      ),
    );
  }

  // تحديد صلاحية واحدة
  void _toggleCell(int index, String action, bool enabled) {
    onChanged(
      PermissionHelper.setCell(
        values: values,
        index: index,
        action: action,
        enabled: enabled,
      ),
    );
  }

  Widget _headerCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  // Checkbox أعلى العمود
  Widget _columnHeader(String action, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _headerCell(label),
        PermissionCheckbox(
          tristate: true,
          value: PermissionHelper.columnState(values, action),
          onChanged: (_) => _toggleColumn(action),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
          },
          children: [
            // Header
            TableRow(
              decoration: const BoxDecoration(color: ColorManger.tableHeader),
              children: [
                _headerCell('الشاشة'),

                // Checkbox أعلى كل عمود
                for (final (action, label) in permissionActions)
                  _columnHeader(action, label),

                // عنوان فقط، بدون Checkbox عام
                _headerCell('الكل'),
              ],
            ),

            // Rows
            for (int index = 0; index < values.length; index++)
              TableRow(
                children: [
                  // اسم الشاشة
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    child: Text(
                      values[index].label,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // صلاحيات الشاشة
                  for (final (action, _) in permissionActions)
                    Center(
                      child: PermissionCheckbox(
                        value: values[index].valueFor(action),
                        onChanged: (checked) =>
                            _toggleCell(index, action, checked ?? false),
                      ),
                    ),

                  // Checkbox الكل للصف الحالي فقط
                  Center(
                    child: PermissionCheckbox(
                      value: PermissionHelper.rowState(values[index]) == true,
                      onChanged: (_) => _toggleRow(index),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}