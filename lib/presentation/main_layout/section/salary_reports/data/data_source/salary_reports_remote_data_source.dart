import '../models/salary_record.dart';

abstract class SalaryReportsRemoteDataSource {
  Future<SalaryReportPage> getPayroll({
    required int year,
    required int month,
    String? search,
    int page = 0,
    int pageSize = 50,
  });
}
