import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_exception.dart';

AppException map(Object e) {
  debugPrint('PostgrestException: ${e.toString()}');

  if (e is AppException) return e;

  if (e is PostgrestException) {
    final msg = '${e.message} ${e.details ?? ''}';

    switch (e.code) {

      case '23505':

        if (msg.contains('national_id')) {
          return const AppException('الرقم القومي مسجل لموظف آخر');
        }
        if (msg.contains('employees_full_name')) {
          return const AppException('اسم الموظف مسجل من قبل');
        }
        return const AppException('هذه البيانات مسجلة من قبل');

      case '23514':
        if (msg.contains('emp_phone_11_digits')) {
          return const AppException('من فضلك ادخل رقم تليفون صحيح');
        }
        if (msg.contains('emp_national_id_14')) {
          return const AppException('يجب ألا يقل الرقم القومي عن 14 رقم');
        }
        if (msg.contains('emp_hire_after_2008') ||
            msg.contains('emp_hire_after_birth')) {
          return const AppException('من فضلك ادخل تاريخ تعاقد صحيح');
        }
        if (msg.contains('emp_salary_positive')) {
          return const AppException('من فضلك ادخل راتب صحيح');
        }
        if (msg.contains('emp_times_valid')) {
          return const AppException('موعد الانصراف يجب أن يكون بعد موعد الحضور');
        }
        return AppException(e.message);

      case '23502':
        return const AppException('هذا الحقل مطلوب');
      case '23503':
        return const AppException('القسم المختار غير موجود');
      case '22007':
      case '22008':
      case '22P02':
        return const AppException('من فضلك تأكد من صحة التواريخ والأرقام');
      case '42501': // RLS أو guard_salary
        return AppException(
          e.message.contains('الراتب')
              ? e.message
              : 'ليس لديك صلاحية لتنفيذ هذه العملية',
        );
      case 'PGRST116': // 0 rows
        return const AppException('السجل غير موجود أو ليس لديك صلاحية تعديله');
    }
    return const AppException('حدث خطأ في الخادم، حاول مرة أخرى');
  }

  if (e is AuthException) {
    return const AppException('انتهت الجلسة، سجّل الدخول مرة أخرى');
  }
  return const AppException('تعذر الاتصال بالخادم، تأكد من الإنترنت');
}
