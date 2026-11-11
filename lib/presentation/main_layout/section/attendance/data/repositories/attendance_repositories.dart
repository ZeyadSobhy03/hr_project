import '../model/attendance_models.dart';
import '../model/attendance_record.dart';

abstract class AttendanceRepositories {
  Future<PagedAttendance> getAttendance({
    String? search,
    String? departmentId,
    DateTime? from,
    DateTime? to,
    int page = 0,
    int pageSize = 20,
  });

  Future<List<AttendanceRecord>> getAllForExport({
    String? search,
    String? departmentId,
    DateTime? from,
    DateTime? to,
  });

  Future<List<EmployeeOption>> getEmployeeOptions();

  Future<void> addAttendance(AttendanceInput input);

  Future<void> updateAttendance(String id, AttendanceInput input);

  Future<void> deleteAttendance(String id);

  Future<ImportResult> importAttendance(List<ImportRow> rows);
  Future<PagedDaily> getDailyAttendance({
    required DateTime date,
    String? search,
    String? departmentId,
    int page = 0,
    String? status,
    int pageSize = 20,
  });
  Future<int> markAllPresent(DateTime date, List<DailyAttendanceRow> rows);

}
