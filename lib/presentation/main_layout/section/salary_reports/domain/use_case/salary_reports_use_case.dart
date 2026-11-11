import 'package:injectable/injectable.dart';

import '../../data/models/salary_record.dart';
import '../../data/repositories/salary_reports_repositories.dart';

@injectable
class SalaryReportsUseCase {
  SalaryReportsUseCase({required this.repositories});

  final SalaryReportsRepositories repositories;

  Future<SalaryReportPage> getPayroll({
    required int year,
    required int month,
    String? search,
    int page = 0,
    int pageSize = 50,
  }) => repositories.getPayroll(
    year: year,
    month: month,
    search: search,
    page: page,
    pageSize: pageSize,
  );
}
