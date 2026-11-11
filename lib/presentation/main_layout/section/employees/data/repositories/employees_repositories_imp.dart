import 'package:hr_project/presentation/main_layout/section/employees/data/data_source/employees_remote_data_source.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/model/department.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/model/employee.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/repositories/employees_repositories.dart';
import 'package:injectable/injectable.dart';
@LazySingleton(as: EmployeesRepositories)
class EmployeesRepositoriesImp implements EmployeesRepositories {
  final EmployeesRemoteDataSource employeesRemoteDataSource;

  EmployeesRepositoriesImp({required this.employeesRemoteDataSource});

  @override
  Future<Employee> addEmployee(Employee employee) {
    return employeesRemoteDataSource.addEmployee(employee);
  }

  @override
  Future<void> deleteEmployee(String id) {
    return employeesRemoteDataSource.deleteEmployee(id);
  }

  @override
  Future<List<Department>> getDepartments() {
    return employeesRemoteDataSource.getDepartments();
  }

  @override
  Future<PagedEmployees> getEmployees({
    String? search,
    String? departmentId,
    int page = 0,
    int pageSize = 20,
  }) {
    return employeesRemoteDataSource.getEmployees(
      search: search,
      departmentId: departmentId,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Employee> updateEmployee(Employee employee) {
    return employeesRemoteDataSource.updateEmployee(employee);
  }

  @override
  Future<bool> canViewSalary() {
    return employeesRemoteDataSource.canViewSalary();
  }
}
