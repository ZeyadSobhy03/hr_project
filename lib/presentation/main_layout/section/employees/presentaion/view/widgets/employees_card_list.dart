import 'package:flutter/material.dart';

import '../../../../../../../core/resources/colors/color_manger.dart';
import '../../../data/model/employee.dart';

class EmployeesCardList extends StatelessWidget {
  const EmployeesCardList({
    super.key,
    required this.employees,
    required this.onEdit,
    required this.onDelete,
    required this.showSalary,
  });

  final List<Employee> employees;
  final ValueChanged<Employee> onEdit;
  final ValueChanged<Employee> onDelete;
  final bool showSalary;

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('لا يوجد موظفين')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final e = employees[i];

        return Card(
          margin: EdgeInsets.zero,
          color: ColorManger.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _line(Icons.apartment, e.department ?? '-'),
                      _line(Icons.phone, e.phone),
                      if (showSalary && e.salary != null)
                        _line(Icons.payments_outlined, e.salary!),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => onEdit(e),
                      icon: const Icon(Icons.edit, color: ColorManger.primary),
                    ),
                    IconButton(
                      onPressed: () => onDelete(e),
                      icon:  Icon(Icons.delete, color: Colors.red.shade700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _line(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Row(
      children: [
        Icon(icon, size: 15, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    ),
  );
}
