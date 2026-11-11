import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

class ThemeManger {
  static ThemeData theme = ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: ColorManger.primary.withValues(alpha: 0.4),
        cursorColor: ColorManger.primary,)
  );

}