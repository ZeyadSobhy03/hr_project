import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';
import 'package:hr_project/presentation/main_layout/section/users_permissions/presentation/view/section/group_permissions_panel/group_permissions_panel.dart';
import 'package:hr_project/presentation/main_layout/section/users_permissions/presentation/view/widgets/add_user_card.dart';
import 'package:hr_project/presentation/main_layout/section/users_permissions/presentation/view/widgets/users_table.dart';

import '../../data/model/app_user.dart';
import '../view_model/users_permissions_view_model.dart';

class UsersPermissions extends StatefulWidget {
  const UsersPermissions({super.key});

  @override
  State<UsersPermissions> createState() => _UsersPermissionsState();
}

class _UsersPermissionsState extends State<UsersPermissions> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _group;

  UsersPermissionsCubit get _cubit => context.read<UsersPermissionsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final groupId = _cubit.state.groupIdForName(_group ?? '');
    if (groupId == null) return;

    await _cubit.createUser(
      fullName: _fullNameCtrl.text,
      username: _usernameCtrl.text,
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
      groupId: groupId,
    );
    if (!mounted || _cubit.state.isError) return;

    _fullNameCtrl.clear();
    _usernameCtrl.clear();
    _emailCtrl.clear();
    _passwordCtrl.clear();
    _formKey.currentState!.reset();
    setState(() => _group = null);
  }

  Future<void> _edit(AppUser user) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: user.fullName);
    final usernameCtrl = TextEditingController(text: user.username);
    final passwordCtrl = TextEditingController();
    var groupName = _cubit.state.groupNameForId(user.groupId) ?? user.group;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: ColorManger.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('تعديل المستخدم'),
          content: SizedBox(
            width: 440,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormedField(
                    label: 'الاسم بالكامل',
                    controller: nameCtrl,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormedField(
                    label: 'اسم المستخدم',
                    controller: usernameCtrl,
                    validator: (v) =>
                        v == null ||
                            !RegExp(r'^[A-Za-z0-9_.-]{3,30}$')
                                .hasMatch(v.trim())
                        ? '3-30 حرفًا إنجليزيًا أو رقمًا أو (_ . -)'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    dropdownColor: ColorManger.white,
                    decoration: const InputDecoration(labelText: 'المجموعة'),
                    items: [
                      for (final name in _cubit.state.groupNames)
                        DropdownMenuItem(value: name, child: Text(name)),
                    ],
                    onChanged: (value) =>
                        setDialogState(() => groupName = value!),
                    validator: (value) => value == null ? 'اختر مجموعة' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormedField(
                    label: 'كلمة مرور جديدة (اختياري)',
                    controller: passwordCtrl,
                    isPassword: true,
                    validator: (v) => v != null && v.isNotEmpty && v.length < 8
                        ? 'كلمة المرور يجب ألا تقل عن 8 أحرف'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child:  Text('إلغاء', style: TextStyle(color: ColorManger.black)),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final groupId = _cubit.state.groupIdForName(groupName);
                if (groupId == null) return;
                await _cubit.updateUser(
                  id: user.id.toString(),
                  fullName: nameCtrl.text,
                  username: usernameCtrl.text,
                  groupId: groupId,
                );
                if (!mounted || _cubit.state.isError) return;
                if (passwordCtrl.text.isNotEmpty) {
                  await _cubit.setPassword(
                    id: user.id.toString(),
                    password: passwordCtrl.text,
                  );
                  if (!mounted || _cubit.state.isError) return;
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
    nameCtrl.dispose();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
  }

  Future<void> _delete(AppUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: ColorManger.white,
        title: const Text('حذف المستخدم'),
        content: Text('هل تريد حذف حساب ${user.fullName} نهائيًا؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text('إلغاء', style: TextStyle(color: ColorManger.primary),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
    );
    if (confirmed == true) await _cubit.deleteUser(user.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersPermissionsCubit, UsersPermissionsState>(
      listenWhen: (previous, current) =>
          current.notice != null && current.notice != previous.notice,
      listener: (context, state) {
        debugPrint('UsersPermissionsCubit state changed: ${state.notice}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.notice!),
            backgroundColor: state.isError
                ? ColorManger.error
                : ColorManger.primary,
          ),
        );
      },
      builder: (context, state) => AbsorbPointer(
        absorbing: state.isSaving,
        child: Opacity(
          opacity: state.isSaving ? 0.65 : 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.canManageGroups) ...[
                GroupPermissionsPanel(
                  groups: state.groups,
                  onLoadPermissions: _cubit.getGroupPermissions,
                  onSave: _cubit.saveGroup,
                  onDelete: _cubit.deleteGroup,
                  isSaving: state.isSaving,
                ),
                const SizedBox(height: 20),
              ],
              AddUserCard(
                formKey: _formKey,
                fullNameCtrl: _fullNameCtrl,
                usernameCtrl: _usernameCtrl,
                emailCtrl: _emailCtrl,
                passwordCtrl: _passwordCtrl,
                groups: state.groupNames,
                group: _group,
                onGroupChanged: (value) => setState(() => _group = value),
                onSave: _save,
              ),
              const SizedBox(height: 20),
              if (state.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                      color: ColorManger.primary,
                    ),
                  ),
                )
              else if (state.notice != null && state.users.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Text(state.notice!),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'إعادة المحاولة',
                        onPressed: _cubit.load,
                      ),
                    ],
                  ),
                )
              else
                UsersTable(
                  users: state.users,
                  onEdit: _edit,
                  onDelete: _delete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
