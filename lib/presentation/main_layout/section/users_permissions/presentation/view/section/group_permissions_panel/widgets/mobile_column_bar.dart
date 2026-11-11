import 'package:flutter/material.dart';

import '../../../../../../../../../core/resources/colors/color_manger.dart';
import '../helpers/permission_helper.dart';
import '../models/screen_permission.dart';

class MobileColumnBar extends StatelessWidget {
  const MobileColumnBar({super.key, required this.values, required this.toggleColumn});
  final List<ScreenPermission> values;
  final void Function(String action) toggleColumn;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManger.tableHeader,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تحديد لكل الشاشات',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: ColorManger.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (action, label) in permissionActions)
                FilterChip(
                  label: Text(label, style: const TextStyle(fontSize: 12)),
                  selected:
                  PermissionHelper.columnState(values, action) == true,
                  showCheckmark: true,
                  backgroundColor: ColorManger.white,
                  selectedColor: ColorManger.primary.withValues(alpha: 0.15),
                  checkmarkColor: ColorManger.primary,
                  side: const BorderSide(color: ColorManger.rowDivider),
                  onSelected: (_) => toggleColumn(action),
                ),
            ],
          ),
        ],
      ),
    );

  }
}
