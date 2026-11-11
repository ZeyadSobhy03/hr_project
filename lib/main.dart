import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/presentation/auth/presentation/view_model/auth_view_model.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view_model/attendance_view_model.dart';
import 'package:hr_project/presentation/main_layout/section/employees/presentaion/view_model/employees_view_model.dart';
import 'package:hr_project/presentation/main_layout/section/general_settings/presentation/view_model/general_settings_view_model.dart';
import 'package:hr_project/presentation/main_layout/section/official_holidays/presentation/view_model/official_holidays_view_model.dart';
import 'package:hr_project/presentation/main_layout/section/salary_reports/presentaion/view_model/salary_reports_view_model.dart';
import 'package:hr_project/presentation/main_layout/section/users_permissions/presentation/view_model/users_permissions_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/DI/injection.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: "env.json");
  // Fetch variables from the build environment
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  await Supabase.initialize(
         url: supabaseUrl,
          publishableKey: supabaseKey,
        );
  configureDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => getIt<EmployeesCubit>()),
        BlocProvider(create: (context) => getIt<DailyAttendanceCubit>()),
        BlocProvider(create: (context) => getIt<OfficialHolidaysCubit>()),
        BlocProvider(create: (context) => getIt<SalaryReportsCubit>()),
        BlocProvider(create: (context) => getIt<GeneralSettingsCubit>()),
        BlocProvider(create: (context) => getIt<UsersPermissionsCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}
