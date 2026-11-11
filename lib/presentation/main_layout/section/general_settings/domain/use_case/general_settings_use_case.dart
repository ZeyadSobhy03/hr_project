import 'package:injectable/injectable.dart';

import '../../data/model/general_settings.dart';
import '../../data/repositories/general_settings_repositories.dart';

@injectable
class GeneralSettingsUseCase {
  GeneralSettingsUseCase({required this.repositories});

  final GeneralSettingsRepositories repositories;

  Future<GeneralSettingsData> getSettings() => repositories.getSettings();

  Future<GeneralSettingsData> updateSettings(GeneralSettingsData settings) =>
      repositories.updateSettings(settings);
}
