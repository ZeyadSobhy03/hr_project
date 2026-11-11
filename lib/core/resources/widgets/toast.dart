import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../colors/color_manger.dart';

void toast(
  String message, {
  bool isError = false,
  required BuildContext context,
}) {
  final backgroundColor = isError ? ColorManger.error : ColorManger.primary;

  if (Platform.isWindows) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: ColorManger.white, fontSize: 14),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    return;
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColor,
    textColor: ColorManger.white,
    fontSize: 14,
  );
}
