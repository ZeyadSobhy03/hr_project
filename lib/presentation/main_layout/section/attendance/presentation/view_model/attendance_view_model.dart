import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/errors/app_exception.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_models.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/domain/use_case/attendance_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/attendance_record.dart';

enum LoadStatus { loading, ready, failure }


enum DayFilter {
  all(null),
  present('present'),
  absent('absent');

  const DayFilter(this.dbValue);
  final String? dbValue;
}

class Notice {
  Notice(this.message, {this.isError = false});
  final String message;
  final bool isError;
}

class DailyAttendanceState {
  const DailyAttendanceState({
    required this.date,
    this.status = LoadStatus.loading,
    this.filter = DayFilter.all,
    this.search = '',
    this.page = 0,
    this.total = 0,
    this.rows = const [],
    this.isSaving = false,
    this.notice,
  });

  final DateTime date;
  final LoadStatus status;
  final DayFilter filter;
  final String search;
  final int page; // 0-based
  final int total;
  final List<DailyAttendanceRow> rows;
  final bool isSaving;
  final Notice? notice;

  int get totalPages =>
      total == 0 ? 1 : (total / DailyAttendanceCubit.pageSize).ceil();

  DailyAttendanceState copyWith({
    DateTime? date,
    LoadStatus? status,
    DayFilter? filter,
    String? search,
    int? page,
    int? total,
    List<DailyAttendanceRow>? rows,
    bool? isSaving,
    Notice? notice, // لو مبعتهاش بتتصفّر
  }) =>
      DailyAttendanceState(
        date: date ?? this.date,
        status: status ?? this.status,
        filter: filter ?? this.filter,
        search: search ?? this.search,
        page: page ?? this.page,
        total: total ?? this.total,
        rows: rows ?? this.rows,
        isSaving: isSaving ?? this.isSaving,
        notice: notice,
      );
}

@injectable
class DailyAttendanceCubit extends Cubit<DailyAttendanceState> {
  DailyAttendanceCubit(this._useCase)
      : super(DailyAttendanceState(date: DateTime.now()));

  final AttendanceUseCase _useCase;

  static const int pageSize = 20;

  int _requestId = 0;

  bool get _isToday {
    final n = DateTime.now(), d = state.date;
    return d.year == n.year && d.month == n.month && d.day == n.day;
  }

  Future<void> load({bool silent = false}) async {
    final id = ++_requestId;
    if (!silent) emit(state.copyWith(status: LoadStatus.loading));
    try {
      final res = await _useCase.getDailyAttendance(
        date: state.date,
        search: state.search,
        status: state.filter.dbValue,
        page: state.page,
        pageSize: pageSize,
      );
      if (isClosed || id != _requestId) return;
      emit(state.copyWith(
        status: LoadStatus.ready,
        rows: res.items,
        total: res.total,
        notice: state.notice,
      ));
    } catch (e) {
      if (isClosed || id != _requestId) return;
      emit(state.copyWith(
        status: LoadStatus.failure,
        notice: Notice(_msg(e), isError: true),
      ));
    }
  }

  Future<void> applyFilters({
    DateTime? date,
    String? search,
    DayFilter? filter,
  }) {
    emit(state.copyWith(
      date: date,
      search: search?.trim(),
      filter: filter,
      page: 0,
    ));
    return load();
  }

  Future<void> goToPage(int page) {
    if (page < 0 || page >= state.totalPages) return Future.value();
    emit(state.copyWith(page: page));
    return load();
  }
  Future<ImportResult?> importRows(List<ImportRow> rows) async {
    if (state.isSaving) return null;
    emit(state.copyWith(isSaving: true));
    try {
      final result = await _useCase.importAttendance(rows);
      if (isClosed) return null;
      emit(state.copyWith(isSaving: false));
      await load(silent: true);
      return result;
    } catch (e) {
      if (isClosed) return null;
      emit(state.copyWith(isSaving: false, notice: Notice(_msg(e), isError: true)));
      return null;
    }
  }
  Future<List<DailyAttendanceRow>> fetchAllForExport() async {
    const exportPageSize = 200;
    final all = <DailyAttendanceRow>[];
    var page = 0;
    while (true) {
      final res = await _useCase.getDailyAttendance(
        date: state.date,
        search: state.search,
        status: state.filter.dbValue,
        page: page,
        pageSize: exportPageSize,
      );
      all.addAll(res.items);
      if (all.length >= res.total || res.items.isEmpty) break;
      page++;
    }
    return all;
  }

  Future<void> markPresent(DailyAttendanceRow r) => _action(
        () => _useCase.addAttendance(AttendanceInput(
      employeeId: r.employeeId,
      date: state.date,
      checkIn: r.scheduledIn,
      checkOut: _isToday ? null : r.scheduledOut,
    )),
    success: 'تم تسجيل ${r.employeeName} حاضر',
  );

  Future<void> markAbsent(DailyAttendanceRow r) =>
      _action(() => _useCase.deleteAttendance(r.attendanceId!),
          success: 'تم تسجيل ${r.employeeName} غائب');

  Future<void> editTime(DailyAttendanceRow r, bool isCheckIn, String newTime) =>
      _action(
            () => _useCase.updateAttendance(
          r.attendanceId!,
          AttendanceInput(
            employeeId: r.employeeId,
            date: state.date,
            checkIn: isCheckIn ? newTime : r.checkIn!,
            checkOut: isCheckIn ? r.checkOut : newTime,
          ),
        ),
        success: 'تم تعديل الوقت',
      );

  Future<void> markAllPresent() async {
    final n = state.rows.where((r) => r.status == DayStatus.absent).length;
    if (n == 0) {
      emit(state.copyWith(
          notice: Notice('لا يوجد موظفين غائبين في هذه الصفحة')));
      return;
    }
    await _action(
          () => _useCase.markAllPresent(state.date, state.rows),
      success: 'تم تسجيل $n موظف حاضرين',
    );
  }

  Future<void> _action(Future<void> Function() action,
      {String? success}) async {
    if (state.isSaving) return; // يمنع الضغط المزدوج
    emit(state.copyWith(isSaving: true));
    try {
      await action();
      if (isClosed) return;
      emit(state.copyWith(
        isSaving: false,
        notice: success == null ? null : Notice(success),
      ));
      await load(silent: true);
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
          isSaving: false, notice: Notice(_msg(e), isError: true)));
      await load(silent: true); 
    }
  }

  String _msg(Object e) =>
      e is AppException ? e.message : 'حدث خطأ غير متوقع، حاول مرة أخرى';
}