
class ScreenPermission {
  final String screen;
  final String label;

  final bool canView;
  final bool canAdd;
  final bool canEdit;
  final bool canDelete;

  const ScreenPermission({
    required this.screen,
    required this.label,
    this.canView = false,
    this.canAdd = false,
    this.canEdit = false,
    this.canDelete = false,
  });

  ScreenPermission copyWith({
    bool? canView,
    bool? canAdd,
    bool? canEdit,
    bool? canDelete,
  }) {
    return ScreenPermission(
      screen: screen,
      label: label,
      canView: canView ?? this.canView,
      canAdd: canAdd ?? this.canAdd,
      canEdit: canEdit ?? this.canEdit,
      canDelete: canDelete ?? this.canDelete,
    );
  }

  bool valueFor(String action) {
    switch (action) {
      case 'can_view':
        return canView;
      case 'can_add':
        return canAdd;
      case 'can_edit':
        return canEdit;
      case 'can_delete':
        return canDelete;
      default:
        return false;
    }
  }

  factory ScreenPermission.fromMap(
      Map<String, dynamic> map, {
        required String label,
      }) {
    return ScreenPermission(
      screen: map['screen'] as String,
      label: label,
      canView: map['can_view'] == true,
      canAdd: map['can_add'] == true,
      canEdit: map['can_edit'] == true,
      canDelete: map['can_delete'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'screen': screen,
      'can_view': canView,
      'can_add': canAdd,
      'can_edit': canEdit,
      'can_delete': canDelete,
    };
  }
}

const List<(String, String)> permissionScreens = [
  ('employees', 'الموظفون'),
  ('attendance', 'الحضور والانصراف'),
  ('payroll', 'الرواتب'),
  ('settings', 'الإعدادات العامة'),
  ('holidays', 'الإجازات الرسمية'),
  ('users', 'المستخدمون'),
  ('groups', 'المجموعات'),
];

const List<(String, String)> permissionActions = [
  ('can_view', 'عرض'),
  ('can_add', 'إضافة'),
  ('can_edit', 'تعديل'),
  ('can_delete', 'حذف'),
];

// Callbacks
typedef GroupPermissionsLoadCallback =
Future<List<Map<String, dynamic>>> Function(String groupId);

typedef GroupPermissionsSaveCallback =
Future<void> Function({
String? groupId,
required String name,
required List<Map<String, dynamic>> permissions,
});
