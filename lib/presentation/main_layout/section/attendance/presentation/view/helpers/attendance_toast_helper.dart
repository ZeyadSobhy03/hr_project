import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

class AttendanceToastHelper {
  AttendanceToastHelper._();

  static void show(
      String message, {
        bool isError = false,
      }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError
          ? ColorManger.error
          : ColorManger.primary,
      textColor: ColorManger.white,
      fontSize: 14,
    );
  }
}