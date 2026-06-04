import 'package:flame/components.dart';

enum LevelObjectType { computer, modem, cable, character, dialogueBubble }

enum LevelTaskType {
  ethernetConnection,
  ipAddressSelection,
  gatewaySelection,
  dnsSelection,
  subnetMaskSelection,
  dhcpSelection,
  firewallSelection,
}

enum LevelSceneTheme { home, gateway, dns, office, dataCenter, security }

class LevelPoint {
  const LevelPoint(this.x, this.y);

  final double x;
  final double y;

  Vector2 toVector2() => Vector2(x, y);
}

class LevelObjectData {
  const LevelObjectData({
    required this.id,
    required this.type,
    required this.position,
    this.text,
  });

  final String id;
  final LevelObjectType type;
  final LevelPoint position;
  final String? text;
}

class CableConnectionData {
  const CableConnectionData({
    required this.cableId,
    required this.fromObjectId,
    required this.toObjectId,
    required this.start,
    required this.restEnd,
    required this.target,
  });

  final String cableId;
  final String fromObjectId;
  final String toObjectId;
  final LevelPoint start;
  final LevelPoint restEnd;
  final LevelPoint target;
}

class LevelGoalData {
  const LevelGoalData({this.connection, this.selection});

  final CableConnectionData? connection;
  final SelectionGoalData? selection;
}

class SelectionGoalData {
  const SelectionGoalData({
    required this.question,
    required this.options,
    required this.correctOption,
  });

  final String question;
  final List<String> options;
  final String correctOption;
}

class LevelData {
  const LevelData({
    required this.id,
    required this.taskType,
    required this.title,
    required this.sceneTheme,
    required this.instruction,
    required this.dialogue,
    required this.hintMessage,
    required this.connectedMessage,
    required this.successMessage,
    required this.learningNote,
    required this.nextStepMessage,
    required this.objects,
    required this.goal,
  });

  final String id;
  final LevelTaskType taskType;
  final String title;
  final LevelSceneTheme sceneTheme;
  final String instruction;
  final String dialogue;
  final String hintMessage;
  final String connectedMessage;
  final String successMessage;
  final String learningNote;
  final String nextStepMessage;
  final List<LevelObjectData> objects;
  final LevelGoalData goal;

  bool get usesOptionSelection {
    return taskType != LevelTaskType.ethernetConnection;
  }

  LevelObjectData objectByType(LevelObjectType type) {
    return objects.firstWhere((object) => object.type == type);
  }

  CableConnectionData get connectionGoal {
    final connection = goal.connection;
    if (connection == null) {
      throw StateError('Level $id does not define a cable connection goal.');
    }
    return connection;
  }

  SelectionGoalData get selectionGoal {
    final selection = goal.selection;
    if (selection == null) {
      throw StateError('Level $id does not define a selection goal.');
    }
    return selection;
  }
}
