import 'package:flutter/material.dart';

import '../../../core/resources/style/style_manger.dart';
import '../../../core/resources/widgets/custom_button.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.title, required this.onLogout});

  final String title;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.pagePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppStyles.pageTitle),
          CustomButton(
            text: 'تسجيل الخروج',
            type: ButtonType.secondary,
            icon: Icons.logout,
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}
