import 'package:hr_project/presentation/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:hr_project/presentation/auth/data/repositories/auth_repositories.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepositories)
class AuthRepositoriesImp implements AuthRepositories {

  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoriesImp({required this.authRemoteDataSource});

  @override
  Future<void> login({required String email, required String password}) {
    return authRemoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return authRemoteDataSource.logout();
  }


}