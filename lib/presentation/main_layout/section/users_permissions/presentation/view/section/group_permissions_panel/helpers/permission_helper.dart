
import '../models/screen_permission.dart';

class PermissionHelper {
  static bool? columnState(
      List<ScreenPermission> values,
      String action,
      ) {
    final all = values.every(
          (row) => row.valueFor(action),
    );

    if (all) return true;

    final none = values.every(
          (row) => !row.valueFor(action),
    );

    return none ? false : null;
  }

  // حالة الصف
  static bool? rowState(ScreenPermission row) {
    final all = permissionActions.every(
          (action) => row.valueFor(action.$1),
    );

    if (all) return true;

    final none = permissionActions.every(
          (action) => !row.valueFor(action.$1),
    );

    return none ? false : null;
  }

  static bool? allState(List<ScreenPermission> values) {
    final all = values.every(
          (row) => permissionActions.every(
            (action) => row.valueFor(action.$1),
      ),
    );

    if (all) return true;

    final none = values.every(
          (row) => permissionActions.every(
            (action) => !row.valueFor(action.$1),
      ),
    );

    return none ? false : null;
  }

  static List<ScreenPermission> setCell({
    required List<ScreenPermission> values,
    required int index,
    required String action,
    required bool enabled,
  }) {
    final result = List<ScreenPermission>.from(values);
    final row = result[index];

    switch (action) {
      case 'can_view':
        result[index] = row.copyWith(
          canView: enabled,
          canAdd: enabled ? row.canAdd : false,
          canEdit: enabled ? row.canEdit : false,
          canDelete: enabled ? row.canDelete : false,
        );
        break;

      case 'can_add':
        result[index] = row.copyWith(
          canView: true,
          canAdd: enabled,
        );
        break;

      case 'can_edit':
        result[index] = row.copyWith(
          canView: true,
          canEdit: enabled,
        );
        break;

      case 'can_delete':
        result[index] = row.copyWith(
          canView: true,
          canDelete: enabled,
        );
        break;
    }

    return result;
  }

  // تحديد عمود بالكامل
  static List<ScreenPermission> setColumn({
    required List<ScreenPermission> values,
    required String action,
    required bool enabled,
  }) {
    return values.map((row) {
      switch (action) {
        case 'can_view':
          return row.copyWith(
            canView: enabled,
            canAdd: enabled ? row.canAdd : false,
            canEdit: enabled ? row.canEdit : false,
            canDelete: enabled ? row.canDelete : false,
          );

        case 'can_add':
          return row.copyWith(
            canView: enabled ? true : row.canView,
            canAdd: enabled,
          );

        case 'can_edit':
          return row.copyWith(
            canView: enabled ? true : row.canView,
            canEdit: enabled,
          );

        case 'can_delete':
          return row.copyWith(
            canView: enabled ? true : row.canView,
            canDelete: enabled,
          );

        default:
          return row;
      }
    }).toList();
  }

  // تحديد صف بالكامل
  static List<ScreenPermission> setRow({
    required List<ScreenPermission> values,
    required int index,
    required bool enabled,
  }) {
    final result = List<ScreenPermission>.from(values);

    result[index] = result[index].copyWith(
      canView: enabled,
      canAdd: enabled,
      canEdit: enabled,
      canDelete: enabled,
    );

    return result;
  }

  static List<ScreenPermission> setAll({
    required List<ScreenPermission> values,
    required bool enabled,
  }) {
    return values.map((row) {
      return row.copyWith(
        canView: enabled,
        canAdd: enabled,
        canEdit: enabled,
        canDelete: enabled,
      );
    }).toList();
  }
}
