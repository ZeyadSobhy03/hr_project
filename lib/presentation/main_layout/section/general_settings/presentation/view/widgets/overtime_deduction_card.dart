import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';
import 'package:hr_project/presentation/main_layout/section/general_settings/presentation/view/widgets/settings_card.dart';

class OvertimeDeductionCard extends StatelessWidget {
  const OvertimeDeductionCard({
    super.key,
    required this.overtimeCtrl,
    required this.deductionCtrl,
    required this.salaryDaysCtrl,
    this.enabled = true,
  });

  final TextEditingController overtimeCtrl;
  final TextEditingController deductionCtrl;
  final TextEditingController salaryDaysCtrl;
  final bool enabled;

  String? _multiplier(String? value) {
    final number = num.tryParse((value ?? '').trim());
    if (number == null) return 'ادخل رقمًا صحيحًا';
    if (number < 0 || number > 999.99)
      return 'القيمة يجب أن تكون بين 0 و999.99';
    return null;
  }

  String? _daysBasis(String? value) {
    final days = int.tryParse((value ?? '').trim());
    if (days == null || days < 20 || days > 31) {
      return 'أدخل عدد أيام من 20 إلى 31';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'الإضافة والخصم',
      children: [
        const Text(
          'المعامل يضرب قيمة ساعة العمل الأساسية؛ مثال 1.5 يعني ساعة ونصف.',
        ),
        CustomTextFormedField(
          label: 'معامل حساب ساعة الإضافي',
          controller: overtimeCtrl,
          enabled: enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _multiplier,
        ),
        CustomTextFormedField(
          label: 'معامل خصم ساعة التأخير',
          controller: deductionCtrl,
          enabled: enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _multiplier,
        ),
        CustomTextFormedField(
          label: 'أيام احتساب الراتب في الشهر',
          controller: salaryDaysCtrl,
          enabled: enabled,
          keyboardType: TextInputType.number,
          validator: _daysBasis,
        ),
      ],
    );
  }
}
