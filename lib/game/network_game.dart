import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../ui/success_panel.dart';
import 'components/cable_component.dart';
import 'components/scene_props.dart';
import 'components/success_sparkle_component.dart';
import 'components/tile_room_component.dart';
import 'levels/level_data.dart';
import 'levels/levels.dart';

enum NetworkGameStatus { ready, needsRetry, connected, completed }

class NetworkGame extends FlameGame with DragCallbacks {
  static final Vector2 worldSize = Vector2(900, 620);

  final ValueNotifier<int> levelIndex = ValueNotifier(0);
  final ValueNotifier<NetworkGameStatus> status = ValueNotifier(
    NetworkGameStatus.ready,
  );
  final ValueNotifier<String> feedbackMessage = ValueNotifier(
    levels.first.dialogue,
  );

  late ModemComponent modem;
  late ComputerComponent computer;
  late CableComponent cable;
  late CharacterComponent character;
  late DialogueBubbleComponent dialogueBubble;

  bool connected = false;
  int _completionToken = 0;

  LevelData get level => levels[levelIndex.value];
  bool get hasNextLevel => levelIndex.value < levels.length - 1;

  Color backgroundColor() => const Color(0xFFF5F2EA);
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
      onWrongDrop: showHint,
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
        position: level.connectionGoal.target.toVector2(),
      ),
    );
    final token = ++_completionToken;
    unawaited(_showSuccessAfterFeedback(token));
  }

  void showHint() {
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

  void chooseOption(String option) {
    if (!level.usesOptionSelection ||
        status.value == NetworkGameStatus.completed) {
      return;
    }

    final selectionGoal = level.selectionGoal;
    if (option != selectionGoal.correctOption) {
      showHint();
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
    overlays.add(SuccessPanel.overlayKey);
  }

  void _prepareSelectionLevel() {
    connected = false;
    cable.forceConnected();
    modem.setConnected();
    computer.setConnected();
    feedbackMessage.value = level.dialogue;
    status.value = NetworkGameStatus.ready;
  }

  void _fitCameraToScreen(Vector2 screenSize) {
    if (screenSize.x <= 0 || screenSize.y <= 0) {
      return;
    }

    final zoom = math.min(
      screenSize.x / worldSize.x,
      screenSize.y / worldSize.y,
    );
    final visibleWorldSize = screenSize / zoom;
    final extraWorldSpace = visibleWorldSize - worldSize;

    camera.viewfinder.zoom = zoom;
    camera.viewfinder.position = Vector2(
      -math.max(0, extraWorldSpace.x) / 2,
      -math.max(0, extraWorldSpace.y) / 2,
    );
  }
}
