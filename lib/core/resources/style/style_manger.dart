import 'package:flutter/material.dart';

import '../colors/color_manger.dart';

class AppStyles {
  AppStyles._();

  static const double radiusInput = 8;
  static const double radiusCard = 12;
  static const double controlHeight = 44;
  static const double sidebarWidth = 220;
  static const double pagePadding = 28;
  static const double gap = 16;

  static const TextStyle pageTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: ColorManger.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: ColorManger.textPrimary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: ColorManger.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorManger.textPrimary,
  );

  static const TextStyle tableHeader = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: ColorManger.textPrimary,
  );

  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: ColorManger.error,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle logo = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: ColorManger.primary,
  );

  static const TextStyle sidebarItem = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorManger.sidebarText,
  );

  static const TextStyle sidebarItemActive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: ColorManger.primary,
  );

  static BoxDecoration card = BoxDecoration(
    color: ColorManger.card,
    borderRadius: BorderRadius.circular(radiusCard),
    border: Border.all(color: ColorManger.cardBorder),
  );

  static BoxDecoration sidebarActiveItem = BoxDecoration(
    color: ColorManger.white,
    borderRadius: BorderRadius.circular(radiusInput),
  );

  static OutlineInputBorder inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(radiusInput),
    borderSide: BorderSide(color: color),
  );

  static InputDecoration input({String? hint, Widget? suffixIcon}) =>
      InputDecoration(
        hintText: hint,
        counterText: '',
        filled: true,
        fillColor: ColorManger.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        constraints: const BoxConstraints(minHeight: controlHeight),
        enabledBorder: inputBorder(ColorManger.inputBorder),
        focusedBorder: inputBorder(ColorManger.primary),
        errorBorder: inputBorder(ColorManger.error),
        focusedErrorBorder: inputBorder(ColorManger.error),
        errorStyle: error,
        suffixIcon: suffixIcon,
      );

  static final ButtonStyle primaryButton = FilledButton.styleFrom(
    backgroundColor: ColorManger.primary,
    foregroundColor: ColorManger.white,
    minimumSize: const Size(0, controlHeight),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    textStyle: button,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusInput),
    ),
  );

  static final ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    backgroundColor: ColorManger.white,
    foregroundColor: ColorManger.primary,
    side: const BorderSide(color: ColorManger.primary),
    minimumSize: const Size(0, controlHeight),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    textStyle: button,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusInput),
    ),
  );

  static final ButtonStyle dangerButton = OutlinedButton.styleFrom(
    backgroundColor: ColorManger.white,
    foregroundColor: ColorManger.error,
    side: const BorderSide(color: ColorManger.error),
    minimumSize: const Size(0, controlHeight),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    textStyle: button,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusInput),
    ),
  );

  // أزرار صغيرة جوه الجداول (تعديل / حذف / طباعة)
  static final ButtonStyle tableButton = OutlinedButton.styleFrom(
    foregroundColor: ColorManger.primary,
    side: const BorderSide(color: ColorManger.primary),
    minimumSize: const Size(0, 36),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    textStyle: button,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusInput),
    ),
  );

  // ───────── Theme ─────────
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ColorManger.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorManger.primary,
      error: ColorManger.error,
    ),
    filledButtonTheme: FilledButtonThemeData(style: primaryButton),
    outlinedButtonTheme: OutlinedButtonThemeData(style: secondaryButton),
  );
}
