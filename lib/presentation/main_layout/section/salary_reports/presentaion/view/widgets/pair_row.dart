import 'package:flutter/material.dart';

Widget pairRow(Widget a, Widget b) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(child: a),
    const SizedBox(width: 10),
    Expanded(child: b),
  ],
);
