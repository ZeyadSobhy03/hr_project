class GeneralSettingsData {
  const GeneralSettingsData({
    required this.weeklyOffDays,
    this.salaryDaysBasis = 30,
  });

  /// 0 = الأحد ... 5 = الجمعة، 6 = السبت
  final List<int> weeklyOffDays;
  final int salaryDaysBasis;

  factory GeneralSettingsData.fromJson(Map<String, dynamic> j) =>
      GeneralSettingsData(
        weeklyOffDays: (j['weekly_off_days'] as List)
            .map((e) => (e as num).toInt())
            .toList(),
        salaryDaysBasis: (j['salary_days_basis'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
    'weekly_off_days': weeklyOffDays,
    'salary_days_basis': salaryDaysBasis,
  };

  GeneralSettingsData copyWith({
    List<int>? weeklyOffDays,
    int? salaryDaysBasis,
  }) =>
      GeneralSettingsData(
        weeklyOffDays: weeklyOffDays ?? this.weeklyOffDays,
        salaryDaysBasis: salaryDaysBasis ?? this.salaryDaysBasis,
      );
}