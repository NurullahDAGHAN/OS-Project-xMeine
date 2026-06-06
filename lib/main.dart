import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';

import 'data/auth_service.dart';
import 'data/game_progress_controller.dart';
import 'data/level_repository.dart';
import 'data/player_progress_summary.dart';
import 'data/player_streak.dart';
import 'data/player_streak_preferences.dart';
import 'data/progress_repository_provider.dart';
import 'game/network_game.dart';
import 'game/levels/level_data.dart';
import 'l10n/app_localizations.dart';
import 'ui/landscape_hint_hud.dart';
import 'ui/level_selection_panel.dart';
import 'ui/login_screen.dart';
import 'ui/player_progress_panel.dart';
import 'ui/success_panel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const NetworkCableDemoApp());
}

class NetworkCableDemoApp extends StatelessWidget {
  const NetworkCableDemoApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetQues',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A8F86),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F2EA),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<bool> _isLoggedInFuture;
  AppLanguage _language = AppLanguage.turkish;

  AppStrings get _strings => stringsFor(_language);

  @override
  void initState() {
    super.initState();
    _isLoggedInFuture = _checkLoginStatus();
  }

  Future<bool> _checkLoginStatus() async {
    final authService = AuthService();
    await authService.initialize();
    return authService.isLoggedIn();
  }

  void _handleLoginSuccess() {
    setState(() {
      _isLoggedInFuture = Future.value(true);
    });
  }

  void _handleLogout() {
    setState(() {
      _isLoggedInFuture = Future.value(false);
    });
  }

  void _handleLanguageChanged(AppLanguage language) {
    setState(() {
      _language = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedInFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final strings = _strings;

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('${strings.errorPrefix}: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.data == true) {
          return GameScreen(
            language: _language,
            onLanguageChanged: _handleLanguageChanged,
            onLogout: _handleLogout,
          );
        }

        return LoginScreen(
          strings: strings,
          language: _language,
          onLanguageChanged: _handleLanguageChanged,
          onLoginSuccess: _handleLoginSuccess,
        );
      },
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    required this.onLogout,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onLogout;
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameProgressController _progressController;
  late final Future<void> _initializeProgress;
  NetworkGame? _game;
  bool _restartQueued = false;
  late AppLanguage _language;
  String? _userEmail;
  final PlayerStreakPreferences _streakPreferences = PlayerStreakPreferences();
  PlayerStreak _streak = const PlayerStreak.empty();

  AppStrings get _strings => stringsFor(_language);

  @override
  void initState() {
    super.initState();
    _language = widget.language;
    _initializeProgress = _initializeGame();
  }

  Future<void> _initializeGame() async {
    final authService = AuthService();
    await authService.initialize();
    _userEmail = authService.getUserEmail();
    _streak = await _streakPreferences.load(_userEmail);

    final progressRepository = await createProgressRepository();
    _progressController = GameProgressController(
      levelRepository: DartLevelRepository(language: _language),
      progressRepository: progressRepository,
    );
    await _progressController.initialize();
    _game = NetworkGame(
      levels: _progressController.levels,
      language: _language,
      onLevelCompleted: _handleLevelCompleted,
      onHintUsed: (_) => _progressController.recordHint(),
      onAttemptRecorded: (_) => _progressController.recordAttempt(),
    );
    _game!.levelIndex.value = _progressController.selectedLevelIndex;
  }

  Future<void> _handleLevelCompleted(String _) async {
    await _progressController.completeSelectedLevel();
    final nextStreak = await _streakPreferences.recordLessonCompleted(
      _userEmail,
    );
    if (!mounted) {
      _streak = nextStreak;
      return;
    }
    setState(() {
      _streak = nextStreak;
    });
  }

  void _restart() {
    _queueGameAction(() => _game?.resetLevel());
  }

  Future<void> _nextLevel() async {
    await _queueGameAction(() async {
      await _progressController.selectNextLevel();
      _game?.setLevelIndex(_progressController.selectedLevelIndex);
    });
  }

  Future<void> _returnToStart() async {
    await _queueGameAction(() async {
      await _progressController.selectFirstLevel();
      _game?.setLevelIndex(_progressController.selectedLevelIndex);
    });
  }

  Future<void> _selectLevel(String levelId) async {
    await _queueGameAction(() async {
      await _progressController.selectLevel(levelId);
      _game?.setLevelIndex(_progressController.selectedLevelIndex);
    });
  }

  void _changeLanguage(AppLanguage language) {
    if (_language == language) {
      return;
    }

    final levels = localizedLevels(language);
    setState(() {
      _language = language;
      _progressController.replaceLevels(levels);
      _game?.setLanguage(language, levels);
    });
    widget.onLanguageChanged(language);
  }

  Future<void> _queueGameAction(FutureOr<void> Function() action) async {
    if (_restartQueued) {
      return;
    }

    _restartQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _restartQueued = false;
        return;
      }
      Future<void>.sync(action).whenComplete(() {
        _restartQueued = false;
      });
    });
  }

  Future<void> _logout() async {
    final authService = AuthService();
    await authService.initialize();
    await authService.logout();
    widget.onLogout();
  }

  void _closeApp() {
    unawaited(_confirmAndCloseApp());
  }

  Future<void> _confirmAndCloseApp() async {
    final strings = _strings;
    final shouldClose = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(strings.closeAppTitle),
            content: Text(strings.closeAppMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(strings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  strings.close,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (!mounted || shouldClose != true) {
      return;
    }

    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeProgress,
      builder: (context, snapshot) {
        final strings = _strings;
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('${strings.progressLoadError}: ${snapshot.error}'),
              ),
            ),
          );
        }

        final game = _game!;
        return AnimatedBuilder(
          animation: _progressController,
          builder: (context, _) {
            final profile = PlayerProgressSummary.fromProgress(
              snapshot: _progressController.snapshot!,
              totalLevels: _progressController.levels.length,
              userEmail: _userEmail,
              streak: _streak,
            );

            return Scaffold(
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isLandscape =
                        MediaQuery.of(context).orientation ==
                        Orientation.landscape;

                    if (isLandscape) {
                      return Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.25,
                            child: LevelSelectionPanel(
                              strings: strings,
                              language: _language,
                              levels: _progressController.levelViews,
                              selectedLevelId:
                                  _progressController.selectedLevel.id,
                              onSelect: _selectLevel,
                              onLogout: _logout,
                              onLanguageChanged: _changeLanguage,
                              isMainMenu: false,
                            ),
                          ),
                          Expanded(
                            child: _gamePlayArea(
                              game: game,
                              isLandscape: true,
                              profile: profile,
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        LevelSelectionPanel(
                          strings: strings,
                          language: _language,
                          levels: _progressController.levelViews,
                          selectedLevelId: _progressController.selectedLevel.id,
                          onSelect: _selectLevel,
                          onLogout: _logout,
                          onLanguageChanged: _changeLanguage,
                          isMainMenu: false,
                        ),
                        Expanded(
                          child: _gamePlayArea(
                            game: game,
                            isLandscape: false,
                            profile: profile,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _gamePlayArea({
    required NetworkGame game,
    required bool isLandscape,
    required PlayerProgressSummary profile,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxExpandedHudWidth =
            constraints.maxWidth <= 18
                ? constraints.maxWidth
                : constraints.maxWidth < 378
                ? constraints.maxWidth - 18
                : 360.0;

        return Stack(
          children: [
            Positioned.fill(
              child: GameWidget<NetworkGame>(
                game: game,
                overlayBuilderMap: {
                  SuccessPanel.overlayKey: (context, game) {
                    final isFinalLevel = !game.hasNextLevel;
                    return SuccessPanel(
                      strings: _strings,
                      isFinalLevel: isFinalLevel,
                      message: game.level.successMessage,
                      learningNote: game.level.learningNote,
                      nextStepMessage: game.level.nextStepMessage,
                      learningIcon: _levelIcon(game.level.taskType),
                      onRestart: _restart,
                      onNext: game.hasNextLevel ? _nextLevel : null,
                      onReturnToStart: isFinalLevel ? _returnToStart : null,
                      onCloseApp: isFinalLevel ? _closeApp : null,
                      onExit: isFinalLevel ? _logout : null,
                    );
                  },
                },
              ),
            ),
            Positioned(
              left: isLandscape ? 8 : 16,
              top: isLandscape ? 8 : 16,
              child: _profileButton(profile),
            ),
            Positioned(
              right: isLandscape ? 8 : 16,
              top: isLandscape ? 8 : 16,
              child: ValueListenableBuilder<int>(
                valueListenable: game.levelIndex,
                builder: (context, _, _) {
                  return ValueListenableBuilder<NetworkGameStatus>(
                    valueListenable: game.status,
                    builder: (context, status, _) {
                      if (status == NetworkGameStatus.completed) {
                        return const SizedBox.shrink();
                      }

                      return LandscapeHintHud(
                        strings: _strings,
                        levelKey: game.level.id,
                        title: game.level.title,
                        instruction: game.level.instruction,
                        feedback: game.level.learningNote,
                        status: status,
                        onRestart: _restart,
                        onHint: game.showHint,
                        onCloseApp: _closeApp,
                        maxExpandedWidth: maxExpandedHudWidth,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _profileButton(PlayerProgressSummary profile) {
    return Material(
      color: Colors.transparent,
      child: OutlinedButton.icon(
        onPressed: () => _openProfile(profile),
        icon: const Icon(Icons.person_outline, size: 18),
        label: Text(_strings.profile),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.94),
          foregroundColor: const Color(0xFF2D736A),
          side: const BorderSide(color: Color(0xFFCDE5DD)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  void _openProfile(PlayerProgressSummary profile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (context) =>
                PlayerProfileScreen(strings: _strings, profile: profile),
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  IconData _levelIcon(LevelTaskType taskType) {
    switch (taskType) {
      case LevelTaskType.ethernetConnection:
        return Icons.settings_ethernet;
      case LevelTaskType.ipAddressSelection:
        return Icons.numbers;
      case LevelTaskType.gatewaySelection:
        return Icons.route_outlined;
      case LevelTaskType.dnsSelection:
        return Icons.travel_explore_outlined;
      case LevelTaskType.subnetMaskSelection:
        return Icons.grid_on;
      case LevelTaskType.dhcpSelection:
        return Icons.settings_applications;
      case LevelTaskType.firewallSelection:
        return Icons.security;
    }
  }
}
