import 'package:flutter/foundation.dart';

import '../game/levels/level_data.dart';
import 'level_repository.dart';
import 'progress_repository.dart';
import 'progress_state.dart';

class GameProgressController extends ChangeNotifier {
  GameProgressController({
    required LevelRepository levelRepository,
    required ProgressRepository progressRepository,
  }) : _levelRepository = levelRepository,
       _progressRepository = progressRepository;

  final LevelRepository _levelRepository;
  final ProgressRepository _progressRepository;

  late List<LevelData> levels;
  ProgressSnapshot? _snapshot;
  int _selectedLevelIndex = 0;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  int get selectedLevelIndex => _selectedLevelIndex;
  LevelData get selectedLevel => levels[_selectedLevelIndex];
  ProgressSnapshot? get snapshot => _snapshot;

  List<LevelProgressView> get levelViews {
    final progress = _snapshot;
    if (progress == null) {
      return const [];
    }
    return [
      for (final level in levels)
        LevelProgressView(
          level: level,
          progress: progress.progressFor(level.id),
        ),
    ];
  }

  bool get hasNextLevel => _selectedLevelIndex < levels.length - 1;

  Future<void> initialize() async {
    levels = _levelRepository.loadLevels();
    final loaded = await _progressRepository.loadProgress(_levelIds);
    _snapshot = loaded;
    _selectedLevelIndex = _initialLevelIndex(loaded.lastPlayedLevelId);
    _isLoading = false;
    notifyListeners();
  }

  void replaceLevels(List<LevelData> nextLevels) {
    levels = nextLevels;
    if (_selectedLevelIndex >= levels.length) {
      _selectedLevelIndex = levels.length - 1;
    }
    notifyListeners();
  }

  Future<void> selectLevel(String levelId) async {
    final progress = _snapshot?.progressFor(levelId);
    if (progress == null || !progress.unlocked) {
      return;
    }
    _selectedLevelIndex = levels.indexWhere((level) => level.id == levelId);
    _snapshot = await _progressRepository.setLastPlayed(_levelIds, levelId);
    notifyListeners();
  }

  Future<void> recordHint() async {
    _snapshot = await _progressRepository.recordHint(
      _levelIds,
      selectedLevel.id,
    );
    notifyListeners();
  }

  Future<void> recordAttempt() async {
    _snapshot = await _progressRepository.recordAttempt(
      _levelIds,
      selectedLevel.id,
    );
    notifyListeners();
  }

  Future<void> completeSelectedLevel() async {
    _snapshot = await _progressRepository.completeLevel(
      _levelIds,
      selectedLevel.id,
    );
    notifyListeners();
  }

  Future<void> selectNextLevel() async {
    if (!hasNextLevel) {
      return;
    }
    await selectLevel(levels[_selectedLevelIndex + 1].id);
  }

  Future<void> selectFirstLevel() async {
    await selectLevel(levels.first.id);
  }

  List<String> get _levelIds => [for (final level in levels) level.id];

  int _initialLevelIndex(String levelId) {
    final index = levels.indexWhere((level) => level.id == levelId);
    if (index >= 0) {
      final progress = _snapshot?.progressFor(levelId);
      if (progress?.unlocked ?? false) {
        return index;
      }
    }
    return 0;
  }
}
