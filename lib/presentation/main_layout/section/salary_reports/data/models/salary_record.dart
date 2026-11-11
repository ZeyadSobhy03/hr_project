class SalaryRecord {
  const SalaryRecord({
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.baseSalary,
    required this.attendanceDays,
    required this.absenceDays,
    required this.overtimeHours,
    required this.deductionHours,
    required this.totalOvertime,
    required this.totalDeduction,
    required this.netSalary,
  });

  final String employeeId;
  final String employeeName;
  final String department;
  final num baseSalary;
  final int attendanceDays;
  final int absenceDays;
  final num overtimeHours;
  final num deductionHours;
  final num totalOvertime;
  final num totalDeduction;
  final num netSalary;

  factory SalaryRecord.fromJson(Map<String, dynamic> json) => SalaryRecord(
    employeeId: json['employee_id'] as String,
    employeeName: json['employee_name'] as String? ?? '',
    department: json['department_name'] as String? ?? '—',
    baseSalary: (json['base_salary'] as num?) ?? 0,
    attendanceDays: (json['attendance_days'] as num?)?.toInt() ?? 0,
    absenceDays: (json['absent_days'] as num?)?.toInt() ?? 0,
    overtimeHours: (json['overtime_hours'] as num?) ?? 0,
    deductionHours: (json['late_hours'] as num?) ?? 0,
    totalOvertime: (json['overtime_amount'] as num?) ?? 0,
    totalDeduction: (json['deduction_amount'] as num?) ?? 0,
    netSalary: (json['net_salary'] as num?) ?? 0,
  );
}

class SalaryReportPage {
  const SalaryReportPage({required this.items, required this.total});

  final List<SalaryRecord> items;
  final int total;
}
