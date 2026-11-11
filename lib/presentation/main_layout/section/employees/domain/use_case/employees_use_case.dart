import 'package:hr_project/presentation/main_layout/section/employees/data/repositories/employees_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_source/employees_remote_data_source.dart';
import '../../data/model/department.dart';
import '../../data/model/employee.dart';

@injectable
class EmployeesUseCase {
  final EmployeesRepositories employeesRepositories;

  EmployeesUseCase({required this.employeesRepositories});

  Future<PagedEmployees> getEmployees({
    String? search,
    String? departmentId,
    int page = 0,
    int pageSize = 20,
  }) {
    return employeesRepositories.getEmployees(
      search: search,
      departmentId: departmentId,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<List<Department>> getDepartments() {
    return employeesRepositories.getDepartments();
  }
  Future<bool> canViewSalary(){
    return employeesRepositories.canViewSalary();
  }
  Future<Employee> addEmployee(Employee employee) {
    return employeesRepositories.addEmployee(employee);
  }

  Future<Employee> updateEmployee(Employee employee) {
    return employeesRepositories.updateEmployee(employee);
  }

  Future<void> deleteEmployee(String id) {
    return employeesRepositories.deleteEmployee(id);
  }
}
