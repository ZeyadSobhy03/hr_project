import 'package:injectable/injectable.dart';

import '../data_source/official_holidays_remote_data_source.dart';
import '../models/holiday.dart';
import 'official_holidays_repositories.dart';

@LazySingleton(as: OfficialHolidaysRepositories)
class OfficialHolidaysRepositoriesImp implements OfficialHolidaysRepositories {
  OfficialHolidaysRepositoriesImp({required this.remoteDataSource});

  final OfficialHolidaysRemoteDataSource remoteDataSource;

  @override
  Future<List<Holiday>> getHolidays() => remoteDataSource.getHolidays();

  @override
  Future<void> addHoliday(Holiday holiday) =>
      remoteDataSource.addHoliday(holiday);

  @override
  Future<void> updateHoliday(Holiday holiday) =>
      remoteDataSource.updateHoliday(holiday);

  @override
  Future<void> deleteHoliday(String id) => remoteDataSource.deleteHoliday(id);
}
