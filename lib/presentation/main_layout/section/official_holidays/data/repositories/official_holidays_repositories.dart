import '../models/holiday.dart';

abstract class OfficialHolidaysRepositories {
  Future<List<Holiday>> getHolidays();

  Future<void> addHoliday(Holiday holiday);

  Future<void> updateHoliday(Holiday holiday);

  Future<void> deleteHoliday(String id);
}
