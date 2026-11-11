import 'package:flutter/material.dart';

import '../colors/color_manger.dart';

class CustomTextFormedField extends StatefulWidget {
  const CustomTextFormedField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.isPassword = false,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.suffixIcon,
    this.maxLength,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final int? maxLength;

  @override
  State<CustomTextFormedField> createState() => _CustomTextFormedFieldState();
}

class _CustomTextFormedFieldState extends State<CustomTextFormedField> {
  bool _obscure = true;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorManger.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          onTap: widget.onTap,
          maxLength: widget.maxLength,
          obscureText: widget.isPassword && _obscure,
          style: const TextStyle(fontSize: 14, color: ColorManger.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
            counterText: '',
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
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: _obscure ? 'إظهار' : 'إخفاء',
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: ColorManger.inputBorder,
                    ),
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
