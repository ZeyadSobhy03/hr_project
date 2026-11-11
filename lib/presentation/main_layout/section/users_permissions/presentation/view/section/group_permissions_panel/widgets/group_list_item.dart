
import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

class GroupListItem extends StatelessWidget {
  const GroupListItem({
    super.key,
    required this.group,
    required this.isSaving,
    required this.onEdit,
    required this.onDelete,
  });

  final Map<String, dynamic> group;
  final bool isSaving;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isAdmin = group['is_admin'] == true;

    return ListTile(
      contentPadding: EdgeInsets.zero,

      title: Text(
        group['name'] as String? ?? '',
      ),

      subtitle: isAdmin
          ? const Text('كل الصلاحيات')
          : null,

      trailing: isAdmin
          ? null
          : Wrap(
        spacing: 4,
        children: [
          IconButton(
            tooltip: 'تعديل الصلاحيات',
            onPressed: isSaving ? null : onEdit,
            icon: const Icon(
              Icons.edit_outlined,
            ),
          ),

          IconButton(
            tooltip: 'حذف المجموعة',
            onPressed: isSaving ? null : onDelete,
            icon: const Icon(
              Icons.delete_outline,
            ),
            color: ColorManger.error,
          ),
        ],
      ),
    );
  }
}
