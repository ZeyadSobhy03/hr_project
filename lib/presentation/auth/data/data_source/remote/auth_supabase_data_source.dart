import 'package:hr_project/presentation/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthSupabaseDataSource implements AuthRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.session == null || response.user == null) {
        throw const AuthException('فشل تسجيل الدخول، حاول مرة أخرى');
      }
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('حدث خطأ غير متوقع، تحقق من الاتصال بالإنترنت');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('تعذر تسجيل الخروج، حاول مرة أخرى');
    }
  }
}