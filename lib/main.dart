import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/network_game.dart';
import 'game/levels/level_data.dart';
import 'ui/game_hud.dart';
import 'ui/ip_task_panel.dart';
import 'ui/success_panel.dart';

void main() {
  runApp(const NetworkCableDemoApp());
}

class NetworkCableDemoApp extends StatelessWidget {
  const NetworkCableDemoApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Cable Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A8F86),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F2EA),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final NetworkGame _game;
  bool _restartQueued = false;

  void initState() {
    super.initState();
    _game = NetworkGame();
  }

  void _restart() {
    _queueGameAction(_game.resetLevel);
  }

  void _nextLevel() {
    _queueGameAction(_game.nextLevel);
  }

  void _queueGameAction(VoidCallback action) {
    if (_restartQueued) {
      return;
    }

    _restartQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _restartQueued = false;
        return;
      }
      action();
      _restartQueued = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GameWidget<NetworkGame>(
                game: _game,
                overlayBuilderMap: {
                  SuccessPanel.overlayKey: (context, game) {
                    return SuccessPanel(
                      message: game.level.successMessage,
                      learningNote: game.level.learningNote,
                      nextStepMessage: game.level.nextStepMessage,
                      learningIcon: _levelIcon(game.level.taskType),
                      onRestart: _restart,
                      onNext: game.hasNextLevel ? _nextLevel : null,
                    );
                  },
                },
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: ValueListenableBuilder<int>(
                valueListenable: _game.levelIndex,
                builder: (context, _, _) {
                  return ValueListenableBuilder<NetworkGameStatus>(
                    valueListenable: _game.status,
                    builder: (context, status, _) {
                      return GameHud(
                        title: _game.level.title,
                        instruction: _game.level.instruction,
                        feedback: _game.feedbackMessage.value,
                        status: status,
                        onRestart: _restart,
                        onHint: _game.showHint,
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: ValueListenableBuilder<int>(
                valueListenable: _game.levelIndex,
                builder: (context, _, _) {
                  return ValueListenableBuilder<NetworkGameStatus>(
                    valueListenable: _game.status,
                    builder: (context, status, _) {
                      final level = _game.level;
                      if (!level.usesOptionSelection ||
                          status == NetworkGameStatus.connected ||
                          status == NetworkGameStatus.completed) {
                        return const SizedBox.shrink();
                      }

                      final selectionGoal = level.selectionGoal;
                      return IpTaskPanel(
                        question: selectionGoal.question,
                        options: selectionGoal.options,
                        leadingIcon: _levelIcon(level.taskType),
                        optionIcon: _optionIcon(level.taskType),
                        onSelect: _game.chooseOption,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
    }
  }

  IconData _optionIcon(LevelTaskType taskType) {
    switch (taskType) {
      case LevelTaskType.gatewaySelection:
        return Icons.router_outlined;
      case LevelTaskType.dnsSelection:
        return Icons.dns_outlined;
      case LevelTaskType.ethernetConnection:
      case LevelTaskType.ipAddressSelection:
        return Icons.lan_outlined;
    }
  }
}
