class Department {
  const Department({required this.id, required this.name});
  final String id;
  final String name;

  factory Department.fromJson(Map<String, dynamic> j) =>
      Department(id: j['id'] as String, name: j['name'] as String);
}