import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/app_user.dart';
import '../../domain/use_case/users_permissions_use_case.dart';

@injectable
class UsersPermissionsCubit extends Cubit<UsersPermissionsState> {
  UsersPermissionsCubit(this._useCase) : super(const UsersPermissionsState());

  final UsersPermissionsUseCase _useCase;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearNotice: true));
    try {
      final results = await Future.wait([
        _useCase.getUsers(),
        _useCase.getGroups(),
        _useCase.isAdmin(),
      ]);
      if (isClosed) return;
      emit(
        state.copyWith(
          users: results[0] as List<AppUser>,
          groups: results[1] as List<Map<String, dynamic>>,
          canManageGroups: results[2] as bool,
          isLoading: false,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(isLoading: false, notice: _message(e), isError: true),
      );
    }
  }

  Future<void> createUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String groupId,
  }) => _run(() async {
    await _useCase.createUser(
      fullName: fullName,
      username: username,
      email: email,
      password: password,
      groupId: groupId,
    );
  }, 'تم إنشاء المستخدم بنجاح');

  Future<void> updateUser({
    required String id,
    required String fullName,
    required String username,
    required String groupId,
  }) => _run(
    () => _useCase.updateUser(
      id: id,
      fullName: fullName,
      username: username,
      groupId: groupId,
    ),
    'تم تعديل المستخدم بنجاح',
  );

  Future<void> setPassword({required String id, required String password}) =>
      _run(
        () => _useCase.setPassword(id: id, password: password),
        'تم تغيير كلمة المرور بنجاح',
      );

  Future<void> deleteUser(String id) =>
      _run(() => _useCase.deleteUser(id), 'تم حذف المستخدم بنجاح');

  Future<List<Map<String, dynamic>>> getGroupPermissions(String groupId) async {
    try {
      return await _useCase.getGroupPermissions(groupId);
    } catch (e) {
      emit(state.copyWith(notice: _message(e), isError: true));
      rethrow;
    }
  }

  Future<void> saveGroup({
    String? groupId,
    required String name,
    required List<Map<String, dynamic>> permissions,
  }) => _run(
    () => _useCase.saveGroup(
      groupId: groupId,
      name: name,
      permissions: permissions,
    ),
    groupId == null ? 'تم إنشاء المجموعة بنجاح' : 'تم تعديل المجموعة بنجاح',
  );

  Future<void> deleteGroup(String groupId) =>
      _run(() => _useCase.deleteGroup(groupId), 'تم حذف المجموعة بنجاح');

  Future<void> _run(Future<void> Function() action, String success) async {
    if (state.isSaving) return;
    emit(state.copyWith(isSaving: true, clearNotice: true));
    try {
      await action();
      await _reload();
      if (isClosed) return;
      emit(state.copyWith(isSaving: false, notice: success, isError: false));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isSaving: false, notice: _message(e), isError: true));
    }
  }

  Future<void> _reload() async {
    final users = await _useCase.getUsers();
    final groups = await _useCase.getGroups();
    if (!isClosed) emit(state.copyWith(users: users, groups: groups));
  }

  String _message(Object error) {
    if (error is PostgrestException) {
      if (error.code == '42501') return 'ليس لديك صلاحية لتنفيذ العملية';
      if (error.message.contains('user_groups_name_uidx')) {
        return 'اسم المجموعة مستخدم من قبل';
      }
      if (error.code == '23505') return 'اسم المستخدم أو البريد مستخدم من قبل';
      if (error.code == '23503') {
        return 'لا يمكن حذف المجموعة لأنها مرتبطة بمستخدمين';
      }
      return error.message;
    }
    if (error is FormatException) return error.message;
    final text = error.toString();
    if (text.contains('ليس لديك صلاحية') || text.contains('لا يمكنك')) {
      return text.replaceFirst('Exception: ', '');
    }
    if (text.contains('FunctionException')) {
      return 'تعذر تنفيذ العملية على المستخدم. تحقق من صلاحياتك واتصالك.';
    }
    return text.replaceFirst('Exception: ', '');
  }
}

class UsersPermissionsState {
  const UsersPermissionsState({
    this.users = const [],
    this.groups = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.canManageGroups = false,
    this.notice,
    this.isError = false,
  });

  final List<AppUser> users;
  final List<Map<String, dynamic>> groups;
  final bool isLoading;
  final bool isSaving;
  final bool canManageGroups;
  final String? notice;
  final bool isError;

  List<String> get groupNames =>
      groups.map((group) => group['name'] as String? ?? '').toList();

  String? groupIdForName(String name) {
    for (final group in groups) {
      if (group['name'] == name) return group['id'] as String?;
    }
    return null;
  }

  String? groupNameForId(String? id) {
    for (final group in groups) {
      if (group['id'] == id) return group['name'] as String?;
    }
    return null;
  }

  UsersPermissionsState copyWith({
    List<AppUser>? users,
    List<Map<String, dynamic>>? groups,
    bool? isLoading,
    bool? isSaving,
    bool? canManageGroups,
    String? notice,
    bool? isError,
    bool clearNotice = false,
  }) => UsersPermissionsState(
    users: users ?? this.users,
    groups: groups ?? this.groups,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    canManageGroups: canManageGroups ?? this.canManageGroups,
    notice: clearNotice ? null : (notice ?? this.notice),
    isError: clearNotice ? false : (isError ?? this.isError),
  );
}
