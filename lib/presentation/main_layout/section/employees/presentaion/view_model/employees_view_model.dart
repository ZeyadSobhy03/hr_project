import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/errors/app_exception.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/model/department.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/model/employee.dart';
import 'package:hr_project/presentation/main_layout/section/employees/domain/use_case/employees_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit(this._useCase) : super(const EmployeesInitial());

  final EmployeesUseCase _useCase;

  static const int pageSize = 20;

  String _search = '';
  String? _departmentId;

  EmployeesLoaded? _data;

  EmployeesLoaded? get data => _data;

  void _emitLoaded(EmployeesLoaded s) {
    _data = s;
    if (!isClosed) emit(s);
  }

  Future<void> init() async {
    emit(const EmployeesLoading());
    try {
      final (departments, canSalary) = await (
      _useCase.getDepartments(),
      _useCase.canViewSalary(),
      ).wait;

      final paged = await _useCase.getEmployees(
        search: _search,
        departmentId: _departmentId,
        page: 0,
        pageSize: pageSize,
      );
      _emitLoaded(
        EmployeesLoaded(
          employees: paged.items,
          departments: departments,
          total: paged.total,
          page: 0,
          canViewSalary: canSalary,
        ),
      );
    } catch (e) {
      if (!isClosed) emit(EmployeesFailure(_errorMessage(e)));
    }
  }

  Future<void> search(String query) {
    _search = query.trim();
    return goToPage(0);
  }

  Future<void> filterByDepartment(String? departmentId) {
    _departmentId = departmentId;
    return goToPage(0);
  }

  Future<void> goToPage(int page) async {
    final current = _data;
    if (current == null) return;
    try {
      final paged = await _useCase.getEmployees(
        search: _search,
        departmentId: _departmentId,
        page: page,
        pageSize: pageSize,
      );
      _emitLoaded(
        current.copyWith(
          employees: paged.items,
          total: paged.total,
          page: page,
        ),
      );
    } catch (e) {
      if (!isClosed) emit(EmployeesFailure(_errorMessage(e)));
    }
  }

  Future<void> addEmployee(Employee employee) => _runAction(
        () => _useCase.addEmployee(employee),
    'تمت إضافة الموظف بنجاح',
    firstPage: true,
  );

  Future<void> getDepartments() async {
    try {
      final departments = await _useCase.getDepartments();
      final current = _data;
      if (current != null) {
        _emitLoaded(current.copyWith(departments: departments));
      }
    } catch (e) {
      if (!isClosed) emit(EmployeesFailure(_errorMessage(e)));
    }
  }

  Future<void> updateEmployee(Employee employee) => _runAction(
        () => _useCase.updateEmployee(employee),
    'تم تعديل بيانات الموظف بنجاح',
  );

  Future<void> deleteEmployee(String id) =>
      _runAction(() => _useCase.deleteEmployee(id), 'تم حذف الموظف بنجاح');

  Future<void> _runAction(
      Future<void> Function() action,
      String successMessage, {
        bool firstPage = false,
      }) async {
    final current = _data;
    if (current == null) return;

    _emitLoaded(current.copyWith(isSaving: true));
    try {
      await action();
      final page = firstPage ? 0 : current.page;
      final paged = await _useCase.getEmployees(
        search: _search,
        departmentId: _departmentId,
        page: page,
        pageSize: pageSize,
      );
      _emitLoaded(
        current.copyWith(
          employees: paged.items,
          total: paged.total,
          page: page,
          isSaving: false,
        ),
      );
      if (!isClosed) emit(EmployeesActionSuccess(successMessage));
    } catch (e) {
      _emitLoaded(current.copyWith(isSaving: false));
      if (!isClosed) emit(EmployeesFailure(_errorMessage(e)));
    }
  }

  // الـ data source بيحوّل كل الأخطاء لـ AppException برسالة عربي جاهزة
  String _errorMessage(Object error) {
    if (error is AppException) return error.message;
    return 'حدث خطأ غير متوقع، حاول مرة أخرى';
  }
}

sealed class EmployeesState {
  const EmployeesState();
}

final class EmployeesInitial extends EmployeesState {
  const EmployeesInitial();
}

final class EmployeesLoading extends EmployeesState {
  const EmployeesLoading();
}

final class EmployeesLoaded extends EmployeesState {
  const EmployeesLoaded({
    required this.employees,
    required this.departments,
    required this.total,
    required this.page,
    this.isSaving = false,
    this.canViewSalary = false,
  });

  final List<Employee> employees;
  final List<Department> departments;
  final int total;
  final int page; // 0-based
  final bool isSaving;
  final bool canViewSalary; // الراتب ظاهر ويتعدّل بس لو true

  int get totalPages =>
      total == 0 ? 1 : (total / EmployeesCubit.pageSize).ceil();

  EmployeesLoaded copyWith({
    List<Employee>? employees,
    List<Department>? departments,
    int? total,
    int? page,
    bool? isSaving,
    bool? canViewSalary,
  }) =>
      EmployeesLoaded(
        employees: employees ?? this.employees,
        departments: departments ?? this.departments,
        total: total ?? this.total,
        page: page ?? this.page,
        isSaving: isSaving ?? this.isSaving,
        canViewSalary: canViewSalary ?? this.canViewSalary,
      );
}

final class EmployeesActionSuccess extends EmployeesState {
  const EmployeesActionSuccess(this.message);

  final String message;
}

final class EmployeesFailure extends EmployeesState {
  const EmployeesFailure(this.message);

  final String message;
}