import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/widgets/error_card.dart';

import '../../../data/model/attendance_record.dart';

abstract final class AttendanceDialogs {
  static Future<bool> confirm(
      BuildContext context, {
        required String title,
        required String message,
        required String confirmText,
        bool danger = false,
      }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => _RtlAlert(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: danger ? ColorManger.error : ColorManger.primary,
              ),
            ),
          ),
        ],
      ),
    );
    return ok == true;
  }

  static Future<void> importSummary(
      BuildContext context, {
        required int inserted,
        required int deleted,
        required List<ImportError> errors,
      }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) {
        final screenWidth = MediaQuery.sizeOf(ctx).width;
        final isMobile = screenWidth < 600;

        return _RtlAlert(
          title: const Text('نتيجة الاستيراد'),
          insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 40,
            vertical: 24,
          ),
          content: SizedBox(
            width: isMobile ? double.maxFinite : math.min(900, screenWidth - 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تم تسجيل حضور: $inserted'),
                Text('تم حذف سجل حضور (غياب): $deleted'),
                Text('صفوف فيها أخطاء: ${errors.length}'),
                if (errors.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Flexible(
                    child: isMobile
                        ? _ErrorsList(errors: errors)
                        : _ErrorsTable(errors: errors),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:  Text('تم', style: TextStyle(
                color: ColorManger.primary
              ),),
            ),
          ],
        );
      },
    );
  }

}

const _flexes = <int>[1, 3, 2, 2, 2, 2, 6];
const _headers = <String>[
  'الصف',
  'الموظف',
  'التاريخ',
  'الحالة',
  'الحضور',
  'الانصراف',
  'سبب الخطأ',
];

class _ErrorsTable extends StatelessWidget {
  const _ErrorsTable({required this.errors});

  final List<ImportError> errors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorManger.cardBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              color: ColorManger.card,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  for (var i = 0; i < _headers.length; i++)
                    _cell(
                      _headers[i],
                      _flexes[i],
                      const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: ColorManger.cardBorder),
            // Body
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: errors.length,
                separatorBuilder: (_, _) =>
                const Divider(height: 1, color: ColorManger.cardBorder),
                itemBuilder: (_, i) => _ErrorRow(error: errors[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _ErrorsList extends StatelessWidget {
  const _ErrorsList({required this.errors});

  final List<ImportError> errors;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: errors.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) => ErrorCard(error: errors[i]),
    );
  }
}

class _ErrorRow extends StatelessWidget {
  const _ErrorRow({required this.error});

  final ImportError error;

  @override
  Widget build(BuildContext context) {
    const normal = TextStyle(fontSize: 13);
    const bad = TextStyle(fontSize: 13, color: ColorManger.error);

    final values = <String?>[
      '${error.rowNumber}',
      error.employeeName,
      error.date,
      error.status,
      error.checkIn,
      error.checkOut,
      error.message,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < values.length; i++)
            _cell(values[i], _flexes[i], i == values.length - 1 ? bad : normal),
        ],
      ),
    );
  }
}

Widget _cell(String? text, int flex, TextStyle style) {
  final t = (text == null || text.isEmpty) ? '—' : text;
  return Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Text(t, style: style),
    ),
  );
}

class _RtlAlert extends StatelessWidget {
  const _RtlAlert({
    required this.title,
    required this.content,
    required this.actions,
    this.insetPadding =
    const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
  });

  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final EdgeInsets insetPadding;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: ColorManger.white,
        insetPadding: insetPadding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}