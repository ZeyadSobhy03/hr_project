
import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

Future<bool> showDeleteGroupDialog({
  required BuildContext context,
  required String name,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: ColorManger.white,
      title:  Text('حذف المجموعة',style:  TextStyle(
        color: ColorManger.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),),
      content: Text(
        'هل تريد حذف مجموعة "$name"؟ '
            'لا يمكن حذفها إذا كان بها مستخدمون.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child:  Text('إلغاء', style: TextStyle(color: ColorManger.primary),),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child:  Text('حذف', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  return result == true;
}
