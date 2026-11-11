import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/style/style_manger.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/attendance_screen.dart';
import 'package:hr_project/presentation/main_layout/section/employees/presentaion/view/employees_screen.dart';
import 'package:hr_project/presentation/main_layout/section/general_settings/presentation/view/general_settings.dart';
import 'package:hr_project/presentation/main_layout/section/official_holidays/presentation/view/official_holidays.dart';
import 'package:hr_project/presentation/main_layout/section/salary_reports/presentaion/view/salary_reports.dart';
import 'package:hr_project/presentation/main_layout/section/users_permissions/presentation/view/users_permissions.dart';
import 'package:hr_project/presentation/main_layout/widgets/app_side_bar.dart';
import 'package:hr_project/presentation/main_layout/widgets/header.dart';

import '../auth/presentation/view_model/auth_view_model.dart';

class NavItem {
  const NavItem(this.title, this.icon);

  final String title;
  final IconData icon;
}

const List<NavItem> kNavItems = [
  NavItem('الموظفين', Icons.badge_outlined),
  NavItem('الحضور والانصراف', Icons.access_time),
  NavItem('الرواتب', Icons.payments_outlined),
  NavItem('الإعدادات العامة', Icons.settings_outlined),
  NavItem('الإجازات الرسمية', Icons.event_outlined),
  NavItem('المستخدمين والصلاحيات', Icons.admin_panel_settings_outlined),
];


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _index = 0;

  List<Widget> get _pages => const [
    EmployeesScreen(),
    AttendanceScreen(),
    SalaryReports(),
    GeneralSettings(),
    OfficialHolidays(),
    UsersPermissions(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/loginScreen', (route) => false);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorManger.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final loggingOut = state is AuthLoading;
        return Stack(
          children: [
            AppScaffold(
              title: kNavItems[_index].title,
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              onLogout: () {
                if (loggingOut) return;
                context.read<AuthCubit>().logout();
              },
              child: _pages[_index],
            ),
            if (loggingOut)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x66000000),
                  child: Center(
                    child: CircularProgressIndicator(color: ColorManger.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onLogout,
    required this.child,
  });

  final String title;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onLogout;
  final Widget child;

  static const double _breakpoint = 900;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _breakpoint;

    final sidebar = AppSideBar(
      navItems: kNavItems,
      selectedIndex: selectedIndex,
      onSelected: (i) {
        if (!isWide) Navigator.of(context).pop();
        onDestinationSelected(i);
      },
    );

    return Scaffold(
      backgroundColor: ColorManger.background,
      appBar: isWide
          ? null
          : AppBar(
              backgroundColor: ColorManger.primary,
              foregroundColor: ColorManger.white,
              title: Text(
                title,
                style: AppStyles.sectionTitle.copyWith(
                  color: ColorManger.white,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'تسجيل الخروج',
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
      drawer: isWide
          ? null
          : Drawer(backgroundColor: ColorManger.primary, child: sidebar),
      body: SafeArea(
        child: Row(
          children: [
            if (isWide) sidebar,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isWide) Header(title: title, onLogout: onLogout),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        AppStyles.pagePadding,
                        isWide ? 0 : AppStyles.pagePadding,
                        AppStyles.pagePadding,
                        AppStyles.pagePadding,
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
