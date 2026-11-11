import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/errors/app_exception.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/holiday.dart';
import '../../domain/use_case/official_holidays_use_case.dart';

@injectable
class OfficialHolidaysCubit extends Cubit<OfficialHolidaysState> {
  OfficialHolidaysCubit(this._useCase) : super(const OfficialHolidaysState());

  final OfficialHolidaysUseCase _useCase;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearNotice: true));
    try {
      final holidays = await _useCase.getHolidays();
      if (!isClosed) {
        emit(state.copyWith(holidays: holidays, isLoading: false));
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            notice: _message(error),
            isError: true,
          ),
        );
      }
    }
  }

  Future<void> addHoliday(Holiday holiday) =>
      _run(() => _useCase.addHoliday(holiday), 'تمت إضافة الإجازة بنجاح');

  Future<void> updateHoliday(Holiday holiday) =>
      _run(() => _useCase.updateHoliday(holiday), 'تم تعديل الإجازة بنجاح');

  Future<void> deleteHoliday(String id) =>
      _run(() => _useCase.deleteHoliday(id), 'تم حذف الإجازة بنجاح');

  Future<void> _run(Future<void> Function() action, String success) async {
    if (state.isSaving) return;
    emit(state.copyWith(isSaving: true, clearNotice: true));
    try {
      await action();
      final holidays = await _useCase.getHolidays();
      if (isClosed) return;
      emit(
        state.copyWith(
          holidays: holidays,
          isSaving: false,
          notice: success,
          isError: false,
        ),
      );
    } catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isSaving: false,
            notice: _message(error),
            isError: true,
          ),
        );
      }
    }
  }

  String _message(Object error) => error is AppException
      ? error.message
      : 'حدث خطأ غير متوقع، حاول مرة أخرى';
}

class OfficialHolidaysState {
  const OfficialHolidaysState({
    this.holidays = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.notice,
    this.isError = false,
  });

  final List<Holiday> holidays;
  final bool isLoading;
  final bool isSaving;
  final String? notice;
  final bool isError;

  OfficialHolidaysState copyWith({
    List<Holiday>? holidays,
    bool? isLoading,
    bool? isSaving,
    String? notice,
    bool? isError,
    bool clearNotice = false,
  }) => OfficialHolidaysState(
    holidays: holidays ?? this.holidays,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    notice: clearNotice ? null : (notice ?? this.notice),
    isError: clearNotice ? false : (isError ?? this.isError),
  );
}
