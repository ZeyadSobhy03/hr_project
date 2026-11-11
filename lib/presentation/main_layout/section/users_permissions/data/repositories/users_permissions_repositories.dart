import '../model/app_user.dart';

abstract class UsersPermissionsRepositories {
  Future<List<AppUser>> getUsers();

  Future<List<Map<String, dynamic>>> getGroups();

  Future<bool> isAdmin();

  Future<List<Map<String, dynamic>>> getGroupPermissions(String groupId);

  Future<void> saveGroup({
    String? groupId,
    required String name,
    required List<Map<String, dynamic>> permissions,
  });

  Future<void> deleteGroup(String groupId);

  Future<String> createUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String groupId,
  });

  Future<void> updateUser({
    required String id,
    String? fullName,
    String? username,
    String? groupId,
    bool? isActive,
  });

  Future<void> deleteUser(String id);

  Future<void> setPassword({required String id, required String password});
}
