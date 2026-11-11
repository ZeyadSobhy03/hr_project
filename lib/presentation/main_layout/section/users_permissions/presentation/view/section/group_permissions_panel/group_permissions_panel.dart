
import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

import 'models/screen_permission.dart';

import 'widgets/group_list.dart';

import 'dialogs/group_permission_dialog.dart';
import 'dialogs/delete_group_dialog.dart';

class GroupPermissionsPanel extends StatefulWidget {
  const GroupPermissionsPanel({
    super.key,
    required this.groups,
    required this.onLoadPermissions,
    required this.onSave,
    required this.onDelete,
    required this.isSaving,
  });

  final List<Map<String, dynamic>> groups;

  final GroupPermissionsLoadCallback onLoadPermissions;

  final GroupPermissionsSaveCallback onSave;

  final Future<void> Function(String groupId) onDelete;

  final bool isSaving;

  @override
  State<GroupPermissionsPanel> createState() =>
      _GroupPermissionsPanelState();
}

class _GroupPermissionsPanelState
    extends State<GroupPermissionsPanel> {

  Future<void> _openEditor({
    Map<String, dynamic>? group,
  }) async {
    await showGroupPermissionDialog(
      context: context,
      group: group,
      onLoadPermissions: widget.onLoadPermissions,
      onSave: widget.onSave,
      isSaving: widget.isSaving,
    );
  }

  // Confirm group deletion
  Future<void> _confirmDelete(
      Map<String, dynamic> group,
      ) async {
    final confirmed = await showDeleteGroupDialog(
      context: context,
      name: group['name'] as String? ?? '',
    );

    if (confirmed) {
      await widget.onDelete(
        group['id'] as String,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: ColorManger.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorManger.cardBorder,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'مجموعات المستخدمين والصلاحيات',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              FilledButton.icon(
                onPressed: widget.isSaving
                    ? null
                    : () => _openEditor(),

                icon: const Icon(Icons.add),

                label: const Text('إضافة مجموعة'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'صلاحيات مجموعة الأدمن ثابتة ولا يمكن تعديلها من هنا.',
          ),

          const SizedBox(height: 12),

          // Groups
          GroupList(
            groups: widget.groups,
            isSaving: widget.isSaving,

            onEdit: (group) {
              _openEditor(group: group);
            },

            onDelete: (group) {
              _confirmDelete(group);
            },
          ),
        ],
      ),
    );
  }
}
