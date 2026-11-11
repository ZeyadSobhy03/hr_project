
import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

import '../models/screen_permission.dart';
import '../widgets/permissions_matrix.dart';

Future<void> showGroupPermissionDialog({
  required BuildContext context,
  Map<String, dynamic>? group,
  required GroupPermissionsLoadCallback onLoadPermissions,
  required GroupPermissionsSaveCallback onSave,
  required bool isSaving,
}) async {
  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController(
    text: group == null ? '' : group['name'] as String? ?? '',
  );

  final groupId = group?['id'] as String?;

  // Initialize permissions
  List<ScreenPermission> values = [
    for (final (screen, label) in permissionScreens)
      ScreenPermission(
        screen: screen,
        label: label,
      ),
  ];

  // Load saved permissions when editing
  if (groupId != null) {
    try {
      final saved = await onLoadPermissions(groupId);

      final savedMap = {
        for (final row in saved)
          row['screen'] as String: row,
      };

      values = [
        for (final (screen, label) in permissionScreens)
          if (savedMap.containsKey(screen))
            ScreenPermission.fromMap(
              savedMap[screen]!,
              label: label,
            )
          else
            ScreenPermission(
              screen: screen,
              label: label,
            ),
      ];
    } catch (_) {
      nameCtrl.dispose();
      return;
    }
  }

  if (!context.mounted) {
    nameCtrl.dispose();
    return;
  }

  try {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: ColorManger.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),

              title: Text(
                groupId == null
                    ? 'إضافة مجموعة'
                    : 'تعديل المجموعة',
              ),

              content: SizedBox(
                width: 760,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'اسم المجموعة',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'اكتب اسم المجموعة';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'حدد الشاشات والعمليات المتاحة لأعضاء المجموعة',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      PermissionsMatrix(
                        values: values,
                        onChanged: (newValues) {
                          setDialogState(() {
                            values = newValues;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('إلغاء'),
                ),

                FilledButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    // Convert model to backend maps
                    final permissions = values
                        .map((permission) => permission.toMap())
                        .toList();

                    // At least one view permission is required
                    if (!values.any(
                          (permission) => permission.canView,
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'حدد صلاحية عرض واحدة على الأقل',
                          ),
                        ),
                      );
                      return;
                    }

                    await onSave(
                      groupId: groupId,
                      name: nameCtrl.text.trim(),
                      permissions: permissions,
                    );

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  } finally {
    nameCtrl.dispose();
  }
}
