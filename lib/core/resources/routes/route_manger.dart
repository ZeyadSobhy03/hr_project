import 'package:flutter/material.dart';
import 'package:hr_project/presentation/auth/presentation/view/login_screen.dart';
import 'package:hr_project/presentation/main_layout/main_layout.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/attendance_screen.dart';
import 'package:hr_project/presentation/main_layout/section/employees/presentaion/view/employees_screen.dart';
import 'package:hr_project/presentation/main_layout/section/general_settings/presentation/view/general_settings.dart';
import 'package:hr_project/presentation/main_layout/section/official_holidays/presentation/view/official_holidays.dart';
import 'package:hr_project/presentation/main_layout/section/salary_reports/presentaion/view/salary_reports.dart';
import 'package:hr_project/presentation/main_layout/section/users_permissions/presentation/view/users_permissions.dart';

class RouteManger {
  static const String loginScreen = '/loginScreen';
  static const String mainLayoutScreen = '/mainLayoutScreen';
  static const String attendanceScreen = '/attendanceScreen';
  static const String employeesScreen = '/employeesScreen';
  static const String generalSettingsScreen = '/generalSettingsScreen';
  static const String officeHolidaysScreen = '/officeHolidaysScreen';
  static const String salaryReportsScreen = '/salaryReportsScreen';
  static const String usersPermissionsScreen = '/usersPermissionsScreen';

  static Route router(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      case attendanceScreen:
        return MaterialPageRoute(builder: (context) => AttendanceScreen());

      case employeesScreen:
        return MaterialPageRoute(builder: (context) => EmployeesScreen());

      case officeHolidaysScreen:
        return MaterialPageRoute(builder: (context) => OfficialHolidays());

      case generalSettingsScreen:
        return MaterialPageRoute(builder: (context) => GeneralSettings());

      case salaryReportsScreen:
        return MaterialPageRoute(builder: (context) => SalaryReports());

      case usersPermissionsScreen:
        return MaterialPageRoute(builder: (context) => UsersPermissions());

      case mainLayoutScreen:
        return MaterialPageRoute(builder: (context) => const MainLayout());

      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(body: Center(child: Text('No Route Found')));
          },
        );
    }
  }
}
