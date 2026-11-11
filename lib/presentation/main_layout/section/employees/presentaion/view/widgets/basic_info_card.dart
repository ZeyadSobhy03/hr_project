import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';
import 'package:hr_project/core/resources/widgets/drop_down_field.dart';
import 'package:hr_project/presentation/main_layout/section/employees/presentaion/view/widgets/section_card.dart';

import '../../../../../../../core/utils/picker_utils.dart';

class BasicInfoCard extends StatelessWidget {
  const BasicInfoCard({
    super.key,
    required this.nameCtrl,
    required this.addressCtrl,
    required this.phoneCtrl,
    required this.nationalityCtrl,
    required this.nationalIdCtrl,
    required this.birthDateCtrl,
    required this.gender,
    required this.genders,
    required this.onGenderChanged,
  });

  final TextEditingController nameCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController nationalityCtrl;
  final TextEditingController nationalIdCtrl;
  final TextEditingController birthDateCtrl;

  final String? gender;
  final List<String> genders;
  final ValueChanged<String?> onGenderChanged;

  String? _phoneValidator(String? v) {
    if (!RegExp(r'^01[0125]\d{8}$').hasMatch((v ?? '').trim())) {
      return 'من فضلك ادخل رقم تليفون صحيح';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'البيانات الأساسية',
      rows: [
        [
          CustomTextFormedField(label: 'اسم الموظف', controller: nameCtrl),
          CustomTextFormedField(label: 'العنوان', controller: addressCtrl),
        ],

        [
          CustomTextFormedField(
            label: 'رقم التليفون',
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            validator: _phoneValidator,
          ),

          DropDownField(
            label: 'النوع',
            value: gender,
            items: genders,
            onChanged: onGenderChanged,
          ),
        ],

        [
          CustomTextFormedField(label: 'الجنسية', controller: nationalityCtrl),

          CustomTextFormedField(
            label: 'تاريخ الميلاد',
            controller: birthDateCtrl,
            hint: 'mm/dd/yyyy',
            readOnly: true,
            onTap: () => pickDate(context, birthDateCtrl),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          ),
        ],

        [
          CustomTextFormedField(
            label: 'الرقم القومي',
            controller: nationalIdCtrl,
            keyboardType: TextInputType.number,
            maxLength: 14,
          ),

          const SizedBox.shrink(),
        ],
      ],
    );
  }
}
