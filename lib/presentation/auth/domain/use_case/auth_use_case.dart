import 'package:hr_project/presentation/auth/data/repositories/auth_repositories.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthUseCase {
  final AuthRepositories authRepositories;

  AuthUseCase({required this.authRepositories});

  Future<void> login({required String email, required String password}) {
    return authRepositories.login(email: email, password: password);
  }

  Future<void> logout() {
    return authRepositories.logout();
  }
}
