import 'package:hr_project/core/errors/app_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/general_settings.dart';
import 'general_settings_remote_data_source.dart';

@LazySingleton(as: GeneralSettingsRemoteDataSource)
class GeneralSettingsSupabaseDataSource
    implements GeneralSettingsRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  static const _columns = 'weekly_off_days,salary_days_basis';

  @override
  Future<GeneralSettingsData> getSettings() async {
    try {
      final row = await _client
          .from('settings')
          .select(_columns)
          .eq('id', 1)
          .maybeSingle();
      if (row == null) {
        throw const AppException(
          'إعدادات النظام غير مهيأة. شغّل ملف الـ seed (04_seed.sql) أولًا.',
        );
      }
      return GeneralSettingsData.fromJson(row);
    } catch (error) {
      throw _map(error);
    }
  }

  @override
  Future<GeneralSettingsData> updateSettings(
      GeneralSettingsData settings,
      ) async {
    try {
      final rows = await _client
          .from('settings')
          .update(settings.toJson())
          .eq('id', 1)
          .select(_columns);
      if (rows.isEmpty) {
        throw const AppException(
          'تعذر حفظ الإعدادات. تأكد من صلاحيتك ووجود سجل الإعدادات.',
        );
      }
      return GeneralSettingsData.fromJson(rows.first);
    } catch (error) {
      throw _map(error);
    }
  }

  AppException _map(Object error) {
    if (error is AppException) return error;
    if (error is PostgrestException) {
      if (error.code == '42501') {
        return const AppException('ليس لديك صلاحية عرض أو تعديل الإعدادات');
      }
      if (error.code == '23514') {
        return const AppException(
          'تأكد من صحة أيام الإجازة (من 1 إلى 3 أيام) وأيام الراتب (من 20 إلى 31)',
        );
      }
      return const AppException('حدث خطأ في الخادم، حاول مرة أخرى');
    }
    if (error is AuthException) {
      return const AppException('انتهت الجلسة، سجّل الدخول مرة أخرى');
    }
    return const AppException('تعذر الاتصال بالخادم، تأكد من الإنترنت');
  }
}