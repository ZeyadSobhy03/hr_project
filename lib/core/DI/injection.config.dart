// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../presentation/auth/data/data_source/remote/auth_remote_data_source.dart'
    as _i569;
import '../../presentation/auth/data/data_source/remote/auth_supabase_data_source.dart'
    as _i810;
import '../../presentation/auth/data/repositories/auth_repositories.dart'
    as _i202;
import '../../presentation/auth/data/repositories/auth_repositories_imp.dart'
    as _i1032;
import '../../presentation/auth/domain/use_case/auth_use_case.dart' as _i835;
import '../../presentation/auth/presentation/view_model/auth_view_model.dart'
    as _i135;
import '../../presentation/main_layout/section/attendance/data/data_source/attendance_remote_data_source.dart'
    as _i1059;
import '../../presentation/main_layout/section/attendance/data/data_source/attendance_supabase_data_source.dart'
    as _i318;
import '../../presentation/main_layout/section/attendance/data/repositories/attendance_repositories.dart'
    as _i298;
import '../../presentation/main_layout/section/attendance/data/repositories/attendance_repositories_imp.dart'
    as _i196;
import '../../presentation/main_layout/section/attendance/domain/use_case/attendance_use_case.dart'
    as _i463;
import '../../presentation/main_layout/section/attendance/presentation/view_model/attendance_view_model.dart'
    as _i858;
import '../../presentation/main_layout/section/employees/data/data_source/employees_remote_data_source.dart'
    as _i486;
import '../../presentation/main_layout/section/employees/data/data_source/employees_supabase_data_source.dart'
    as _i793;
import '../../presentation/main_layout/section/employees/data/repositories/employees_repositories.dart'
    as _i1067;
import '../../presentation/main_layout/section/employees/data/repositories/employees_repositories_imp.dart'
    as _i26;
import '../../presentation/main_layout/section/employees/domain/use_case/employees_use_case.dart'
    as _i786;
import '../../presentation/main_layout/section/employees/presentaion/view_model/employees_view_model.dart'
    as _i923;
import '../../presentation/main_layout/section/users_permissions/data/data_source/users_permissions_remote_data_source.dart'
    as _i330;
import '../../presentation/main_layout/section/users_permissions/data/data_source/users_permissions_supabase_data_source.dart'
    as _i547;
import '../../presentation/main_layout/section/users_permissions/data/repositories/users_permissions_repositories.dart'
    as _i81;
import '../../presentation/main_layout/section/users_permissions/data/repositories/users_permissions_repositories_imp.dart'
    as _i184;
import '../../presentation/main_layout/section/users_permissions/domain/use_case/users_permissions_use_case.dart'
    as _i428;
import '../../presentation/main_layout/section/users_permissions/presentation/view_model/users_permissions_view_model.dart'
    as _i138;
import '../../presentation/main_layout/section/official_holidays/data/data_source/official_holidays_remote_data_source.dart'
    as _i224;
import '../../presentation/main_layout/section/official_holidays/data/data_source/official_holidays_supabase_data_source.dart'
    as _i412;
import '../../presentation/main_layout/section/official_holidays/data/repositories/official_holidays_repositories.dart'
    as _i918;
import '../../presentation/main_layout/section/official_holidays/data/repositories/official_holidays_repositories_imp.dart'
    as _i730;
import '../../presentation/main_layout/section/official_holidays/domain/use_case/official_holidays_use_case.dart'
    as _i646;
import '../../presentation/main_layout/section/official_holidays/presentation/view_model/official_holidays_view_model.dart'
    as _i205;
import '../../presentation/main_layout/section/salary_reports/data/data_source/salary_reports_remote_data_source.dart'
    as _i608;
import '../../presentation/main_layout/section/salary_reports/data/data_source/salary_reports_supabase_data_source.dart'
    as _i609;
import '../../presentation/main_layout/section/salary_reports/data/repositories/salary_reports_repositories.dart'
    as _i610;
import '../../presentation/main_layout/section/salary_reports/data/repositories/salary_reports_repositories_imp.dart'
    as _i611;
import '../../presentation/main_layout/section/salary_reports/domain/use_case/salary_reports_use_case.dart'
    as _i612;
import '../../presentation/main_layout/section/salary_reports/presentaion/view_model/salary_reports_view_model.dart'
    as _i613;
import '../../presentation/main_layout/section/general_settings/data/data_source/general_settings_remote_data_source.dart'
    as _i820;
import '../../presentation/main_layout/section/general_settings/data/data_source/general_settings_supabase_data_source.dart'
    as _i821;
import '../../presentation/main_layout/section/general_settings/data/repositories/general_settings_repositories.dart'
    as _i822;
import '../../presentation/main_layout/section/general_settings/data/repositories/general_settings_repositories_imp.dart'
    as _i823;
import '../../presentation/main_layout/section/general_settings/domain/use_case/general_settings_use_case.dart'
    as _i824;
import '../../presentation/main_layout/section/general_settings/presentation/view_model/general_settings_view_model.dart'
    as _i825;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i486.EmployeesRemoteDataSource>(
      () => _i793.EmployeesSupabaseDataSource(),
    );
    gh.lazySingleton<_i569.AuthRemoteDataSource>(
      () => _i810.AuthSupabaseDataSource(),
    );
    gh.lazySingleton<_i1059.AttendanceRemoteDataSource>(
      () => _i318.AttendanceSupabaseDataSource(),
    );
    gh.lazySingleton<_i330.UsersPermissionsRemoteDataSource>(
      () => _i547.UsersPermissionsSupabaseDataSource(),
    );
    gh.lazySingleton<_i224.OfficialHolidaysRemoteDataSource>(
      () => _i412.OfficialHolidaysSupabaseDataSource(),
    );
    gh.lazySingleton<_i608.SalaryReportsRemoteDataSource>(
      () => _i609.SalaryReportsSupabaseDataSource(),
    );
    gh.lazySingleton<_i820.GeneralSettingsRemoteDataSource>(
      () => _i821.GeneralSettingsSupabaseDataSource(),
    );
    gh.lazySingleton<_i1067.EmployeesRepositories>(
      () => _i26.EmployeesRepositoriesImp(
        employeesRemoteDataSource: gh<_i486.EmployeesRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i202.AuthRepositories>(
      () => _i1032.AuthRepositoriesImp(
        authRemoteDataSource: gh<_i569.AuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i298.AttendanceRepositories>(
      () => _i196.AttendanceRepositoriesImp(
        attendanceRemoteDataSource: gh<_i1059.AttendanceRemoteDataSource>(),
      ),
    );
    gh.factory<_i835.AuthUseCase>(
      () => _i835.AuthUseCase(authRepositories: gh<_i202.AuthRepositories>()),
    );
    gh.factory<_i786.EmployeesUseCase>(
      () => _i786.EmployeesUseCase(
        employeesRepositories: gh<_i1067.EmployeesRepositories>(),
      ),
    );
    gh.factory<_i463.AttendanceUseCase>(
      () => _i463.AttendanceUseCase(
        attendanceRepositories: gh<_i298.AttendanceRepositories>(),
      ),
    );
    gh.lazySingleton<_i81.UsersPermissionsRepositories>(
      () => _i184.UsersPermissionsRepositoriesImp(
        usersPermissionsRemoteDataSource:
            gh<_i330.UsersPermissionsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i918.OfficialHolidaysRepositories>(
      () => _i730.OfficialHolidaysRepositoriesImp(
        remoteDataSource: gh<_i224.OfficialHolidaysRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i610.SalaryReportsRepositories>(
      () => _i611.SalaryReportsRepositoriesImp(
        remoteDataSource: gh<_i608.SalaryReportsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i822.GeneralSettingsRepositories>(
      () => _i823.GeneralSettingsRepositoriesImp(
        remoteDataSource: gh<_i820.GeneralSettingsRemoteDataSource>(),
      ),
    );
    gh.factory<_i428.UsersPermissionsUseCase>(
      () => _i428.UsersPermissionsUseCase(
        usersPermissionsRepositories: gh<_i81.UsersPermissionsRepositories>(),
      ),
    );
    gh.factory<_i646.OfficialHolidaysUseCase>(
      () => _i646.OfficialHolidaysUseCase(
        repositories: gh<_i918.OfficialHolidaysRepositories>(),
      ),
    );
    gh.factory<_i612.SalaryReportsUseCase>(
      () => _i612.SalaryReportsUseCase(
        repositories: gh<_i610.SalaryReportsRepositories>(),
      ),
    );
    gh.factory<_i824.GeneralSettingsUseCase>(
      () => _i824.GeneralSettingsUseCase(
        repositories: gh<_i822.GeneralSettingsRepositories>(),
      ),
    );
    gh.factory<_i923.EmployeesCubit>(
      () => _i923.EmployeesCubit(gh<_i786.EmployeesUseCase>()),
    );
    gh.factory<_i135.AuthCubit>(() => _i135.AuthCubit(gh<_i835.AuthUseCase>()));
    gh.factory<_i858.DailyAttendanceCubit>(
      () => _i858.DailyAttendanceCubit(gh<_i463.AttendanceUseCase>()),
    );
    gh.factory<_i138.UsersPermissionsCubit>(
      () => _i138.UsersPermissionsCubit(gh<_i428.UsersPermissionsUseCase>()),
    );
    gh.factory<_i205.OfficialHolidaysCubit>(
      () => _i205.OfficialHolidaysCubit(gh<_i646.OfficialHolidaysUseCase>()),
    );
    gh.factory<_i613.SalaryReportsCubit>(
      () => _i613.SalaryReportsCubit(gh<_i612.SalaryReportsUseCase>()),
    );
    gh.factory<_i825.GeneralSettingsCubit>(
      () => _i825.GeneralSettingsCubit(gh<_i824.GeneralSettingsUseCase>()),
    );
    return this;
  }
}
