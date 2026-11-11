import 'package:flutter/material.dart';

import '../colors/color_manger.dart';

class DropDownField extends StatelessWidget {
  const DropDownField({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.validator,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final String? Function(String?)? validator;

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: c),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorManger.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          dropdownColor: ColorManger.white,
          initialValue: value,
          isExpanded: true,
          validator: validator,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: const TextStyle(fontSize: 14, color: ColorManger.textPrimary),
          hint: hint == null
              ? null
              : Text(
                  hint!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorManger.textPrimary,
                  ),
                ),
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorManger.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            constraints: const BoxConstraints(minHeight: 44),
            enabledBorder: _border(ColorManger.inputBorder),
            focusedBorder: _border(ColorManger.primary),
            errorBorder: _border(ColorManger.error),
            focusedErrorBorder: _border(ColorManger.error),
            errorStyle: const TextStyle(fontSize: 12, color: ColorManger.error),
          ),
          items: [
            for (final i in items) DropdownMenuItem(

                value: i, child: Text(i)),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
