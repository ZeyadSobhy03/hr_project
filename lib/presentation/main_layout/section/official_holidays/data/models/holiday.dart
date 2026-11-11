class Holiday {
  const Holiday({required this.id, required this.name, required this.date});

  final String id;
  final String name;
  final DateTime date;

  factory Holiday.fromJson(Map<String, dynamic> json) {
    final rawDate = DateTime.parse(json['holiday_date'] as String);
    return Holiday(
      id: json['id'] as String,
      name: json['name'] as String,
      date: DateTime(rawDate.year, rawDate.month, rawDate.day),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name.trim(),
    'holiday_date':
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}',
  };

  static const _weekdays = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  String get displayDate =>
      '${_weekdays[date.weekday - 1]} ${date.month}/${date.day}/${date.year}';
}
