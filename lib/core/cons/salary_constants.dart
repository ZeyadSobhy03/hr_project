import 'package:flutter/material.dart';

const kSalaryGreen = Color(0xFF2E7D32);
const kSalaryRed = Color(0xFFC62828);

const kSalaryColumns = <(String, int)>[
  ('اسم الموظف', 3),
  ('القسم', 2),
  ('الراتب الأساسي', 2),
  ('أيام الحضور', 2),
  ('أيام الغياب', 2),
  ('الإضافي بالساعات', 2),
  ('الخصم بالساعات', 2),
  ('إجمالي الإضافي', 2),
  ('إجمالي الخصم', 2),
  ('الصافي', 2),
  ('العمليات', 2),
];

String fmtNum(num n) =>
    n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(2);