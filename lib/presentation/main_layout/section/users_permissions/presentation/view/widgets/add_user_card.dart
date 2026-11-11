import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';
import 'package:hr_project/core/resources/widgets/drop_down_field.dart';

class AddUserCard extends StatelessWidget {
  const AddUserCard({
    super.key,
    required this.formKey,
    required this.fullNameCtrl,
    required this.usernameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.groups,
    required this.group,
    required this.onGroupChanged,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameCtrl;
  final TextEditingController usernameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final List<String> groups;
  final String? group;
  final ValueChanged<String?> onGroupChanged;
  final VoidCallback onSave;

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'مطلوب';
    return null;
  }

  String? _username(String? v) {
    if (v == null || !RegExp(r'^[A-Za-z0-9_.-]{3,30}$').hasMatch(v.trim())) {
      return '3-30 حرفًا إنجليزيًا أو رقمًا أو (_ . -)';
    }
    return null;
  }

  String? _email(String? v) {
    if (v == null || v.trim().isEmpty) return 'مطلوب';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
      return 'من فضلك ادخل بريد إلكتروني صحيح';
    }
    return null;
  }

  String? _password(String? v) {
    if (v == null || v.isEmpty) return 'مطلوب';
    if (v.length < 8) return 'كلمة المرور يجب ألا تقل عن 8 أحرف';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManger.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManger.cardBorder),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إضافة مستخدم جديد',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: ColorManger.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextFormedField(
                    label: 'الاسم بالكامل',
                    controller: fullNameCtrl,
                    validator: _required,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormedField(
                    label: 'اسم المستخدم',
                    controller: usernameCtrl,
                    validator: _username,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormedField(
                    label: 'البريد الإلكتروني',
                    controller: emailCtrl,
                    hint: 'Example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: _email,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormedField(
                    label: 'كلمة المرور',
                    controller: passwordCtrl,
                    isPassword: true,
                    validator: _password,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 222,
              child: DropDownField(
                label: 'الصلاحيات (المجموعة)',
                hint: 'اختر مجموعة',
                value: group,
                items: groups,
                onChanged: onGroupChanged,
                validator: (v) => v == null ? 'مطلوب' : null,
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(text: 'حفظ', onPressed: onSave),
          ],
        ),
      ),
    );
  }
}
