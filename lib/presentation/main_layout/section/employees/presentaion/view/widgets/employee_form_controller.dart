import 'package:flutter/material.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/model/employee.dart';

class EmployeeFormController {
  static const defaultCheckIn = '09:00 AM';
  static const defaultCheckOut = '04:00 PM';

  final name = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController();
  final nationality = TextEditingController();
  final nationalId = TextEditingController();
  final birthDate = TextEditingController();
  final salary = TextEditingController();
  final hireDate = TextEditingController();
  final checkIn = TextEditingController(text: defaultCheckIn);
  final checkOut = TextEditingController(text: defaultCheckOut);

  List<TextEditingController> get _all => [
    name, address, phone, nationality, nationalId,
    birthDate, salary, hireDate, checkIn, checkOut,
  ];

  Employee toEmployee({
    String? id,
    required String? gender,
    required String? department,
    required String? departmentId,
    required bool canSalary,
  }) =>
      Employee(
        id: id,
        name: name.text.trim(),
        address: address.text.trim(),
        phone: phone.text.trim(),
        nationality: nationality.text.trim(),
        nationalId: nationalId.text.trim(),
        gender: gender,
        birthDate: _toDb(birthDate.text),
        departmentId: departmentId,
        department: department,
        salary: canSalary ? salary.text.trim() : null,
        hireDate: _toDb(hireDate.text),
        checkIn: checkIn.text,
        checkOut: checkOut.text,
      );

  void fill(Employee e) {
    name.text = e.name;
    address.text = e.address;
    phone.text = e.phone;
    nationality.text = e.nationality;
    nationalId.text = e.nationalId;
    birthDate.text = _toUi(e.birthDate);
    salary.text = e.salary ?? '';
    hireDate.text = _toUi(e.hireDate);
    checkIn.text = e.checkIn;
    checkOut.text = e.checkOut;
  }

  void clear() {
    for (final c in [
      name, address, phone, nationality, nationalId,
      birthDate, salary, hireDate,
    ]) {
      c.clear();
    }
    checkIn.text = defaultCheckIn;
    checkOut.text = defaultCheckOut;
  }

  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
  }

  static String formatUiDate(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/'
          '${d.day.toString().padLeft(2, '0')}/${d.year}';

  static String _toDb(String ui) {
    final p = ui.split('/');
    if (p.length != 3) return ui;
    return '${p[2]}-${p[0].padLeft(2, '0')}-${p[1].padLeft(2, '0')}';
  }

  static String _toUi(String db) {
    final p = db.split('-');
    if (p.length != 3) return db;
    return '${p[1]}/${p[2]}/${p[0]}';
  }
}