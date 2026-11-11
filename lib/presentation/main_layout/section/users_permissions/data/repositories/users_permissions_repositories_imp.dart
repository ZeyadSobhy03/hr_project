import 'package:injectable/injectable.dart';

import '../data_source/users_permissions_remote_data_source.dart';
import '../model/app_user.dart';
import 'users_permissions_repositories.dart';

@LazySingleton(as: UsersPermissionsRepositories)
class UsersPermissionsRepositoriesImp implements UsersPermissionsRepositories {
  UsersPermissionsRepositoriesImp({
    required this.usersPermissionsRemoteDataSource,
  });

  final UsersPermissionsRemoteDataSource usersPermissionsRemoteDataSource;

  @override
  Future<List<AppUser>> getUsers() =>
      usersPermissionsRemoteDataSource.getUsers();

  @override
  Future<List<Map<String, dynamic>>> getGroups() =>
      usersPermissionsRemoteDataSource.getGroups();

  @override
  Future<bool> isAdmin() => usersPermissionsRemoteDataSource.isAdmin();

  @override
  Future<List<Map<String, dynamic>>> getGroupPermissions(String groupId) =>
      usersPermissionsRemoteDataSource.getGroupPermissions(groupId);

  @override
  Future<void> saveGroup({
    String? groupId,
    required String name,
    required List<Map<String, dynamic>> permissions,
  }) => usersPermissionsRemoteDataSource.saveGroup(
    groupId: groupId,
    name: name,
    permissions: permissions,
  );

  @override
  Future<void> deleteGroup(String groupId) =>
      usersPermissionsRemoteDataSource.deleteGroup(groupId);

  @override
  Future<String> createUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String groupId,
  }) => usersPermissionsRemoteDataSource.createUser(
    fullName: fullName,
    username: username,
    email: email,
    password: password,
    groupId: groupId,
  );

  @override
  Future<void> updateUser({
    required String id,
    String? fullName,
    String? username,
    String? groupId,
    bool? isActive,
  }) => usersPermissionsRemoteDataSource.updateUser(
    id: id,
    fullName: fullName,
    username: username,
    groupId: groupId,
    isActive: isActive,
  );

  @override
  Future<void> deleteUser(String id) =>
      usersPermissionsRemoteDataSource.deleteUser(id);

  @override
  Future<void> setPassword({required String id, required String password}) =>
      usersPermissionsRemoteDataSource.setPassword(id: id, password: password);
}
