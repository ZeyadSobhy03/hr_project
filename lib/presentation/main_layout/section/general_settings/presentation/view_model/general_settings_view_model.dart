import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/errors/app_exception.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/general_settings.dart';
import '../../domain/use_case/general_settings_use_case.dart';

@injectable
class GeneralSettingsCubit extends Cubit<GeneralSettingsState> {
  GeneralSettingsCubit(this._useCase) : super(const GeneralSettingsState());

  final GeneralSettingsUseCase _useCase;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearNotice: true));
    try {
      final settings = await _useCase.getSettings();
      if (!isClosed) {
        emit(state.copyWith(settings: settings, isLoading: false));
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

  Future<void> updateSettings(GeneralSettingsData settings) async {
    if (state.isSaving) return;
    emit(state.copyWith(isSaving: true, clearNotice: true));
    try {
      final saved = await _useCase.updateSettings(settings);
      if (!isClosed) {
        emit(
          state.copyWith(
            settings: saved,
            isSaving: false,
            notice: 'تم حفظ الإعدادات بنجاح',
            isError: false,
          ),
        );
      }
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

class GeneralSettingsState {
  const GeneralSettingsState({
    this.settings,
    this.isLoading = false,
    this.isSaving = false,
    this.notice,
    this.isError = false,
  });

  final GeneralSettingsData? settings;
  final bool isLoading;
  final bool isSaving;
  final String? notice;
  final bool isError;

  GeneralSettingsState copyWith({
    GeneralSettingsData? settings,
    bool? isLoading,
    bool? isSaving,
    String? notice,
    bool? isError,
    bool clearNotice = false,
  }) => GeneralSettingsState(
    settings: settings ?? this.settings,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    notice: clearNotice ? null : (notice ?? this.notice),
    isError: clearNotice ? false : (isError ?? this.isError),
  );
}
