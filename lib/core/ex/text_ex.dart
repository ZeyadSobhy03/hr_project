extension TextEx on String {

  String? get emailValidator {
    if (isEmpty) return 'البريد الإلكتروني مطلوب';

    final emailRegex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(this)) {
      return 'البريد الإلكتروني غير صالح';
    }

    return null;
  }

  String? get passwordValidator {
    if (isEmpty) return 'كلمة المرور مطلوبة';
    return null;
  }

  String? extraValidation({
    required String birthDate,
    required String hireDate,
    required String nationalId,
    required String salary,
    required bool canSalary,
    required String? departmentId,
  }) {

    if (birthDate.trim().isEmpty) {
      return 'من فضلك اختر تاريخ الميلاد';
    }

    if (hireDate.trim().isEmpty) {
      return 'من فضلك اختر تاريخ التعاقد';
    }

    if (nationalId.trim().length != 14) {
      return 'الرقم القومي يجب أن يكون 14 رقم';
    }

    if (canSalary && num.tryParse(salary.trim()) == null) {
      return 'من فضلك ادخل راتب صحيح';
    }

    if (departmentId == null) {
      return 'من فضلك اختر القسم';
    }

    return null;
  }

  String? get phoneValidator {
    if (isEmpty) return 'رقم الهاتف مطلوب';
    if (!RegExp(r'^\d{11}$').hasMatch(this)) {
      return 'رقم الهاتف يجب أن يكون 11 رقم';
    }
    return null;
  }
/*
// String _toDb(String ui) {
  //   final p = ui.split('/');
  //
  //   if (p.length != 3) return ui;
  //
  //   return '${p[2]}-${p[0].padLeft(2, '0')}-${p[1].padLeft(2, '0')}';
  // }
  //
  // String _toUi(String db) {
  //   final p = db.split('-');
  //
  //   if (p.length != 3) return db;
  //
  //   return '${p[1]}/${p[2]}/${p[0]}';
  // }

 */
String get toDb {
    final p = split('/');

    if (p.length != 3) return this;

    return '${p[2]}-${p[0].padLeft(2, '0')}-${p[1].padLeft(2, '0')}';
  }
  String get toUi {
    final p = split('-');

    if (p.length != 3) return this;

    return '${p[1]}/${p[2]}/${p[0]}';
  }
}