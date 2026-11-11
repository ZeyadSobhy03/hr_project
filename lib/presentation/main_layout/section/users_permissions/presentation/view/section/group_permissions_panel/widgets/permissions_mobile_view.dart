import 'package:flutter/material.dart';
import 'package:hr_project/presentation/main_layout/section/users_permissions/presentation/view/section/group_permissions_panel/widgets/permission_checkbox.dart';

import '../../../../../../../../../core/resources/colors/color_manger.dart';
import '../helpers/permission_helper.dart';
import '../models/screen_permission.dart';

class PermissionsMobileView extends StatelessWidget {
  const PermissionsMobileView({
    super.key,
    required this.item,
    required this.toggleRow,
    required this.toggleCell,
  });

  final ScreenPermission item;

  final void Function(int index) toggleRow;

  final void Function(int index, String action, bool enabled) toggleCell;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManger.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorManger.rowDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorManger.textPrimary,
                  ),
                ),
              ),
              const Text('الكل', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              PermissionCheckbox(
                value: PermissionHelper.rowState(item) == true,
                onChanged: (_) => toggleRow,
              ),
            ],
          ),
          const Divider(height: 16, color: ColorManger.rowDivider),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (action, label) in permissionActions)
                FilterChip(
                  label: Text(label, style: const TextStyle(fontSize: 12)),
                  selected: item.valueFor(action),
                  showCheckmark: true,
                  backgroundColor: ColorManger.white,
                  selectedColor: ColorManger.primary.withValues(alpha: 0.15),
                  checkmarkColor: ColorManger.primary,
                  side: const BorderSide(color: ColorManger.rowDivider),
                  onSelected: (checked) => toggleCell,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
