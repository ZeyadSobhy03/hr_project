import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/presentation/main_layout/section/users_permissions/presentation/view/widgets/user_card.dart';

import '../../../data/model/app_user.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({
    super.key,
    required this.users,
    required this.onEdit,
    required this.onDelete,
  });

  final List<AppUser> users;
  final ValueChanged<AppUser> onEdit;
  final ValueChanged<AppUser> onDelete;

  static const double _minWidth = 560;

  static const _headerStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: ColorManger.textPrimary,
  );

  static const _cellStyle = TextStyle(
    fontSize: 13,
    color: ColorManger.textPrimary,
  );
  static const double _mobileBreakpoint = 700;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _mobileBreakpoint) {
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserCard(
                user: user,
                onEdit: () => onEdit(user),
                onDelete: () => onDelete(user),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: users.length,
          );
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorManger.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorManger.cardBorder),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth < _minWidth
                  ? _minWidth
                  : constraints.maxWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      Container(
                        color: ColorManger.tableHeader,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('الاسم', style: _headerStyle),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text('اسم المستخدم', style: _headerStyle),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('المجموعة', style: _headerStyle),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text('العمليات', style: _headerStyle),
                            ),
                          ],
                        ),
                      ),
                      for (final u in users)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: ColorManger.rowDivider),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(u.fullName, style: _cellStyle),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(u.username, style: _cellStyle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(u.group, style: _cellStyle),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    CustomButton(
                                      text: 'تعديل',
                                      type: ButtonType.table,
                                      onPressed: () => onEdit(u),
                                    ),
                                    const SizedBox(width: 8),
                                    CustomButton(
                                      text: 'حذف',
                                      type: ButtonType.danger,
                                      onPressed: () => onDelete(u),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
