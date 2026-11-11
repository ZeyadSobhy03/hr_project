import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';
import 'package:hr_project/presentation/main_layout/section/official_holidays/presentation/view/widgets/holiday_form.dart';
import 'package:hr_project/presentation/main_layout/section/official_holidays/presentation/view/widgets/holidays_table.dart';

import '../../../../../../core/utils/picker_utils.dart';
import '../../data/models/holiday.dart';
import '../view_model/official_holidays_view_model.dart';

class OfficialHolidays extends StatefulWidget {
  const OfficialHolidays({super.key});

  @override
  State<OfficialHolidays> createState() => _OfficialHolidaysState();
}

class _OfficialHolidaysState extends State<OfficialHolidays> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dateCtrl = TextEditingController(text: _today());

  OfficialHolidaysCubit get _cubit => context.read<OfficialHolidaysCubit>();

  static String _today() {
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/'
        '${now.day.toString().padLeft(2, '0')}/${now.year}';
  }

  DateTime? _parseDate(String text) {
    final parts = text.split('/');
    if (parts.length != 3) return null;
    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (month == null || day == null || year == null || year < 2008) {
      return null;
    }
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    if (!_formKey.currentState!.validate()) return;
    final date = _parseDate(_dateCtrl.text);
    if (date == null) return;
    await _cubit.addHoliday(
      Holiday(id: '', name: _nameCtrl.text.trim(), date: date),
    );
    if (!mounted || _cubit.state.isError) return;
    _nameCtrl.clear();
    _formKey.currentState!.reset();
  }

  Future<void> _edit(Holiday holiday) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: holiday.name);
    final dateCtrl = TextEditingController(
      text:
          '${holiday.date.month.toString().padLeft(2, '0')}/'
          '${holiday.date.day.toString().padLeft(2, '0')}/${holiday.date.year}',
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorManger.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title:  Text('تعديل الإجازة الرسمية', style: TextStyle(
          color: ColorManger.primary
        ),),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormedField(
                  label: 'الاسم',
                  controller: nameCtrl,
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormedField(
                  label: 'التاريخ',
                  controller: dateCtrl,
                  readOnly: true,
                  validator: (value) => _parseDate(value ?? '') == null
                      ? 'اختر تاريخًا صحيحًا من سنة 2008 أو بعدها'
                      : null,
                  onTap: () => pickDate(dialogContext, dateCtrl),
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child:  Text('إلغاء', style: TextStyle(
              color: ColorManger.black
            ),),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final date = _parseDate(dateCtrl.text);
              if (date == null) return;
              await _cubit.updateHoliday(
                Holiday(id: holiday.id, name: nameCtrl.text.trim(), date: date),
              );
              if (dialogContext.mounted && !_cubit.state.isError) {
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    nameCtrl.dispose();
    dateCtrl.dispose();
  }

  Future<void> _delete(Holiday holiday) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorManger.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title:  Text('حذف الإجازة', style: TextStyle(
          color: ColorManger.primary
        ),),
        content: Text('هل تريد حذف إجازة "${holiday.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text('إلغاء', style: TextStyle(
              color: ColorManger.black
            ),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _cubit.deleteHoliday(holiday.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OfficialHolidaysCubit, OfficialHolidaysState>(
      listenWhen: (previous, current) =>
          current.notice != null && current.notice != previous.notice,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.notice!),
            backgroundColor: state.isError
                ? ColorManger.error
                : ColorManger.primary,
          ),
        );
      },
      builder: (context, state) => AbsorbPointer(
        absorbing: state.isSaving,
        child: Opacity(
          opacity: state.isSaving ? 0.65 : 1,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorManger.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorManger.cardBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HolidayForm(
                  formKey: _formKey,
                  nameCtrl: _nameCtrl,
                  dateCtrl: _dateCtrl,
                  onAdd: _add,
                  isSaving: state.isSaving,
                ),
                const SizedBox(height: 20),
                if (state.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                        color: ColorManger.primary,
                      ),
                    ),
                  )
                else if (state.notice != null && state.holidays.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Text(state.notice!),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'إعادة المحاولة',
                          onPressed: _cubit.load,
                        ),
                      ],
                    ),
                  )
                else
                  HolidaysTable(
                    holidays: state.holidays,
                    onEdit: _edit,
                    onDelete: _delete,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
