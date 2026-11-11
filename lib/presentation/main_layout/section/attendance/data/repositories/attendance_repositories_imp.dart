import 'package:hr_project/presentation/main_layout/section/attendance/data/data_source/attendance_remote_data_source.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_models.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_record.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/repositories/attendance_repositories.dart';
import 'package:injectable/injectable.dart';
@LazySingleton(as: AttendanceRepositories)
class AttendanceRepositoriesImp implements AttendanceRepositories {
  final AttendanceRemoteDataSource attendanceRemoteDataSource;

  AttendanceRepositoriesImp({required this.attendanceRemoteDataSource});

  @override
  Future<void> addAttendance(AttendanceInput input) {
    return attendanceRemoteDataSource.addAttendance(input);
  }

  @override
  Future<void> deleteAttendance(String id) {
    return attendanceRemoteDataSource.deleteAttendance(id);
  }

  @override
  Future<List<AttendanceRecord>> getAllForExport({
    String? search,
    String? departmentId,
    DateTime? from,
    DateTime? to,
  }) {
    return attendanceRemoteDataSource.getAllForExport(
      search: search,
      departmentId: departmentId,
      from: from,
      to: to,
    );
  }

  @override
  Future<PagedAttendance> getAttendance({
    String? search,
    String? departmentId,
    DateTime? from,
    DateTime? to,
    int page = 0,
    int pageSize = 20,
  }) {
    return attendanceRemoteDataSource.getAttendance(
      search: search,
      departmentId: departmentId,
      from: from,
      to: to,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<List<EmployeeOption>> getEmployeeOptions() {
    return attendanceRemoteDataSource.getEmployeeOptions();
  }

  @override
  Future<ImportResult> importAttendance(List<ImportRow> rows) {
    return attendanceRemoteDataSource.importAttendance(rows);
  }

  @override
  Future<void> updateAttendance(String id, AttendanceInput input) {
    return attendanceRemoteDataSource.updateAttendance(id, input);
  }

  @override
  Future<PagedDaily> getDailyAttendance({required DateTime date, String? search, String? departmentId, int page = 0, int pageSize = 20,
    String? status,

  }) {
    return attendanceRemoteDataSource.getDailyAttendance(
      date: date,
      search: search,
      departmentId: departmentId,
      page: page,
      status: status,
      pageSize: pageSize,
    );

  }

  @override
  Future<int> markAllPresent(DateTime date, List<DailyAttendanceRow> rows) {
    return attendanceRemoteDataSource.markAllPresent(date, rows);
  }
}
