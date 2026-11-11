import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';

import '../../../../../../../core/utils/picker_utils.dart';


class AttendanceFilters extends StatelessWidget {
  const AttendanceFilters({
    super.key,
    required this.searchCtrl,
    required this.fromCtrl,
    required this.toCtrl,
    required this.onShow,
    required this.onAdd,
    required this.onImportExcel,
    required this.onExportPdf,
    required this.onPrint,
  });

  final TextEditingController searchCtrl;
  final TextEditingController fromCtrl;
  final TextEditingController toCtrl;
  final VoidCallback onShow;
  final VoidCallback onAdd;
  final VoidCallback onImportExcel;
  final VoidCallback onExportPdf;
  final VoidCallback onPrint;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        SizedBox(
          width: 220,
          child: CustomTextFormedField(
            label: 'بحث باسم الموظف أو القسم',
            controller: searchCtrl,
          ),
        ),
        SizedBox(
          width: 150,
          child: CustomTextFormedField(
            label: 'من',
            controller: fromCtrl,
            readOnly: true,
            onTap: () => pickDate(context, fromCtrl),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          ),
        ),
        SizedBox(
          width: 150,
          child: CustomTextFormedField(
            label: 'إلى',
            controller: toCtrl,
            readOnly: true,
            onTap: () => pickDate(context, toCtrl),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          ),
        ),
        CustomButton(text: 'عرض', onPressed: onShow),
        CustomButton(
          text: 'إضافة',
          type: ButtonType.secondary,
          onPressed: onAdd,
        ),
        CustomButton(
          text: 'استيراد Excel',
          type: ButtonType.secondary,
          onPressed: onImportExcel,
        ),
        CustomButton(
          text: 'PDF',
          type: ButtonType.secondary,
          onPressed: onExportPdf,
        ),
        CustomButton(
          text: 'طباعة',
          type: ButtonType.secondary,
          onPressed: onPrint,
        ),
      ],
    );
  }
}