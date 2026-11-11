import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';

import '../../../../../../../core/utils/picker_utils.dart';

class HolidayForm extends StatelessWidget {
  const HolidayForm({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.dateCtrl,
    required this.onAdd,
    this.isSaving = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController dateCtrl;
  final Future<void> Function() onAdd;
  final bool isSaving;

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'مطلوب';
    return null;
  }

  String? _date(String? value) {
    if (value == null || value.trim().isEmpty) return 'مطلوب';
    final parts = value.split('/');
    if (parts.length != 3) return 'اختر تاريخًا صحيحًا';
    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (month == null || day == null || year == null || year < 2008) {
      return 'تاريخ الإجازة يجب أن يكون من سنة 2008 أو بعدها';
    }
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return 'اختر تاريخًا صحيحًا';
    }
    return null;
  }

  static const double _mobileBreakpoint = 700;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < _mobileBreakpoint;
          final nameField = CustomTextFormedField(
            label: 'اسم الإجازة',
            controller: nameCtrl,
            validator: _required,
          );
          final dateField = CustomTextFormedField(
            label: 'تاريخ الإجازة',
            controller: dateCtrl,
            readOnly: true,
            onTap: () => pickDate(context, dateCtrl),
            validator: _date,
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          );
          final addButton = CustomButton(
            text: 'إضافة',
            type: ButtonType.primary,
            isLoading: isSaving,
            onPressed: onAdd,
          );
          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                nameField,
                const SizedBox(height: 12),
                dateField,
                const SizedBox(height: 16),
                addButton,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextFormedField(
                  label: 'الاسم',
                  controller: nameCtrl,
                  validator: _required,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 150,
                child: CustomTextFormedField(
                  label: 'التاريخ',
                  controller: dateCtrl,
                  readOnly: true,
                  validator: _date,
                  onTap: () => pickDate(context, dateCtrl),
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 19),
                child: CustomButton(
                  text: 'إضافة',
                  onPressed: () => onAdd(),
                  isLoading: isSaving,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
