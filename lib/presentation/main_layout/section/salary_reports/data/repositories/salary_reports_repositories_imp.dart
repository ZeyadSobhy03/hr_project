import 'package:injectable/injectable.dart';

import '../data_source/salary_reports_remote_data_source.dart';
import '../models/salary_record.dart';
import 'salary_reports_repositories.dart';

@LazySingleton(as: SalaryReportsRepositories)
class SalaryReportsRepositoriesImp implements SalaryReportsRepositories {
  SalaryReportsRepositoriesImp({required this.remoteDataSource});

  final SalaryReportsRemoteDataSource remoteDataSource;

  @override
  Future<SalaryReportPage> getPayroll({
    required int year,
    required int month,
    String? search,
    int page = 0,
    int pageSize = 50,
  }) => remoteDataSource.getPayroll(
    year: year,
    month: month,
    search: search,
    page: page,
    pageSize: pageSize,
  );
}
