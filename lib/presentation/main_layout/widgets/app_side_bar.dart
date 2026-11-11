import 'package:flutter/material.dart';
import 'package:hr_project/presentation/main_layout/widgets/side_bar_item.dart';

import '../../../core/resources/colors/color_manger.dart';
import '../../../core/resources/style/style_manger.dart';
import '../main_layout.dart';

class AppSideBar extends StatelessWidget {
  const AppSideBar({super.key, required this.selectedIndex, required this.onSelected, required this.navItems});

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<NavItem> navItems ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppStyles.sidebarWidth,
      color: ColorManger.primary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 4, 12, 20),
                child: Text(
                  'Pioneers HR',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorManger.white,
                  ),
                ),
              ),
              for (int i = 0; i < kNavItems.length; i++)
                SideBarItem(
                  item: kNavItems[i],
                  isActive: i == selectedIndex,
                  onTap: () => onSelected(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
