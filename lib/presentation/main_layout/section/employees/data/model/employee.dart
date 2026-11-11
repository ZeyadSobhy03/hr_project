class Employee {
  const Employee({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.nationality,
    required this.nationalId,
    required this.gender,
    required this.birthDate,
    required this.departmentId,
    required this.department,
    this.salary,
    required this.hireDate,
    required this.checkIn,
    required this.checkOut,
  });

  final String? id;
  final String name;
  final String address;
  final String phone;
  final String nationality;
  final String nationalId;
  final String? gender;
  final String birthDate;
  final String? departmentId;
  final String? department;
  final String? salary;
  final String hireDate;
  final String checkIn;
  final String checkOut;

  factory Employee.fromJson(Map<String, dynamic> j) {
    final dep = j['departments'] as Map<String, dynamic>?;
    return Employee(
      id: j['id'] as String,
      name: j['full_name'] as String,
      address: j['address'] as String,
      phone: j['phone'] as String,
      nationality: j['nationality'] as String,
      nationalId: j['national_id'] as String,
      gender: j['gender'] == 'male' ? 'ذكر' : 'أنثى',
      birthDate: j['birth_date'] as String,
      departmentId: j['department_id'] as String?,
      department: dep?['name'] as String?,
      salary: j['salary'] == null ? null : (j['salary'] as num).toString(),
      hireDate: j['hire_date'] as String,
      checkIn: _timeFromDb(j['check_in_time'] as String),
      checkOut: _timeFromDb(j['check_out_time'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name': name,
    'address': address,
    'phone': phone,
    'gender': gender == 'ذكر' ? 'male' : 'female',
    'nationality': nationality,
    'birth_date': birthDate,
    'national_id': nationalId,
    'hire_date': hireDate,
    if (salary != null && salary!.trim().isNotEmpty)
      'salary': num.tryParse(salary!),
    'check_in_time': _timeToDb(checkIn),
    'check_out_time': _timeToDb(checkOut),
    'department_id': departmentId,
  };

  Employee copyWith({String? salary}) => Employee(
    id: id,
    name: name,
    address: address,
    phone: phone,
    nationality: nationality,
    nationalId: nationalId,
    gender: gender,
    birthDate: birthDate,
    departmentId: departmentId,
    department: department,
    salary: salary ?? this.salary,
    hireDate: hireDate,
    checkIn: checkIn,
    checkOut: checkOut,
  );

  static String _timeToDb(String ui) {
    final m = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$', caseSensitive: false)
        .firstMatch(ui.trim());
    if (m == null) return ui;
    var h = int.parse(m[1]!);
    final pm = m[3]!.toUpperCase() == 'PM';
    if (h == 12) h = 0;
    if (pm) h += 12;
    return '${h.toString().padLeft(2, '0')}:${m[2]}:00';
  }

  static String _timeFromDb(String db) {
    final p = db.split(':');
    var h = int.parse(p[0]);
    final pm = h >= 12;
    h = h % 12;
    if (h == 0) h = 12;
    return '${h.toString().padLeft(2, '0')}:${p[1]} ${pm ? 'PM' : 'AM'}';
  }
}