import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/presentation/main_layout/section/general_settings/presentation/view/widgets/salary_basis_card.dart';
import 'package:hr_project/presentation/main_layout/section/general_settings/presentation/view/widgets/weekly_holidays_card.dart';

import '../../data/model/general_settings.dart';
import '../view_model/general_settings_view_model.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  static const _days = <(int, String)>[
    (0, 'الأحد'),
    (1, 'الاثنين'),
    (2, 'الثلاثاء'),
    (3, 'الأربعاء'),
    (4, 'الخميس'),
    (5, 'الجمعة'),
    (6, 'السبت'),
  ];

  final _formKey = GlobalKey<FormState>();
  final _salaryDaysCtrl = TextEditingController();
  List<int> _selectedDays = const [];
  GeneralSettingsData? _loadedSettings;
  bool _isEditing = false;

  GeneralSettingsCubit get _cubit => context.read<GeneralSettingsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  void dispose() {
    _salaryDaysCtrl.dispose();
    super.dispose();
  }

  void _populate(GeneralSettingsData settings) {
    _salaryDaysCtrl.text = settings.salaryDaysBasis.toString();
    _selectedDays = [...settings.weeklyOffDays]..sort();
    _loadedSettings = settings;
    _isEditing = false;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty || _selectedDays.length > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر من يوم إلى 3 أيام إجازة أسبوعية')),
      );
      return;
    }
    final salaryDays = int.tryParse(_salaryDaysCtrl.text.trim());
    if (salaryDays == null) return;

    await _cubit.updateSettings(
      GeneralSettingsData(
        weeklyOffDays: [..._selectedDays]..sort(),
        salaryDaysBasis: salaryDays,
      ),
    );
  }

  void _cancelEdit() {
    final settings = _loadedSettings;
    if (settings != null) {
      setState(() {
        _populate(settings);
        _formKey.currentState?.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralSettingsCubit, GeneralSettingsState>(
      listenWhen: (previous, current) =>
      current.notice != null && current.notice != previous.notice ||
          !identical(previous.settings, current.settings),
      listener: (context, state) {
        final settings = state.settings;
        if (settings != null && !identical(settings, _loadedSettings)) {
          setState(() => _populate(settings));
        }
        if (state.notice != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.notice!),
              backgroundColor:
              state.isError ? ColorManger.error : ColorManger.primary,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.settings == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: ColorManger.primary),
            ),
          );
        }
        if (state.settings == null) {
          return Center(
            child: Column(
              children: [
                Text(state.notice ?? 'تعذر تحميل الإعدادات العامة'),
                const SizedBox(height: 12),
                CustomButton(text: 'إعادة المحاولة', onPressed: _cubit.load),
              ],
            ),
          );
        }

        final enabled = _isEditing && !state.isSaving;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final cards = [
                    SalaryBasisCard(
                      salaryDaysCtrl: _salaryDaysCtrl,
                      enabled: enabled,
                    ),
                    WeeklyHolidaysCard(
                      days: _days,
                      selectedDays: _selectedDays,
                      onChanged: (days) => setState(() => _selectedDays = days),
                      enabled: enabled,
                    ),
                  ];
                  if (constraints.maxWidth < 850) {
                    return Column(
                      children: [
                        cards[0],
                        const SizedBox(height: 16),
                        cards[1],
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 20),
                      Expanded(child: cards[1]),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (!_isEditing)
                    CustomButton(
                      text: 'تعديل',
                      type: ButtonType.secondary,
                      onPressed: state.isSaving
                          ? null
                          : () => setState(() => _isEditing = true),
                    )
                  else ...[
                    CustomButton(
                      text: 'حفظ',
                      onPressed: state.isSaving ? null : _save,
                      isLoading: state.isSaving,
                    ),
                    CustomButton(
                      text: 'إلغاء',
                      type: ButtonType.secondary,
                      onPressed: state.isSaving ? null : _cancelEdit,
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}