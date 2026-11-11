import '../model/general_settings.dart';

abstract class GeneralSettingsRepositories {
  Future<GeneralSettingsData> getSettings();

  Future<GeneralSettingsData> updateSettings(GeneralSettingsData settings);
}
