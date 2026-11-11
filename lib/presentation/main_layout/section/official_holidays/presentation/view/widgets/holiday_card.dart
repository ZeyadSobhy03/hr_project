import 'package:flutter/material.dart';

import '../../../../../../../core/resources/colors/color_manger.dart';
import '../../../data/models/holiday.dart';

class HolidayCard extends StatelessWidget {
  const HolidayCard({
    super.key,
    required this.holiday,
    required this.onEdit,
    required this.onDelete,
  });

  final Holiday holiday;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String get _dateText =>
      '${holiday.date.day.toString().padLeft(2, '0')}/'
          '${holiday.date.month.toString().padLeft(2, '0')}/'
          '${holiday.date.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorManger.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorManger.rowDivider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ColorManger.tableHeader,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_outlined,
              color: ColorManger.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holiday.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: ColorManger.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _dateText,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'تعديل',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: ColorManger.primary,
          ),
          IconButton(
            tooltip: 'حذف',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red.shade700,
          ),
        ],
      ),
    );
  }
}