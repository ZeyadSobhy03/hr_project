import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/presentation/main_layout/section/general_settings/presentation/view/widgets/settings_card.dart';

class WeeklyHolidaysCard extends StatelessWidget {
  const WeeklyHolidaysCard({
    super.key,
    required this.days,
    required this.selectedDays,
    required this.onChanged,
    this.enabled = true,
  });

  final List<(int, String)> days;
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'الإجازات الأسبوعية',
      children: [
        const Text('اختر من يوم إلى 3 أيام إجازة أسبوعية.'),
        Wrap(
          spacing: 4,
          runSpacing: 0,
          children: [
            for (final (day, label) in days)
              SizedBox(
                width: 150,
                child: Material(
                  color: Colors.transparent,
                  child: CheckboxListTile(
                    activeColor: ColorManger.primary,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(label),
                    value: selectedDays.contains(day),
                    onChanged:
                        !enabled ||
                            (!selectedDays.contains(day) &&
                                selectedDays.length >= 3) ||
                            (selectedDays.contains(day) &&
                                selectedDays.length <= 1)
                        ? null
                        : (checked) {
                            final next = [...selectedDays];
                            if (checked == true) {
                              next.add(day);
                            } else {
                              next.remove(day);
                            }
                            next.sort();
                            onChanged(next);
                          },
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
