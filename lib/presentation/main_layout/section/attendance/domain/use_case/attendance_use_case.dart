import 'package:hr_project/presentation/main_layout/section/attendance/data/repositories/attendance_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/attendance_models.dart';
import '../../data/model/attendance_record.dart';
@injectable
class AttendanceUseCase {
  final AttendanceRepositories attendanceRepositories;

  AttendanceUseCase({required this.attendanceRepositories});

  Future<PagedAttendance> getAttendance({
    String? search,
    String? departmentId,
    DateTime? from,
    DateTime? to,
    int page = 0,
    int pageSize = 20,
  }) {
    return attendanceRepositories.getAttendance(
      search: search,
      departmentId: departmentId,
      from: from,
      to: to,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<List<AttendanceRecord>> getAllForExport({
    String? search,
    String? departmentId,
    DateTime? from,
    DateTime? to,
  }) {
    return attendanceRepositories.getAllForExport(
      departmentId: departmentId,
      from: from,
      search: search,

      to: to,
    );
  }

  Future<List<EmployeeOption>> getEmployeeOptions() {
    return attendanceRepositories.getEmployeeOptions();
  }

  Future<void> addAttendance(AttendanceInput input) {
    return attendanceRepositories.addAttendance(input);
  }

  Future<void> updateAttendance(String id, AttendanceInput input) {
    return attendanceRepositories.updateAttendance(id, input);
  }

  Future<void> deleteAttendance(String id) {
    return attendanceRepositories.deleteAttendance(id);
  }

  Future<ImportResult> importAttendance(List<ImportRow> rows) {
    return attendanceRepositories.importAttendance(rows);
  }
  Future<PagedDaily> getDailyAttendance({
    required DateTime date,
    String? search,
    String? departmentId,
    int page = 0,
    String? status,

    int pageSize = 20,
  }){
    return attendanceRepositories.getDailyAttendance(
      date: date,
      search: search,
      departmentId: departmentId,
      page: page,
      pageSize: pageSize,
      status: status
    );
  }
  Future<int> markAllPresent(DateTime date, List<DailyAttendanceRow> rows){
    return attendanceRepositories.markAllPresent(date, rows);
  }
}
