import 'package:injectable/injectable.dart';

import '../../data/models/holiday.dart';
import '../../data/repositories/official_holidays_repositories.dart';

@injectable
class OfficialHolidaysUseCase {
  OfficialHolidaysUseCase({required this.repositories});

  final OfficialHolidaysRepositories repositories;

  Future<List<Holiday>> getHolidays() => repositories.getHolidays();

  Future<void> addHoliday(Holiday holiday) => repositories.addHoliday(holiday);

  Future<void> updateHoliday(Holiday holiday) =>
      repositories.updateHoliday(holiday);

  Future<void> deleteHoliday(String id) => repositories.deleteHoliday(id);
}
