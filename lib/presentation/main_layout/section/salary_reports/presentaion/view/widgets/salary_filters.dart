import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';
import 'package:hr_project/core/resources/widgets/drop_down_field.dart';

class SalaryFilters extends StatelessWidget {
  const SalaryFilters({
    super.key,
    required this.searchCtrl,
    required this.months,
    required this.years,
    required this.month,
    required this.year,
    required this.onMonthChanged,
    required this.onYearChanged,
    required this.onSearch,
  });

  final TextEditingController searchCtrl;
  final List<String> months;
  final List<String> years;
  final String? month;
  final String? year;
  final ValueChanged<String?> onMonthChanged;
  final ValueChanged<String?> onYearChanged;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        SizedBox(
          width: 280,
          child: CustomTextFormedField(
            label: 'بحث باسم الموظف',
            controller: searchCtrl,
          ),
        ),
        SizedBox(
          width: 110,
          child: DropDownField(
            label: 'الشهر',
            value: month,
            items: months,
            onChanged: onMonthChanged,
          ),
        ),
        SizedBox(
          width: 90,
          child: DropDownField(
            label: 'السنة',
            value: year,
            items: years,
            onChanged: onYearChanged,
          ),
        ),
        CustomButton(text: 'بحث', onPressed: onSearch),
      ],
    );
  }
}
