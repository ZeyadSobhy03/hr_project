import 'package:flutter/material.dart';

import '../../../../../../../core/resources/widgets/custom_button.dart';
import '../../../data/model/employee.dart';
import '../widgets/basic_info_card.dart';
import '../widgets/employees_table.dart';
import '../widgets/work_info_card.dart';

class EmployeesContent extends StatelessWidget {
  const EmployeesContent({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.nationalityCtrl,
    required this.nationalIdCtrl,
    required this.birthDateCtrl,
    required this.gender,
    required this.genders,
    required this.onGenderChanged,
    required this.department,
    required this.departmentNames,
    required this.onDepartmentChanged,
    required this.hireDateCtrl,
    required this.salaryCtrl,
    required this.checkInCtrl,
    required this.checkOutCtrl,
    required this.canSalary,
    required this.saving,
    required this.isEditing,
    required this.onSave,
    required this.onUpdate,
    required this.onDeleteSelected,
    required this.employees,
    required this.onEdit,
    required this.onDelete,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController nationalityCtrl;
  final TextEditingController nationalIdCtrl;
  final TextEditingController birthDateCtrl;

  final String? gender;
  final List<String> genders;
  final ValueChanged<String?> onGenderChanged;

  final String? department;
  final List<String> departmentNames;
  final ValueChanged<String?> onDepartmentChanged;

  final TextEditingController hireDateCtrl;
  final TextEditingController salaryCtrl;
  final TextEditingController checkInCtrl;
  final TextEditingController checkOutCtrl;

  final bool canSalary;
  final bool saving;
  final bool isEditing;

  final VoidCallback onSave;
  final VoidCallback onUpdate;
  final VoidCallback onDeleteSelected;

  final List<Employee> employees;
  final ValueChanged<Employee> onEdit;
  final ValueChanged<Employee> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BasicInfoCard(
                      nameCtrl: nameCtrl,
                      addressCtrl: addressCtrl,
                      phoneCtrl: phoneCtrl,
                      nationalityCtrl: nationalityCtrl,
                      nationalIdCtrl: nationalIdCtrl,
                      birthDateCtrl: birthDateCtrl,
                      gender: gender,
                      genders: genders,
                      onGenderChanged: onGenderChanged,
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: WorkInfoCard(
                      department: department,
                      departments: departmentNames,
                      onDepartmentChanged: onDepartmentChanged,
                      hireDateCtrl: hireDateCtrl,
                      salaryCtrl: salaryCtrl,
                      checkInCtrl: checkInCtrl,
                      checkOutCtrl: checkOutCtrl,
                      showSalary: canSalary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  CustomButton(
                    text: 'حفظ',
                    isLoading: saving && !isEditing,
                    onPressed: (saving || isEditing) ? null : onSave,
                  ),

                  const SizedBox(width: 12),

                  CustomButton(
                    text: 'تعديل',
                    type: ButtonType.secondary,
                    isLoading: saving && isEditing,
                    onPressed: (saving || !isEditing) ? null : onUpdate,
                  ),

                  const SizedBox(width: 12),

                  CustomButton(
                    text: 'حذف',
                    type: ButtonType.danger,
                    onPressed: (saving || !isEditing)
                        ? null
                        : onDeleteSelected,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        EmployeesTable(
          employees: employees,
          onEdit: onEdit,
          onDelete: onDelete,
          showSalary: canSalary,
        ),
      ],
    );
  }
}