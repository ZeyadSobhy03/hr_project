import 'package:hr_project/core/errors/app_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/holiday.dart';
import 'official_holidays_remote_data_source.dart';

@LazySingleton(as: OfficialHolidaysRemoteDataSource)
class OfficialHolidaysSupabaseDataSource
    implements OfficialHolidaysRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;
  static const _table = 'official_holidays';

  @override
  Future<List<Holiday>> getHolidays() async {
    try {
      final rows = await _client
          .from(_table)
          .select('id,name,holiday_date')
          .order('holiday_date');
      return rows.map((row) => Holiday.fromJson(row)).toList();
    } catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<void> addHoliday(Holiday holiday) async {
    try {
      await _client.from(_table).insert(holiday.toJson());
    } catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<void> updateHoliday(Holiday holiday) async {
    try {
      final updated = await _client
          .from(_table)
          .update(holiday.toJson())
          .eq('id', holiday.id)
          .select('id');
      if (updated.isEmpty) {
        throw const AppException(
          'تعذر تعديل الإجازة: السجل غير موجود أو لا تملك الصلاحية',
        );
      }
    } catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<void> deleteHoliday(String id) async {
    try {
      final deleted = await _client
          .from(_table)
          .delete()
          .eq('id', id)
          .select('id');
      if (deleted.isEmpty) {
        throw const AppException(
          'تعذر حذف الإجازة: السجل غير موجود أو لا تملك الصلاحية',
        );
      }
    } catch (e) {
      throw _map(e);
    }
  }

  AppException _map(Object error) {
    if (error is AppException) return error;
    if (error is PostgrestException) {
      switch (error.code) {
        case '23505':
          return const AppException('يوجد إجازة مسجلة في هذا التاريخ بالفعل');
        case '23514':
          return const AppException(
            'تاريخ الإجازة يجب أن يكون من سنة 2008 أو بعدها',
          );
        case '23502':
          return const AppException('اسم الإجازة وتاريخها مطلوبان');
        case '42501':
          return const AppException('ليس لديك صلاحية لتنفيذ العملية');
      }
      return AppException(error.message);
    }
    if (error is AuthException) {
      return const AppException('انتهت الجلسة، سجّل الدخول مرة أخرى');
    }
    return const AppException('تعذر الاتصال بالخادم، تأكد من الإنترنت');
  }
}
