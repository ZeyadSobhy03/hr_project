import '../model/general_settings.dart';

abstract class GeneralSettingsRemoteDataSource {
  Future<GeneralSettingsData> getSettings();

  Future<GeneralSettingsData> updateSettings(GeneralSettingsData settings);
}
