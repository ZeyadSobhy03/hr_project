import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/app_user.dart';
import 'users_permissions_remote_data_source.dart';

@LazySingleton(as: UsersPermissionsRemoteDataSource)
class UsersPermissionsSupabaseDataSource
    implements UsersPermissionsRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<AppUser>> getUsers() async {
    final rows = await _client
        .from('profiles')
        .select(
          'id,full_name,username,email,group_id,is_active,user_groups(name)',
        )
        .order('full_name');
    return rows.map((row) => AppUser.fromJson(row)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getGroups() async {
    final rows = await _client
        .from('user_groups')
        .select('id,name,is_admin')
        .order('name');
    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  @override
  Future<bool> isAdmin() async {
    final result = await _client.rpc('is_admin');
    return result == true;
  }

  @override
  Future<List<Map<String, dynamic>>> getGroupPermissions(String groupId) async {
    final rows = await _client
        .from('group_permissions')
        .select('screen,can_view,can_add,can_edit,can_delete')
        .eq('group_id', groupId);
    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  @override
  Future<void> saveGroup({
    String? groupId,
    required String name,
    required List<Map<String, dynamic>> permissions,
  }) async {
    await _requireAdmin();
    final cleanName = name.trim();
    if (cleanName.isEmpty) throw const FormatException('اكتب اسم المجموعة');
    if (permissions.isEmpty ||
        !permissions.any((row) => row['can_view'] == true)) {
      throw const FormatException('حدد صلاحية عرض واحدة على الأقل');
    }

    String id;
    if (groupId == null) {
      final created = await _client
          .from('user_groups')
          .insert({'name': cleanName, 'is_admin': false})
          .select('id')
          .single();
      id = created['id'] as String;
    } else {
      final current = await _client
          .from('user_groups')
          .select('is_admin')
          .eq('id', groupId)
          .single();
      if (current['is_admin'] == true) {
        throw const FormatException('لا يمكن تعديل مجموعة الأدمن');
      }
      final updated = await _client
          .from('user_groups')
          .update({'name': cleanName})
          .eq('id', groupId)
          .select('id');
      if (updated.isEmpty) {
        throw const FormatException(
          'المجموعة غير موجودة أو لا تملك صلاحية تعديلها',
        );
      }
      id = groupId;
    }

    final rows = permissions
        .map((permission) => {...permission, 'group_id': id})
        .toList();
    try {
      await _client
          .from('group_permissions')
          .upsert(rows, onConflict: 'group_id,screen');
    } catch (_) {
      if (groupId == null) {
        try {
          await _client.from('user_groups').delete().eq('id', id);
        } catch (_) {

        }
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await _requireAdmin();
    final group = await _client
        .from('user_groups')
        .select('is_admin')
        .eq('id', groupId)
        .single();
    if (group['is_admin'] == true) {
      throw const FormatException('لا يمكن حذف مجموعة الأدمن');
    }
    await _client.from('user_groups').delete().eq('id', groupId);
  }

  Future<void> _requireAdmin() async {
    if (!await isAdmin()) {
      throw const FormatException('إدارة المجموعات متاحة للأدمن فقط');
    }
  }

  @override
  Future<String> createUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String groupId,
  }) async {
    final response = await _invoke({
      'action': 'create',
      'full_name': fullName.trim(),
      'username': username.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      'group_id': groupId,
    });
    final data = response.data;
    if (data is Map && data['id'] is String) return data['id'] as String;
    if (data is Map && data['error'] is String) {
      throw Exception(data['error'] as String);
    }
    throw Exception('تعذر إنشاء المستخدم: استجابة غير متوقعة من الخادم');
  }

  @override
  Future<void> updateUser({
    required String id,
    String? fullName,
    String? username,
    String? groupId,
    bool? isActive,
  }) async {
    final values = <String, dynamic>{};
    if (fullName != null) values['full_name'] = fullName.trim();
    if (username != null) values['username'] = username.trim();
    if (groupId != null) values['group_id'] = groupId;
    if (isActive != null) values['is_active'] = isActive;
    if (values.isEmpty) return;

    final updated = await _client
        .from('profiles')
        .update(values)
        .eq('id', id)
        .select('id');
    if (updated.isEmpty) {
      throw const FormatException(
        'تعذر تعديل المستخدم: لا يوجد سجل مطابق أو لا تملك الصلاحية',
      );
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    await _invokeUserAction({'action': 'delete', 'user_id': id});
  }

  @override
  Future<void> setPassword({
    required String id,
    required String password,
  }) async {
    await _invokeUserAction({
      'action': 'set_password',
      'user_id': id,
      'password': password,
    });
  }

  Future<void> _invokeUserAction(Map<String, dynamic> body) async {
    final response = await _invoke(body);
    final data = response.data;
    if (data is Map && data['error'] is String) {
      throw Exception(data['error'] as String);
    }
  }

  Future<dynamic> _invoke(Map<String, dynamic> body) async {
    try {
      return await _client.functions.invoke('swift-action', body: body);
    } on FunctionException catch (error) {
      final details = error.details;
      if (details is Map && details['error'] is String) {
        throw Exception(details['error'] as String);
      }
      if (details is String && details.isNotEmpty) {
        throw Exception(details);
      }
      rethrow;
    }
  }
}
