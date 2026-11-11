import 'package:flutter/material.dart';

import '../../../../../../../core/resources/colors/color_manger.dart';

Widget detailItem(String label, String value, {Color? color}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      const SizedBox(height: 3),
      Text(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: color ?? ColorManger.textPrimary,
        ),
      ),
    ],
  );
}