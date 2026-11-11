import 'package:flutter/material.dart';

import '../../../../../../../core/cons/salary_constants.dart';
import '../../../../../../../core/resources/colors/color_manger.dart';
import '../../../../../../../core/resources/widgets/custom_button.dart';
import '../../../data/models/salary_record.dart';
import 'detail_item.dart';
import 'pair_row.dart';
import 'stat_tile.dart';

class SalaryMobileCard extends StatelessWidget {
  const SalaryMobileCard({
    super.key,
    required this.record,
    required this.onDetails,
  });

  final SalaryRecord record;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final r = record;
    final initial =
    r.employeeName.isNotEmpty ? r.employeeName.substring(0, 1) : '?';

    return Container(
      decoration: BoxDecoration(
        color: ColorManger.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorManger.rowDivider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header ----
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: ColorManger.tableHeader,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ColorManger.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.employeeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ColorManger.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManger.tableHeader,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        r.department,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: ColorManger.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: statTile(
                  icon: Icons.check_circle_outline,
                  label: "الحضور",
                  value: '${r.attendanceDays}',
                  color: kSalaryGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: statTile(
                  icon: Icons.cancel_outlined,
                  label: "الغياب",
                  value: '${r.absenceDays}',
                  color: kSalaryRed,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          pairRow(
            detailItem(kSalaryColumns[2].$1, fmtNum(r.baseSalary)),
            detailItem(kSalaryColumns[5].$1, fmtNum(r.overtimeHours)),
          ),
          const SizedBox(height: 12),
          pairRow(
            detailItem(kSalaryColumns[6].$1, fmtNum(r.deductionHours)),
            detailItem(
              kSalaryColumns[7].$1,
              fmtNum(r.totalOvertime),
              color: kSalaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          pairRow(
            detailItem(
              kSalaryColumns[8].$1,
              fmtNum(r.totalDeduction),
              color: kSalaryRed,
            ),
            const SizedBox.shrink(),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: ColorManger.tableHeader,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kSalaryColumns[9].$1,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ColorManger.textPrimary,
                  ),
                ),
                Text(
                  fmtNum(r.netSalary),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: ColorManger.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ---- Action ----
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'تفاصيل',
              type: ButtonType.table,
              onPressed: onDetails,
            ),
          ),
        ],
      ),
    );
  }
}