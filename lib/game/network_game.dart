import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../ui/success_panel.dart';
import 'components/cable_component.dart';
import 'components/scene_props.dart';
import 'components/selection_card_component.dart';
import 'components/success_sparkle_component.dart';
import 'components/tile_room_component.dart';
import 'levels/level_data.dart';
import '../l10n/app_localizations.dart';

enum NetworkGameStatus { ready, needsRetry, connected, completed }

class NetworkGame extends FlameGame with DragCallbacks {
  NetworkGame({
    required this.levels,
    required this.language,
    this.onLevelCompleted,
    this.onHintUsed,
    this.onAttemptRecorded,
  }) : levelIndex = ValueNotifier(0),
       feedbackMessage = ValueNotifier(levels.first.dialogue);

  static final Vector2 worldSize = Vector2(900, 620);

  List<LevelData> levels;
  AppLanguage language;
  final Future<void> Function(String levelId)? onLevelCompleted;
  final Future<void> Function(String levelId)? onHintUsed;
  final Future<void> Function(String levelId)? onAttemptRecorded;

  final ValueNotifier<int> levelIndex;
  final ValueNotifier<NetworkGameStatus> status = ValueNotifier(
    NetworkGameStatus.ready,
  );
  final ValueNotifier<String> feedbackMessage;

  late ModemComponent modem;
  late ComputerComponent computer;
  late CableComponent cable;
  late CharacterComponent character;
  late DialogueBubbleComponent dialogueBubble;
  SelectionDropZoneComponent? selectionDropZone;

  bool connected = false;
  int _completionToken = 0;
  Vector2? _selectionSuccessPosition;
  final math.Random _random = math.Random();

  LevelData get level => levels[levelIndex.value];
  bool get hasNextLevel => levelIndex.value < levels.length - 1;

  Color backgroundColor() {
    return switch (level.sceneTheme) {
      LevelSceneTheme.home => const Color(0xFFF5F2EA),
      LevelSceneTheme.gateway => const Color(0xFFEFF6F7),
      LevelSceneTheme.dns => const Color(0xFFF0F2FA),
      LevelSceneTheme.office => const Color(0xFFF6EFD8),
      LevelSceneTheme.dataCenter => const Color(0xFFEAF2F5),
      LevelSceneTheme.security => const Color(0xFFF5EAEA),
    };
  }

  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    _fitCameraToScreen(size);
    _buildLevel();
  }

  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _fitCameraToScreen(size);
  }

  void _buildLevel() {
    overlays.remove(SuccessPanel.overlayKey);
    world.removeAll(world.children.toList());
    connected = false;
    selectionDropZone = null;
    _selectionSuccessPosition = null;
    _completionToken++;
    feedbackMessage.value = level.dialogue;
    status.value = NetworkGameStatus.ready;

    world.add(TileRoomComponent(theme: level.sceneTheme));

    final computerData = level.objectByType(LevelObjectType.computer);
    final modemData = level.objectByType(LevelObjectType.modem);
    final characterData = level.objectByType(LevelObjectType.character);
    final dialogueData = level.objectByType(LevelObjectType.dialogueBubble);
    final connection = level.connectionGoal;

    computer = ComputerComponent(position: computerData.position.toVector2());
    modem = ModemComponent(position: modemData.position.toVector2());
    cable = CableComponent(
      start: connection.start.toVector2(),
      restEnd: connection.restEnd.toVector2(),
      target: connection.target.toVector2(),
      onConnected: completeConnection,
      onNearTargetChanged: (isNear) => modem.setPortHighlighted(isNear),
      onWrongDrop: _handleWrongDrop,
    );
    character = CharacterComponent(
      position: characterData.position.toVector2(),
    );
    dialogueBubble = DialogueBubbleComponent(
      position: dialogueData.position.toVector2(),
      text: dialogueData.text ?? level.dialogue,
    );

    world.addAll([computer, modem, cable, character, dialogueBubble]);

    if (level.usesOptionSelection) {
      _prepareSelectionLevel();
    }
  }

  void completeConnection() {
    if (connected) {
      return;
    }
    connected = true;
    feedbackMessage.value = level.connectedMessage;
    status.value = NetworkGameStatus.connected;
    dialogueBubble.setText(level.connectedMessage);
    modem.setConnected();
    computer.setConnected();
    world.add(
      SuccessSparkleComponent(
        position:
            _selectionSuccessPosition ??
            level.connectionGoal.target.toVector2(),
      ),
    );
    final token = ++_completionToken;
    unawaited(_showSuccessAfterFeedback(token));
  }

  void showHint() {
    unawaited(onHintUsed?.call(level.id));
    _showHint();
  }

  void _showHint() {
    if (status.value == NetworkGameStatus.completed) {
      return;
    }
    feedbackMessage.value = level.hintMessage;
    status.value = NetworkGameStatus.needsRetry;
    dialogueBubble.setText(level.hintMessage);
    character.showHintPulse();
  }

  void resetLevel() {
    _buildLevel();
  }

  void nextLevel() {
    if (!hasNextLevel) {
      resetLevel();
      return;
    }
    levelIndex.value++;
    _buildLevel();
  }

  void setLevelIndex(int index) {
    if (index < 0 || index >= levels.length) {
      return;
    }
    levelIndex.value = index;
    _buildLevel();
  }

  void setLanguage(AppLanguage nextLanguage, List<LevelData> nextLevels) {
    language = nextLanguage;
    levels = nextLevels;
    if (levelIndex.value >= levels.length) {
      levelIndex.value = levels.length - 1;
    }
    _buildLevel();
  }

  void chooseOption(String option) {
    if (!level.usesOptionSelection ||
        status.value == NetworkGameStatus.completed) {
      return;
    }

    final selectionGoal = level.selectionGoal;
    if (option != selectionGoal.correctOption) {
      unawaited(onAttemptRecorded?.call(level.id));
      _showHint();
      return;
    }

    completeConnection();
  }

  Future<void> _showSuccessAfterFeedback(int token) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (token != _completionToken || !connected) {
      return;
    }
    status.value = NetworkGameStatus.completed;
    await onLevelCompleted?.call(level.id);
    if (token != _completionToken || !connected) {
      return;
    }
    overlays.add(SuccessPanel.overlayKey);
  }

  void _handleWrongDrop() {
    unawaited(onAttemptRecorded?.call(level.id));
    _showHint();
  }

  void _prepareSelectionLevel() {
    connected = false;
    cable.forceConnected();
    modem.setConnected();
    computer.setConnected();
    feedbackMessage.value = level.dialogue;
    status.value = NetworkGameStatus.ready;

    final selectionGoal = level.selectionGoal;
    final dropTarget = _selectionDropTarget();
    _selectionSuccessPosition = dropTarget.clone();
    final dropZone = SelectionDropZoneComponent(
      center: dropTarget,
      label: _dropZoneLabel(level.taskType),
    );
    selectionDropZone = dropZone;
    world.add(dropZone);

    final options = selectionGoal.options.toList()..shuffle(_random);
    final spacing = options.length <= 1 ? 0.0 : 230.0;
    final startX = 450 - ((options.length - 1) * spacing / 2);
    for (var index = 0; index < options.length; index++) {
      final option = options[index];
      world.add(
        SelectionCardComponent(
          label: option,
          correct: option == selectionGoal.correctOption,
          target: dropTarget,
          restPosition: Vector2(startX + index * spacing, 542),
          icon: _selectionIcon(level.taskType),
          onAccepted: () => chooseOption(option),
          onWrongDrop: _handleWrongDrop,
          onNearTargetChanged: dropZone.setHighlighted,
        ),
      );
    }
  }

  Vector2 _selectionDropTarget() {
    return computer.position + Vector2(-8, -86);
  }

  String _dropZoneLabel(LevelTaskType taskType) {
    final strings = stringsFor(language);
    return switch (taskType) {
      LevelTaskType.ipAddressSelection => strings.dropIpCard,
      LevelTaskType.gatewaySelection => strings.dropGatewayCard,
      LevelTaskType.dnsSelection => strings.dropDnsCard,
      LevelTaskType.subnetMaskSelection => strings.dropMaskCard,
      LevelTaskType.dhcpSelection => strings.dropDhcpCard,
      LevelTaskType.firewallSelection => strings.dropRuleCard,
      LevelTaskType.ethernetConnection => strings.connectCable,
    };
  }

  IconData _selectionIcon(LevelTaskType taskType) {
    return switch (taskType) {
      LevelTaskType.ipAddressSelection => Icons.numbers,
      LevelTaskType.gatewaySelection => Icons.route_outlined,
      LevelTaskType.dnsSelection => Icons.travel_explore_outlined,
      LevelTaskType.subnetMaskSelection => Icons.grid_on,
      LevelTaskType.dhcpSelection => Icons.settings_applications,
      LevelTaskType.firewallSelection => Icons.security,
      LevelTaskType.ethernetConnection => Icons.settings_ethernet,
    };
  }

  void _fitCameraToScreen(Vector2 screenSize) {
    if (screenSize.x <= 0 || screenSize.y <= 0) {
      return;
    }

    final isPortrait = screenSize.y > screenSize.x;
    final targetWorldWidth = isPortrait ? 760.0 : worldSize.x;
    final zoom = math.min(
      screenSize.x / targetWorldWidth,
      screenSize.y / worldSize.y,
    );
    final visibleWorldSize = screenSize / zoom;

    camera.viewfinder.zoom = zoom;
    camera.viewfinder.position = (worldSize - visibleWorldSize) / 2;
  }
}
