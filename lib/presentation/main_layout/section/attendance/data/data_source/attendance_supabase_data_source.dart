import 'package:flutter/cupertino.dart';
import 'package:hr_project/core/errors/app_exception.dart';
import 'package:hr_project/core/utils/app_format.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/data_source/attendance_remote_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/attendance_models.dart';
import '../model/attendance_record.dart';
@LazySingleton(as: AttendanceRemoteDataSource)
class AttendanceSupabaseDataSource implements AttendanceRemoteDataSource {


  final SupabaseClient _client = Supabase.instance.client;

  static const _view = 'attendance_details';
  static const _table = 'attendance';
  static const _exportPage = 1000;
  static const _importChunk = 50;

  PostgrestFilterBuilder<PostgrestList> _filtered({
    String? search,
    String? departmentId,
    DateTime? from,
    DateTime? to,
  }) {
    if (from != null && to != null && from.isAfter(to)) {
      throw const AppException('من فضلك ادخل تاريخ صحيح');
    }

    var q = _client.from(_view).select();

    if (departmentId != null) q = q.eq('department_id', departmentId);
    if (from != null) q = q.gte('work_date', AppFormat.dateToDb(from));
    if (to != null) q = q.lte('work_date', AppFormat.dateToDb(to));

    final term = (search ?? '').replaceAll(RegExp(r'[,()%*\\]'), '').trim();
    if (term.isNotEmpty) {
      q = q.or('employee_name.ilike.%$term%,department_name.ilike.%$term%');
    }
    return q;
  }


  @override
  Future<PagedAttendance> getAttendance({
    String? search,
    String? departmentId,
    DateTime? from,
    DateTime? to,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final start = page * pageSize;
      final res = await _filtered(
        search: search,
        departmentId: departmentId,
        from: from,
        to: to,
      )
          .order('work_date', ascending: false)
          .order('employee_name')
          .range(start, start + pageSize - 1)
          .count(CountOption.exact);
      debugPrint('getAttendance: ${res.data}');

      return PagedAttendance(
        items: res.data.map<AttendanceRecord>(AttendanceRecord.fromJson).toList(),
        total: res.count,
      );
    } catch (e) {
      throw _map(e);
    }
  }
  @override
  Future<PagedDaily> getDailyAttendance({
    required DateTime date,
    String? search,
    String? departmentId,
    int page = 0,
    String? status,
    int pageSize = 20,
  }) async {
    try {
      final term = (search ?? '').replaceAll(RegExp(r'[,()%*\\]'), '').trim();
      final rows = await _client.rpc('get_daily_attendance', params: {
        'p_date': AppFormat.dateToDb(date),
        'p_search': term.isEmpty ? null : term,
        'p_department_id': departmentId,
        'p_status': status,
        'p_limit': pageSize,
        'p_offset': page * pageSize,
      }) as List<dynamic>;

      final list = rows.cast<Map<String, dynamic>>();
      return PagedDaily(
        items: list.map(DailyAttendanceRow.fromJson).toList(),
        total: list.isEmpty ? 0 : (list.first['total_count'] as num).toInt(),
      );
    } catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<List<AttendanceRecord>> getAllForExport({
    String? search,
    String? departmentId,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final all = <AttendanceRecord>[];
      var start = 0;
      while (true) {
        final rows = await _filtered(
          search: search,
          departmentId: departmentId,
          from: from,
          to: to,
        )
            .order('work_date', ascending: false)
            .order('employee_name')
            .range(start, start + _exportPage - 1);

        all.addAll(rows.map<AttendanceRecord>(AttendanceRecord.fromJson));
        if (rows.length < _exportPage) break;
        start += _exportPage;
      }
      return all;
    } catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<List<EmployeeOption>> getEmployeeOptions() async {
    try {
      final rows = await _client
          .from('employees_lookup')
          .select('id, full_name, department_name')
          .order('full_name');
      return rows.map<EmployeeOption>(EmployeeOption.fromJson).toList();
    } catch (e) {
      throw _map(e);
    }
  }
  @override
  Future<int> markAllPresent(DateTime date, List<DailyAttendanceRow> rows) async {
    try {
      final today = DateTime.now();
      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;

      final payload = rows
          .where((r) => r.status == DayStatus.absent)
          .map((r) => AttendanceInput(
        employeeId: r.employeeId,
        date: date,
        checkIn: r.scheduledIn,
        checkOut: isToday ? null : r.scheduledOut,
      ).toJson())
          .toList();

      if (payload.isEmpty) return 0;
      await _client.from(_table).insert(payload);
      return payload.length;
    } catch (e) {
      throw _map(e);
    }
  }
  @override
  Future<void> addAttendance(AttendanceInput input) async {
    try {
      await _client.from(_table).insert(input.toJson());
    } catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<void> updateAttendance(String id, AttendanceInput input) async {
    try {
      final updated = await _client
          .from(_table)
          .update(input.toJson())
          .eq('id', id)
          .select('id');
      if (updated.isEmpty) {
        throw const AppException('تعذر التعديل: السجل غير موجود أو ليس لديك صلاحية');
      }
    } catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<void> deleteAttendance(String id) async {
    try {
      final deleted =
      await _client.from(_table).delete().eq('id', id).select('id');
      if (deleted.isEmpty) {
        throw const AppException('تعذر الحذف: السجل غير موجود أو ليس لديك صلاحية');
      }
    } catch (e) {
      throw _map(e);
    }
  }

  @override
  @override
  Future<ImportResult> importAttendance(List<ImportRow> rows) async {
    try {
      final options = await getEmployeeOptions();
      final byName = <String, List<EmployeeOption>>{};
      for (final o in options) {
        byName.putIfAbsent(_norm(o.name), () => []).add(o);
      }

      final errors = <ImportError>[];
      final present = <_Prepared>[];
      final absentByDate = <String, List<_PreparedAbsence>>{};
      final seen = <String>{};

      for (final r in rows) {
        final matches = byName[_norm(r.employeeName)];
        if (matches == null) {
          errors.add(ImportError(r.rowNumber, 'الموظف غير موجود: ${r.employeeName}'));
          continue;
        }
        if (matches.length > 1) {
          errors.add(ImportError(
              r.rowNumber, 'الاسم مكرر لأكثر من موظف: ${r.employeeName}'));
          continue;
        }

        final emp = matches.first;
        final dateDb = AppFormat.dateToDb(r.date);
        if (!seen.add('${emp.id}|$dateDb')) {
          errors.add(ImportError(r.rowNumber,
              'الموظف مكرر في نفس اليوم داخل الملف: ${r.employeeName}'));
          continue;
        }

        if (r.status == ImportStatus.absent) {
          absentByDate
              .putIfAbsent(dateDb, () => [])
              .add(_PreparedAbsence(r.rowNumber, emp.id));
          continue;
        }

        final checkIn = r.checkIn;
        if (checkIn == null) {
          errors.add(ImportError(r.rowNumber, 'وقت الحضور مطلوب: ${r.employeeName}'));
          continue;
        }
        present.add(_Prepared(
          r.rowNumber,
          AttendanceInput(
            employeeId: emp.id,
            date: r.date,
            checkIn: checkIn,
            checkOut: r.checkOut,
          ).toJson(),
        ));
      }

      var deleted = 0;
      for (final entry in absentByDate.entries) {
        final list = entry.value;
        for (var i = 0; i < list.length; i += _importChunk) {
          final chunk = list.sublist(i, (i + _importChunk).clamp(0, list.length));
          try {
            final res = await _client
                .from(_table)
                .delete()
                .eq('work_date', entry.key)
                .inFilter('employee_id', chunk.map((a) => a.employeeId).toList())
                .select('id');
            deleted += res.length;
          } catch (e) {
            final msg = _map(e).message;
            for (final a in chunk) {
              errors.add(ImportError(a.rowNumber, msg));
            }
          }
        }
      }

      var inserted = 0;
      for (var i = 0; i < present.length; i += _importChunk) {
        final end = (i + _importChunk).clamp(0, present.length);
        final chunk = present.sublist(i, end);
        try {
          await _client.from(_table).insert(chunk.map((p) => p.json).toList());
          inserted += chunk.length;
        } catch (_) {
          for (final p in chunk) {
            try {
              await _client.from(_table).insert(p.json);
              inserted++;
            } catch (e) {
              errors.add(ImportError(p.rowNumber, _map(e).message));
            }
          }
        }
      }

      errors.sort((a, b) => a.rowNumber.compareTo(b.rowNumber));
      return ImportResult(inserted: inserted, deleted: deleted, errors: errors);
    } catch (e) {
      throw _map(e);
    }
  }
  String _norm(String s) => s
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .toLowerCase();

  AppException _map(Object e) {
    if (e is AppException) return e;

    if (e is PostgrestException) {
      final msg = '${e.message} ${e.details ?? ''}';
      switch (e.code) {
        case '23505':
          return const AppException('تم تسجيل حضور هذا الموظف في هذا اليوم من قبل');
        case '23514':
          if (msg.contains('attendance_times_valid')) {
            return const AppException('وقت الانصراف يجب أن يكون بعد وقت الحضور');
          }
          return AppException(e.message); // رسائل الـ trigger: إجازة / تاريخ مستقبلي
        case '23503':
          return const AppException('الموظف غير موجود');
        case '23502':
          return const AppException('هذا الحقل مطلوب');
        case '22007':
        case '22008':
        case '22P02':
          return const AppException('من فضلك تأكد من صحة التاريخ والوقت');
        case '42501':
          return const AppException('ليس لديك صلاحية لتنفيذ هذه العملية');
      }
      return const AppException('حدث خطأ في الخادم، حاول مرة أخرى');
    }

    if (e is AuthException) {
      return const AppException('انتهت الجلسة، سجّل الدخول مرة أخرى');
    }
    return const AppException('تعذر الاتصال بالخادم، تأكد من الإنترنت');
  }
}

class _Prepared {
  const _Prepared(this.rowNumber, this.json);
  final int rowNumber;
  final Map<String, dynamic> json;
}
class _PreparedAbsence {
  const _PreparedAbsence(this.rowNumber, this.employeeId);
  final int rowNumber;
  final String employeeId;
}