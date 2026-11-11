import 'package:hr_project/presentation/main_layout/section/users_permissions/data/repositories/users_permissions_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/app_user.dart';

@injectable
class UsersPermissionsUseCase {
  final UsersPermissionsRepositories usersPermissionsRepositories;
  UsersPermissionsUseCase({required this.usersPermissionsRepositories});
  Future<List<AppUser>> getUsers() {
    return usersPermissionsRepositories.getUsers();
  }

  Future<List<Map<String, dynamic>>> getGroups() {
    return usersPermissionsRepositories.getGroups();
  }

  Future<bool> isAdmin() => usersPermissionsRepositories.isAdmin();

  Future<List<Map<String, dynamic>>> getGroupPermissions(String groupId) =>
      usersPermissionsRepositories.getGroupPermissions(groupId);

  Future<void> saveGroup({
    String? groupId,
    required String name,
    required List<Map<String, dynamic>> permissions,
  }) => usersPermissionsRepositories.saveGroup(
    groupId: groupId,
    name: name,
    permissions: permissions,
  );

  Future<void> deleteGroup(String groupId) =>
      usersPermissionsRepositories.deleteGroup(groupId);

  Future<String> createUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String groupId,
  }) {
    return usersPermissionsRepositories.createUser(
      fullName: fullName,
      username: username,
      email: email,
      password: password,
      groupId: groupId,
    );
  }

  Future<void> updateUser({
    required String id,
    String? fullName,
    String? username,
    String? groupId,
    bool? isActive,
  }) {
    return usersPermissionsRepositories.updateUser(
      id: id,
      fullName: fullName,
      username: username,
      groupId: groupId,
      isActive: isActive,
    );
  }

  Future<void> deleteUser(String id) {
    return usersPermissionsRepositories.deleteUser(id);
  }

  Future<void> setPassword({required String id, required String password}) {
    return usersPermissionsRepositories.setPassword(id: id, password: password);
  }
}
