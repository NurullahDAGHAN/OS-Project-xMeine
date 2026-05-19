import 'level_data.dart';

const level2 = LevelData(
  id: 'ip_address',
  taskType: LevelTaskType.ipAddressSelection,
  title: 'IP Adresi',
  sceneTheme: LevelSceneTheme.home,
  instruction: 'Bilgisayar icin dogru IP adresini sec',
  dialogue:
      'Kablo baglandi. Simdi bilgisayarin ayni agda konusabilmesi icin uygun bir IP adresi secmeliyiz.',
  hintMessage:
      'Modem 192.168.1.x aginda. Bilgisayar da 192.168.1 ile baslayan bos bir adres almali.',
  connectedMessage:
      'Dogru IP secildi. Bilgisayar artik modemle ayni yerel agda.',
  successMessage:
      'Harika! IP adresi, cihazlarin ag uzerinde birbirini bulmasini saglar.',
  learningNote:
      'IP adresi, cihazlarin ayni yerel ag uzerinde birbirini bulmasini saglar.',
  nextStepMessage:
      'Bir sonraki bolumde yerel agdan internete cikis icin gateway sececegiz.',
  objects: [
    LevelObjectData(
      id: 'computer',
      type: LevelObjectType.computer,
      position: LevelPoint(215, 330),
    ),
    LevelObjectData(
      id: 'modem',
      type: LevelObjectType.modem,
      position: LevelPoint(650, 326),
    ),
    LevelObjectData(
      id: 'ethernet_cable',
      type: LevelObjectType.cable,
      position: LevelPoint(462, 458),
    ),
    LevelObjectData(
      id: 'helper_character',
      type: LevelObjectType.character,
      position: LevelPoint(470, 286),
    ),
    LevelObjectData(
      id: 'ip_dialogue',
      type: LevelObjectType.dialogueBubble,
      position: LevelPoint(300, 150),
    ),
  ],
  goal: LevelGoalData(
    connection: CableConnectionData(
      cableId: 'ethernet_cable',
      fromObjectId: 'computer',
      toObjectId: 'modem',
      start: LevelPoint(355, 408),
      restEnd: LevelPoint(637, 348),
      target: LevelPoint(637, 348),
    ),
    ipSelection: IpSelectionData(
      question: 'Bu ag icin en uygun IP hangisi?',
      options: ['192.168.1.24', '10.0.0.9', '172.16.4.2'],
      correctOption: '192.168.1.24',
    ),
  ),
);
