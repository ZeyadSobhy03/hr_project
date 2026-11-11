
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/toast.dart';
import 'package:hr_project/presentation/main_layout/section/employees/data/model/employee.dart';
import 'package:hr_project/presentation/main_layout/section/employees/presentaion/view/section/content.dart';
import 'package:hr_project/presentation/main_layout/section/employees/presentaion/view/section/retry.dart';

import '../../../../../../core/ex/text_ex.dart';
import '../view_model/employees_view_model.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EmployeesView();
  }
}

class _EmployeesView extends StatefulWidget {
  const _EmployeesView();

  @override
  State<_EmployeesView> createState() => _EmployeesViewState();
}

class _EmployeesViewState extends State<_EmployeesView> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _nationalityCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  final _hireDateCtrl = TextEditingController();
  final _checkInCtrl = TextEditingController(text: '09:00 AM');
  final _checkOutCtrl = TextEditingController(text: '04:00 PM');

  static const _defaultGender = 'ذكر';
  static const _genders = ['ذكر', 'أنثى'];

  String? _gender = _defaultGender;
  String? _department;

  String? _selectedId;

  bool _clearOnSuccess = false;

  EmployeesCubit get _cubit => context.read<EmployeesCubit>();

  bool get _canSalary => _cubit.data?.canViewSalary ?? false;



  String? _getBirthDateFromNationalId(String nationalId) {
    if (nationalId.length != 14) return null;

    if (!RegExp(r'^\d{14}$').hasMatch(nationalId)) {
      return null;
    }

    final centuryDigit = nationalId[0];

    int century;

    if (centuryDigit == '2') {
      century = 1900;
    } else if (centuryDigit == '3') {
      century = 2000;
    } else {
      return null;
    }

    final year = century + int.parse(nationalId.substring(1, 3));
    final month = int.parse(nationalId.substring(3, 5));
    final day = int.parse(nationalId.substring(5, 7));

    final date = DateTime(year, month, day);

    // Validate date
    if (date.year != year ||
        date.month != month ||
        date.day != day) {
      return null;
    }

    return '${month.toString().padLeft(2, '0')}/'
        '${day.toString().padLeft(2, '0')}/'
        '$year';
  }


  String? _getGenderFromNationalId(String nationalId) {
    if (nationalId.length != 14) return null;

    if (!RegExp(r'^\d{14}$').hasMatch(nationalId)) {
      return null;
    }

    // رقم 13 هو المسؤول عن تحديد النوع
    final genderDigit = int.parse(nationalId[12]);

    return genderDigit.isOdd ? 'ذكر' : 'أنثى';
  }


  void _onNationalIdChanged() {
    final nationalId = _nationalIdCtrl.text.trim();

    final birthDate = _getBirthDateFromNationalId(nationalId);

    final gender = _getGenderFromNationalId(nationalId);

    if (birthDate != null) {
      _birthDateCtrl.text = birthDate;
    } else {
      _birthDateCtrl.clear();
    }

    final newGender = gender ?? _defaultGender;

    if (_gender != newGender && mounted) {
      setState(() {
        _gender = newGender;
      });
    }
  }


  @override
  void initState() {
    super.initState();

    _cubit.init();

    _nationalIdCtrl.addListener(_onNationalIdChanged);
  }


  @override
  void dispose() {
    _nationalIdCtrl.removeListener(_onNationalIdChanged);

    for (final c in [
      _nameCtrl,
      _addressCtrl,
      _phoneCtrl,
      _nationalityCtrl,
      _nationalIdCtrl,
      _birthDateCtrl,
      _salaryCtrl,
      _hireDateCtrl,
      _checkInCtrl,
      _checkOutCtrl,
    ]) {
      c.dispose();
    }

    super.dispose();
  }



  String? _departmentId(String? name) {
    final deps = _cubit.data?.departments ?? const [];

    for (final d in deps) {
      if (d.name == name) return d.id;
    }

    return null;
  }


  Employee _fromForm({String? id}) => Employee(
    id: id,
    name: _nameCtrl.text.trim(),
    address: _addressCtrl.text.trim(),
    phone: _phoneCtrl.text.trim(),
    nationality: _nationalityCtrl.text.trim(),
    nationalId: _nationalIdCtrl.text.trim(),
    gender: _gender,
    birthDate:_birthDateCtrl.text.toDb,
    departmentId: _departmentId(_department),
    department: _department,
    salary: _canSalary ? _salaryCtrl.text.trim() : null,
    hireDate: _hireDateCtrl.text.toDb,
    checkIn: _checkInCtrl.text,
    checkOut: _checkOutCtrl.text,
  );


  void _fillForm(Employee e) {
    _nationalIdCtrl.removeListener(_onNationalIdChanged);

    _nameCtrl.text = e.name;
    _addressCtrl.text = e.address;
    _phoneCtrl.text = e.phone;
    _nationalityCtrl.text = e.nationality;
    _nationalIdCtrl.text = e.nationalId;
    _birthDateCtrl.text = e.birthDate.toUi;
    _salaryCtrl.text = e.salary ?? '';
    _hireDateCtrl.text = e.hireDate.toUi;
    _checkInCtrl.text = e.checkIn;
    _checkOutCtrl.text = e.checkOut;

    _gender = e.gender;
    _department = e.department;

    _nationalIdCtrl.addListener(_onNationalIdChanged);
  }


  void _clearForm() {
    _nationalIdCtrl.removeListener(_onNationalIdChanged);

    for (final c in [
      _nameCtrl,
      _addressCtrl,
      _phoneCtrl,
      _nationalityCtrl,
      _nationalIdCtrl,
      _birthDateCtrl,
      _salaryCtrl,
      _hireDateCtrl,
    ]) {
      c.clear();
    }

    _nationalIdCtrl.addListener(_onNationalIdChanged);

    _checkInCtrl.text = '09:00 AM';
    _checkOutCtrl.text = '04:00 PM';

    _gender = _defaultGender;

    final deps = _cubit.data?.departments ?? const [];

    _department = deps.isEmpty ? null : deps.first.name;

    _selectedId = null;

    _formKey.currentState?.reset();
  }



  bool _formIsValid() {
    if (!_formKey.currentState!.validate()) return false;

    final error = ''.extraValidation(
      birthDate: _birthDateCtrl.text,
      hireDate: _hireDateCtrl.text,
      nationalId: _nationalIdCtrl.text,
      salary: _salaryCtrl.text,
      canSalary: _canSalary,
      departmentId: _departmentId(_department),
    );

    if (error != null) {
      toast(error, isError: true, context: context);
      return false;
    }

    return true;
  }

  void _save() {
    if (!_formIsValid()) return;

    _clearOnSuccess = true;

    _cubit.addEmployee(_fromForm());
  }


  void _update() {
    if (_selectedId == null || !_formIsValid()) return;

    _clearOnSuccess = true;

    _cubit.updateEmployee(_fromForm(id: _selectedId));
  }


  Future<void> _delete(Employee e) async {
    final id = e.id;

    if (id == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: ColorManger.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('حذف الموظف'),
          content: Text('هل أنت متأكد من حذف ${e.name}؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'إلغاء',
                style: TextStyle(color: ColorManger.primary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'حذف',
                style: TextStyle(color: ColorManger.error),
              ),
            ),
          ],
        ),
      ),
    );

    if (ok != true || !mounted) return;

    _clearOnSuccess = _selectedId == id;

    _cubit.deleteEmployee(id);
  }


  void _startEdit(Employee e) {
    setState(() {
      _fillForm(e);
      _selectedId = e.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeesCubit, EmployeesState>(
      listenWhen: (p, c) =>
      c is EmployeesActionSuccess || c is EmployeesFailure,

      buildWhen: (p, c) =>
      c is EmployeesLoading ||
          c is EmployeesLoaded ||
          (c is EmployeesFailure &&
              context.read<EmployeesCubit>().data == null),

      listener: (context, state) {
        if (state is EmployeesActionSuccess) {
          toast(state.message, context: context);

          if (_clearOnSuccess) {
            setState(_clearForm);
          }

          _clearOnSuccess = false;
        } else if (state is EmployeesFailure) {
          toast(state.message, isError: true, context: context);

          _clearOnSuccess = false;
        }
      },

      builder: (context, state) {
        if (state is EmployeesLoaded) return _content(state);

        if (state is EmployeesFailure) {
          return retry(state.message, _cubit.init);
        }

        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(
            child: CircularProgressIndicator(
              color: ColorManger.primary,
            ),
          ),
        );
      },
    );
  }


  Widget _content(EmployeesLoaded state) {
    final departmentNames = state.departments
        .map((department) => department.name)
        .toList();

    if (_department != null &&
        !departmentNames.contains(_department)) {
      _department = null;
    }

    _department ??= departmentNames.isEmpty
        ? null
        : departmentNames.first;

    final isEditing = _selectedId != null;

    return EmployeesContent(
      formKey: _formKey,

      nameCtrl: _nameCtrl,
      phoneCtrl: _phoneCtrl,
      addressCtrl: _addressCtrl,
      nationalityCtrl: _nationalityCtrl,
      nationalIdCtrl: _nationalIdCtrl,
      birthDateCtrl: _birthDateCtrl,

      // Gender
      gender: _gender,
      genders: _genders,
      onGenderChanged: (value) {
        setState(() {
          _gender = value;
        });
      },

      department: _department,
      departmentNames: departmentNames,
      onDepartmentChanged: (value) {
        setState(() {
          _department = value;
        });
      },

      hireDateCtrl: _hireDateCtrl,
      salaryCtrl: _salaryCtrl,
      checkInCtrl: _checkInCtrl,
      checkOutCtrl: _checkOutCtrl,

      canSalary: _canSalary,

      saving: state is EmployeesLoading,
      isEditing: isEditing,

      onSave: _save,
      onUpdate: _update,
      onDeleteSelected: () {
        final index = state.employees.indexWhere(
              (employee) => employee.id == _selectedId,
        );

        if (index != -1) {
          _delete(state.employees[index]);
        }
      },

      employees: state.employees,
      onEdit: _startEdit,
      onDelete: _delete,
    );
  }}