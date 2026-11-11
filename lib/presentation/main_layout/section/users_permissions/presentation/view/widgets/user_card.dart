import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';

import '../../../data/model/app_user.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  final AppUser user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final initial =
    user.fullName.isNotEmpty ? user.fullName.substring(0, 1) : '?';

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      user.fullName,
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
                        user.group,
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

          const SizedBox(height: 14),

          // ---- Username ----
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: ColorManger.tableHeader.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'اسم المستخدم',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user.username,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ColorManger.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ---- Actions ----
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'تعديل',
                  type: ButtonType.table,
                  onPressed: onEdit,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'حذف',
                  type: ButtonType.danger,
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}