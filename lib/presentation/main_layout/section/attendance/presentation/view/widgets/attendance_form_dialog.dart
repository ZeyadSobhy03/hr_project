import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';
import 'package:hr_project/core/resources/widgets/drop_down_field.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_record.dart';

import '../../../../../../../core/utils/picker_utils.dart';

class AttendanceFormDialog extends StatefulWidget {
  const AttendanceFormDialog({super.key, required this.employees, this.record});

  final List<EmployeeOption> employees;

  final AttendanceRecord? record;

  @override
  State<AttendanceFormDialog> createState() => _AttendanceFormDialogState();
}

class _AttendanceFormDialogState extends State<AttendanceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dateCtrl = TextEditingController();
  final _checkInCtrl = TextEditingController(text: '09:00 AM');
  final _checkOutCtrl = TextEditingController(text: '04:00 PM');

  String? _employeeId;

  bool get _isEdit => widget.record != null;

  @override
  void initState() {
    super.initState();
    final r = widget.record;
    if (r != null) {
      _employeeId = r.employeeId;
      _dateCtrl.text =   r.date;
      _checkInCtrl.text = _timeToUi(r.checkIn);
      _checkOutCtrl.text = r.checkOut?? '04:00 PM';
    } else {
      _dateCtrl.text = _dateToUi(DateTime.now());
    }
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _checkInCtrl.dispose();
    _checkOutCtrl.dispose();
    super.dispose();
  }


  static String _dateToUi(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/'
          '${d.day.toString().padLeft(2, '0')}/${d.year}';

  static DateTime? _dateFromUi(String s) {
    final p = s.split('/');
    if (p.length != 3) return null;
    final m = int.tryParse(p[0]);
    final d = int.tryParse(p[1]);
    final y = int.tryParse(p[2]);
    if (m == null || d == null || y == null) return null;
    return DateTime(y, m, d);
  }

  static String _timeToDb(String ui) {
    final m = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$', caseSensitive: false)
        .firstMatch(ui.trim());
    if (m == null) return ui;
    var h = int.parse(m[1]!);
    final pm = m[3]!.toUpperCase() == 'PM';
    if (h == 12) h = 0;
    if (pm) h += 12;
    return '${h.toString().padLeft(2, '0')}:${m[2]}:00';
  }

  static String _timeToUi(String db) {
    final p = db.split(':');
    if (p.length < 2) return db;
    var h = int.parse(p[0]);
    final pm = h >= 12;
    h = h % 12;
    if (h == 0) h = 12;
    return '${h.toString().padLeft(2, '0')}:${p[1]} ${pm ? 'PM' : 'AM'}';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final date = _dateFromUi(_dateCtrl.text);
    if (date == null) return;

    Navigator.pop(
      context,
      AttendanceInput(
        employeeId: _employeeId!,
        date: date,
        checkIn: _timeToDb(_checkInCtrl.text),
        checkOut: _timeToDb(_checkOutCtrl.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final names = [for (final e in widget.employees) e.name];
    final selectedName = widget.employees
        .where((e) => e.id == _employeeId)
        .map((e) => e.name)
        .firstOrNull;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: ColorManger.white,
        title: Text(_isEdit ? 'تعديل سجل حضور' : 'إضافة سجل حضور'),
        content: SizedBox(
          width: 380,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropDownField(
                    label: 'الموظف',
                    hint: 'اختر موظف',
                    value: selectedName,
                    items: names,
                    validator: (v) => v == null ? 'مطلوب' : null,
                    onChanged: (name) => setState(() {
                      _employeeId = widget.employees
                          .firstWhere((e) => e.name == name)
                          .id;
                    }),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormedField(
                    label: 'التاريخ',
                    controller: _dateCtrl,
                    readOnly: true,
                    onTap: () => pickDate(context, _dateCtrl),
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormedField(
                    label: 'وقت الحضور',
                    controller: _checkInCtrl,
                    readOnly: true,
                    onTap: () => pickTime(context, _checkInCtrl),
                    suffixIcon: const Icon(Icons.access_time, size: 18),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormedField(
                    label: 'وقت الانصراف',
                    controller: _checkOutCtrl,
                    readOnly: true,
                    onTap: () => pickTime(context, _checkOutCtrl),
                    suffixIcon: const Icon(Icons.access_time, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          CustomButton(
            text: 'إلغاء',
            type: ButtonType.secondary,
            onPressed: () => Navigator.pop(context),
          ),
          CustomButton(text: 'حفظ', onPressed: _submit),
        ],
      ),
    );
  }
}