
import 'package:flutter/foundation.dart';
import 'package:hr_project/core/errors/app_exception.dart';
import 'package:hr_project/core/errors/map_error.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/data_source/employees_remote_data_source.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/model/department.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/model/employee.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: EmployeesRemoteDataSource)
class EmployeesSupabaseDataSource implements EmployeesRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const _select =
      'id, full_name, address, phone, gender, nationality, birth_date, '
      'national_id, hire_date, check_in_time, check_out_time, department_id, '
      'departments(id, name)';

  @override
  Future<PagedEmployees> getEmployees({
    String? search,
    String? departmentId,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      var query = _supabase.from('employees').select(_select);

      if (departmentId != null) {
        query = query.eq('department_id', departmentId);
      }

      final term = (search ?? '').replaceAll(RegExp(r'[,()%*\\]'), '').trim();
      if (term.isNotEmpty) {
        query = query.or(
          'full_name.ilike.%$term%,national_id.ilike.%$term%,phone.ilike.%$term%',
        );
      }

      final from = page * pageSize;
      final res = await query
          .order('full_name')
          .range(from, from + pageSize - 1)
          .count(CountOption.exact);

      final items = res.data.map<Employee>(Employee.fromJson).toList();
      return PagedEmployees(
        items: await _withSalaries(items),
        total: res.count,
      );
    } catch (e) {
      throw map(e);
    }
  }

  @override
  Future<List<Department>> getDepartments() async {
    try {
      final rows = await _supabase
          .from('departments')
          .select('id, name')
          .order('name');
      return rows.map<Department>(Department.fromJson).toList();
    } catch (e) {
      throw map(e);
    }
  }

  @override
  Future<Employee> addEmployee(Employee employee) async {
    try {
      final row = await _supabase
          .from('employees')
          .insert(employee.toJson())
          .select(_select)
          .single();
      return (await _withSalaries([Employee.fromJson(row)])).first;
    } catch (e) {
      throw map(e);
    }
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    try {
      final row = await _supabase
          .from('employees')
          .update(employee.toJson())
          .eq('id', employee.id!)
          .select(_select)
          .single();
      return (await _withSalaries([Employee.fromJson(row)])).first;
    } catch (e) {
      throw map(e);
    }
  }

  @override
  Future<void> deleteEmployee(String id) async {
    try {
      final deleted =
      await _supabase.from('employees').delete().eq('id', id).select('id');
      if (deleted.isEmpty) {
        throw const AppException('تعذر الحذف: السجل غير موجود أو ليس لديك صلاحية');
      }
    } catch (e) {
      throw map(e);
    }
  }

  @override
  Future<bool> canViewSalary() async {
    try {
      final res = await _supabase.rpc(
        'has_permission',
        params: {'p_screen': 'payroll', 'p_action': 'view'},
      );
      return res == true;
    } catch (e) {
      debugPrint('canViewSalary error: $e');
      return false;
    }
  }

  Future<List<Employee>> _withSalaries(List<Employee> list) async {
    if (list.isEmpty) return list;
    final ids = list.map((e) => e.id).whereType<String>().toList();
    final rows = await _supabase.rpc(
      'get_employee_salaries',
      params: {'p_ids': ids},
    ) as List<dynamic>;

    final map = {
      for (final r in rows)
        (r as Map<String, dynamic>)['id'] as String:
        (r['salary'] as num).toString(),
    };
    return [for (final e in list) e.copyWith(salary: map[e.id])];
  }

}