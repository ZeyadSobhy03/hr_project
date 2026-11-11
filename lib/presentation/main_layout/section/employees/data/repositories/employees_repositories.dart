import '../data_source/employees_remote_data_source.dart';
import '../model/department.dart';
import '../model/employee.dart';

abstract class EmployeesRepositories {
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