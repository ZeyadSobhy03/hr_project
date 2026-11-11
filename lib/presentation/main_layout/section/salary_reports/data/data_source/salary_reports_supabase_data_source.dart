import 'package:hr_project/core/errors/app_exception.dart';
import 'package:hr_project/core/errors/permission_denied_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/salary_record.dart';
import 'salary_reports_remote_data_source.dart';

@LazySingleton(as: SalaryReportsRemoteDataSource)
class SalaryReportsSupabaseDataSource implements SalaryReportsRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<SalaryReportPage> getPayroll({
    required int year,
    required int month,
    String? search,
    int page = 0,
    int pageSize = 50,
  }) async {
    try {
      final term = (search ?? '').replaceAll(RegExp(r'[,()%*\\]'), '').trim();
      final rows = await _client.rpc(
        'get_payroll',
        params: {
          'p_year': year,
          'p_month': month,
          'p_search': term.isEmpty ? null : term,
          'p_employee_id': null,
          'p_limit': pageSize,
          'p_offset': page * pageSize,
        },
      ) as List<dynamic>;

      final items = rows
          .cast<Map<String, dynamic>>()
          .map(SalaryRecord.fromJson)
          .toList();
      final total = rows.isEmpty
          ? 0
          : (rows.first['total_count'] as num?)?.toInt() ?? 0;
      return SalaryReportPage(items: items, total: total);
    } catch (error) {
      throw _map(error);
    }
  }

  AppException _map(Object error) {
    if (error is AppException) return error;
    if (error is PostgrestException) {
      if (error.code == '42501') {
        return const PermissionDeniedException(
          'ليس لديك صلاحية عرض تقرير الرواتب',
        );
      }
      if (error.code == '22023') {
        return const AppException('من فضلك اختر شهرًا وسنة صحيحين');
      }
      return AppException(error.message);
    }
    if (error is AuthException) {
      return const AppException('انتهت الجلسة، سجّل الدخول مرة أخرى');
    }
    return const AppException('تعذر الاتصال بالخادم، تأكد من الإنترنت');
  }
}