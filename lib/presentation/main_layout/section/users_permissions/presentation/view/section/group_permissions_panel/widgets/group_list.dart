
import 'package:flutter/material.dart';

import 'group_list_item.dart';

class GroupList extends StatelessWidget {
  const GroupList({
    super.key,
    required this.groups,
    required this.isSaving,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Map<String, dynamic>> groups;
  final bool isSaving;

  final ValueChanged<Map<String, dynamic>> onEdit;
  final ValueChanged<Map<String, dynamic>> onDelete;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const Text('لا توجد مجموعات مسجلة');
    }

    return Column(
      children: [
        for (final group in groups)
          GroupListItem(
            group: group,
            isSaving: isSaving,
            onEdit: () => onEdit(group),
            onDelete: () => onDelete(group),
          ),
      ],
    );
  }
}
