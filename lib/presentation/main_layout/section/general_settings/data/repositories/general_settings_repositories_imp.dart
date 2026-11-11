import 'package:injectable/injectable.dart';

import '../data_source/general_settings_remote_data_source.dart';
import '../model/general_settings.dart';
import 'general_settings_repositories.dart';

@LazySingleton(as: GeneralSettingsRepositories)
class GeneralSettingsRepositoriesImp implements GeneralSettingsRepositories {
  GeneralSettingsRepositoriesImp({required this.remoteDataSource});

  final GeneralSettingsRemoteDataSource remoteDataSource;

  @override
  Future<GeneralSettingsData> getSettings() => remoteDataSource.getSettings();

  @override
  Future<GeneralSettingsData> updateSettings(GeneralSettingsData settings) =>
      remoteDataSource.updateSettings(settings);
}
