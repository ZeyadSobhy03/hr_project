class AppFormat {
  AppFormat._();

  static String timeToDb(String ui) {
    final m = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
      caseSensitive: false,
    ).firstMatch(ui.trim());
    if (m == null) return ui;
    var h = int.parse(m[1]!);
    final pm = m[3]!.toUpperCase() == 'PM';
    if (h == 12) h = 0;
    if (pm) h += 12;
    return '${h.toString().padLeft(2, '0')}:${m[2]}:00';
  }

  static String timeFromDb(String db) {
    final p = db.split(':');
    var h = int.parse(p[0]);
    final pm = h >= 12;
    h = h % 12;
    if (h == 0) h = 12;
    return '${h.toString().padLeft(2, '0')}:${p[1]} ${pm ? 'PM' : 'AM'}';
  }

  static String dateToDb(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
