import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

import '../style/style_manger.dart';

enum ButtonType { primary, secondary, danger, table }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? action = isLoading ? null : onPressed;

    final child = isLoading
        ?  SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2,
            color: ColorManger.primary,

            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    final Widget button = switch (type) {
      ButtonType.primary => FilledButton(
        style: AppStyles.primaryButton,
        onPressed: action,
        child: child,
      ),
      ButtonType.secondary => OutlinedButton(
        style: AppStyles.secondaryButton,
        onPressed: action,
        child: child,
      ),
      ButtonType.danger => OutlinedButton(
        style: AppStyles.dangerButton,
        onPressed: action,
        child: child,
      ),
      ButtonType.table => OutlinedButton(
        style: AppStyles.tableButton,
        onPressed: action,
        child: child,
      ),
    };

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
