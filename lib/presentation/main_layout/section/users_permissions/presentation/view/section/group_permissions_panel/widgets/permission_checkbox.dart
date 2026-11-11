
import 'package:flutter/material.dart';

class PermissionCheckbox extends StatelessWidget {
  const PermissionCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
  });

  final bool? value;
  final ValueChanged<bool?> onChanged;
  final bool tristate;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      tristate: tristate,
      value: value,
      onChanged: onChanged,
    );
  }
}
