import '../game/levels/level_data.dart';
import '../l10n/app_localizations.dart';

abstract class LevelRepository {
  List<LevelData> loadLevels();
}

class DartLevelRepository implements LevelRepository {
  const DartLevelRepository({this.language = AppLanguage.turkish});

  final AppLanguage language;

  @override
  List<LevelData> loadLevels() => localizedLevels(language);
}
