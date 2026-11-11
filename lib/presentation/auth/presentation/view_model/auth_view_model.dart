import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/presentation/auth/domain/use_case/auth_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authUseCase) : super(const AuthInitial());

  final AuthUseCase _authUseCase;

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await _authUseCase.login(email: email, password: password);
      if (isClosed) return;
      emit(const AuthLoginSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(AuthFailure(_errorMessage(e)));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await _authUseCase.logout();
      if (isClosed) return;
      emit(const AuthLogoutSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(AuthFailure(_errorMessage(e)));
    }
  }

  String _errorMessage(Object error) {
    if (error is AuthException) {
      if (error.message.toLowerCase().contains('invalid login credentials')) {
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      }
      return error.message;
    }
    return 'حدث خطأ غير متوقع، حاول مرة أخرى';
  }
}

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess();
}

final class AuthLogoutSuccess extends AuthState {
  const AuthLogoutSuccess();
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.message);

  final String message;
}
