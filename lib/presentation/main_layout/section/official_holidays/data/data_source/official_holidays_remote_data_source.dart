import '../models/holiday.dart';

abstract class OfficialHolidaysRemoteDataSource {
  Future<List<Holiday>> getHolidays();

  Future<void> addHoliday(Holiday holiday);

  Future<void> updateHoliday(Holiday holiday);

  Future<void> deleteHoliday(String id);
}
