class NationalIdInfo {
  const NationalIdInfo({required this.birthDate, required this.isMale});

  final DateTime birthDate;
  final bool isMale;
}

abstract final class NationalIdParser {

  static NationalIdInfo? parse(String id) {
    if (!RegExp(r'^\d{14}$').hasMatch(id)) return null;

    final century = switch (id[0]) {
      '2' => 1900,
      '3' => 2000,
      _ => null,
    };
    if (century == null) return null;

    final year = century + int.parse(id.substring(1, 3));
    final month = int.parse(id.substring(3, 5));
    final day = int.parse(id.substring(5, 7));

    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    return NationalIdInfo(birthDate: date, isMale: int.parse(id[12]).isOdd);
  }
}