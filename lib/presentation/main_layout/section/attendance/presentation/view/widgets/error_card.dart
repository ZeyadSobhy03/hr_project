import 'package:flutter/material.dart';

import '../../../../../../../core/resources/colors/color_manger.dart';
import '../../../data/model/attendance_record.dart';

class ErrorCard extends StatelessWidget {

  final ImportError error;

  const ErrorCard({super.key, required this.error});


String _v(String? s) => (s == null || s.isEmpty) ? '—' : s;

Widget _item(String label, String? value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
      ),
      const SizedBox(height: 2),
      Text(
        _v(value),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: ColorManger.textPrimary,
        ),
      ),
    ],
  );
}

Widget _pair(Widget a, Widget b) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(child: a),
    const SizedBox(width: 10),
    Expanded(child: b),
  ],
);

@override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ColorManger.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: ColorManger.cardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الصف + الموظف
        Row(
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: ColorManger.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'صف ${error.rowNumber}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _v(error.employeeName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ColorManger.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _pair(_item('التاريخ', error.date), _item('الحالة', error.status)),
        const SizedBox(height: 8),
        _pair(
          _item('الحضور', error.checkIn),
          _item('الانصراف', error.checkOut),
        ),
        const SizedBox(height: 10),
        // سبب الخطأ
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorManger.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline,
                size: 16,
                color: ColorManger.error,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _v(error.message),
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorManger.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
