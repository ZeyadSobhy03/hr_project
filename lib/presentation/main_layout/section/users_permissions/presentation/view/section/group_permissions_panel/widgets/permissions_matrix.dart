import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/presentation/main_layout/section/users_permissions/presentation/view/section/group_permissions_panel/widgets/permissions_mobile_view.dart';

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

  static const double _mobileBreakpoint = 600;

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _mobileBreakpoint) {
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: values.length,
            itemBuilder: (context, index) {
              final item = values[index];
              return PermissionsMobileView(
                item: item,
                toggleRow: (index) => _toggleRow(index),
                toggleCell: (index, action, enabled) =>
                    _toggleCell(index, action, enabled),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          );
        }
        return _tableView();
      },
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

  Widget _tableView() {
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
            TableRow(
              decoration: const BoxDecoration(color: ColorManger.tableHeader),
              children: [
                _headerCell('الشاشة'),
                for (final (action, label) in permissionActions)
                  _columnHeader(action, label),
                _headerCell('الكل'),
              ],
            ),

            for (int index = 0; index < values.length; index++)
              TableRow(
                children: [
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
                  for (final (action, _) in permissionActions)
                    Center(
                      child: PermissionCheckbox(
                        value: values[index].valueFor(action),
                        onChanged: (checked) =>
                            _toggleCell(index, action, checked ?? false),
                      ),
                    ),
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
