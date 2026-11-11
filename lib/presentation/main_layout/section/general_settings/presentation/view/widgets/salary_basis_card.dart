import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/style/style_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';

class SalaryBasisCard extends StatelessWidget {
  const SalaryBasisCard({
    super.key,
    required this.salaryDaysCtrl,
    required this.enabled,
  });

  final TextEditingController salaryDaysCtrl;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('حساب الراتب', style: AppStyles.sectionTitle),
          const SizedBox(height: 16),
          CustomTextFormedField(
            label: 'عدد أيام الشهر لحساب أجر اليوم',
            controller: salaryDaysCtrl,
            keyboardType: TextInputType.number,
            maxLength: 2,
            readOnly: !enabled,
            validator: (v) {
              final n = int.tryParse((v ?? '').trim());
              if (n == null) return 'هذا الحقل مطلوب';
              if (n < 20 || n > 31) return 'ادخل رقم من 20 إلى 31';
              return null;
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'أجر اليوم = الراتب ÷ هذا الرقم. ساعة التأخير تُخصم، وساعة الإضافي تُضاف بسعر الساعة العادي.',
            style: TextStyle(
              fontSize: 12,
              color: ColorManger.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}