import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';
import 'package:hr_project/core/resources/widgets/drop_down_field.dart';
import 'package:hr_project/presentation/main_layout/section/employees/presentaion/view/widgets/section_card.dart';

import '../../../../../../../core/utils/picker_utils.dart';

class WorkInfoCard extends StatelessWidget {
  const WorkInfoCard({
    super.key,
    required this.department,
    required this.departments,
    required this.onDepartmentChanged,
    required this.hireDateCtrl,
    required this.salaryCtrl,
    required this.checkInCtrl,
    required this.checkOutCtrl,
    this.showSalary = true,
  });

  final String? department;
  final List<String> departments;
  final ValueChanged<String?> onDepartmentChanged;
  final TextEditingController hireDateCtrl;
  final TextEditingController salaryCtrl;
  final TextEditingController checkInCtrl;
  final TextEditingController checkOutCtrl;

  final bool showSalary;

  @override
  Widget build(BuildContext context) {
    final fields = <Widget>[
      DropDownField(
        label: 'القسم',
        value: department,
        items: departments,
        onChanged: onDepartmentChanged,
      ),
      CustomTextFormedField(
        label: 'تاريخ التعاقد',
        controller: hireDateCtrl,
        hint: 'mm/dd/yyyy',
        readOnly: true,
        onTap: () => pickDate(context, hireDateCtrl),
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
      ),
      if (showSalary)
        CustomTextFormedField(
          validator: (v) {
            final value = double.tryParse((v ?? '').trim());
            if (value == null) return 'أدخل راتب صحيح';

            return null;
          },
          label: 'الراتب',
          controller: salaryCtrl,
          keyboardType: TextInputType.number,
        ),
      CustomTextFormedField(
        label: 'موعد الحضور',
        controller: checkInCtrl,
        readOnly: true,
        onTap: () => pickTime(context, checkInCtrl),
        suffixIcon: const Icon(Icons.access_time, size: 18),
      ),
      CustomTextFormedField(
        label: 'موعد الانصراف',
        controller: checkOutCtrl,
        readOnly: true,
        onTap: () => pickTime(context, checkOutCtrl),
        suffixIcon: const Icon(Icons.access_time, size: 18),
      ),
    ];

    final rows = <List<Widget>>[
      for (var i = 0; i < fields.length; i += 2)
        [
          fields[i],
          i + 1 < fields.length ? fields[i + 1] : const SizedBox.shrink(),
        ],
    ];

    return SectionCard(title: 'بيانات العمل', rows: rows);
  }
}
