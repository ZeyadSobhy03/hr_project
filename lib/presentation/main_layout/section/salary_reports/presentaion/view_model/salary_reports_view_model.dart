import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/errors/app_exception.dart';
import 'package:hr_project/core/errors/permission_denied_exception.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/salary_record.dart';
import '../../domain/use_case/salary_reports_use_case.dart';

@injectable
class SalaryReportsCubit extends Cubit<SalaryReportsState> {
  SalaryReportsCubit(this._useCase)
      : super(
    SalaryReportsState(
      year: DateTime.now().year,
      month: DateTime.now().month,
    ),
  );

  final SalaryReportsUseCase _useCase;
  static const int pageSize = 50;
  int _requestId = 0;

  Future<void> load({int? year, int? month, String? search, int? page}) async {
    final next = state.copyWith(
      year: year,
      month: month,
      search: search,
      page: page,
      isLoading: true,
      forbidden: false,
      clearNotice: true,
    );
    emit(next);
    final requestId = ++_requestId;
    try {
      final result = await _useCase.getPayroll(
        year: next.year,
        month: next.month,
        search: next.search,
        page: next.page,
        pageSize: pageSize,
      );
      if (isClosed || requestId != _requestId) return;
      emit(
        next.copyWith(
          records: result.items,
          total: result.total,
          isLoading: false,
        ),
      );
    } on PermissionDeniedException {
      if (isClosed || requestId != _requestId) return;
      emit(
        next.copyWith(
          isLoading: false,
          forbidden: true,
          records: const [],
          total: 0,
          clearNotice: true,
        ),
      );
    } catch (error) {
      if (isClosed || requestId != _requestId) return;
      emit(
        next.copyWith(isLoading: false, notice: _message(error), isError: true),
      );
    }
  }

  Future<void> applyFilters({
    required int year,
    required int month,
    required String search,
  }) => load(year: year, month: month, search: search.trim(), page: 0);

  Future<void> goToPage(int page) {
    if (page < 0 || page >= state.totalPages || page == state.page) {
      return Future.value();
    }
    return load(page: page);
  }
  Future<List<SalaryRecord>> fetchAllForExport() async {
    const exportPageSize = 200;
    final all = <SalaryRecord>[];
    var page = 0;
    while (true) {
      final res = await _useCase.getPayroll(
        year: state.year,
        month: state.month,
        search: state.search,
        page: page,
        pageSize: exportPageSize,
      );
      all.addAll(res.items);
      if (all.length >= res.total || res.items.isEmpty) break;
      page++;
    }
    return all;
  }
  String _message(Object error) => error is AppException
      ? error.message
      : 'حدث خطأ غير متوقع، حاول مرة أخرى';
}

class SalaryReportsState {
  const SalaryReportsState({
    required this.year,
    required this.month,
    this.search = '',
    this.page = 0,
    this.total = 0,
    this.records = const [],
    this.isLoading = false,
    this.forbidden = false,
    this.notice,
    this.isError = false,
  });

  final int year;
  final int month;
  final String search;
  final int page;
  final int total;
  final List<SalaryRecord> records;
  final bool isLoading;
  final bool forbidden;
  final String? notice;
  final bool isError;

  int get totalPages =>
      total == 0 ? 1 : (total / SalaryReportsCubit.pageSize).ceil();

  SalaryReportsState copyWith({
    int? year,
    int? month,
    String? search,
    int? page,
    int? total,
    List<SalaryRecord>? records,
    bool? isLoading,
    bool? forbidden,
    String? notice,
    bool? isError,
    bool clearNotice = false,
  }) => SalaryReportsState(
    year: year ?? this.year,
    month: month ?? this.month,
    search: search ?? this.search,
    page: page ?? this.page,
    total: total ?? this.total,
    records: records ?? this.records,
    isLoading: isLoading ?? this.isLoading,
    forbidden: forbidden ?? this.forbidden,
    notice: clearNotice ? null : (notice ?? this.notice),
    isError: clearNotice ? false : (isError ?? this.isError),
  );
}