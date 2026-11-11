import 'package:flutter/material.dart';

import '../colors/color_manger.dart';

class CustomLabel extends StatelessWidget {
  const CustomLabel({super.key, required this.text});
  final String text ;


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: ColorManger.textPrimary,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
