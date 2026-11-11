import 'package:hr_project/presentation/main_layout/section/employees/data/model/department.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/model/employee.dart';

class PagedEmployees {
  const PagedEmployees({required this.items, required this.total});
  final List<Employee> items;
  final int total;
}

abstract class EmployeesRemoteDataSource {
  Future<PagedEmployees> getEmployees({
    String? search,
    String? departmentId,
    int page = 0,
    int pageSize = 20,
  });

  Future<List<Department>> getDepartments();

  Future<Employee> addEmployee(Employee employee);

  Future<Employee> updateEmployee(Employee employee);
  Future<bool> canViewSalary();
  Future<void> deleteEmployee(String id);
}