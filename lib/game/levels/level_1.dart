import 'level_data.dart';

const level1 = LevelData(
  id: 'ethernet_connection',
  taskType: LevelTaskType.ethernetConnection,
  title: 'Ethernet Baglantisi',
  sceneTheme: LevelSceneTheme.home,
  instruction: 'Bilgisayari modeme bagla',
  dialogue:
      'Bilgisayar internete cikamiyor. Once Ethernet kablosunu modeme baglayalim.',
  hintMessage:
      'Kablo ucunu modem uzerindeki koyu renkli Ethernet portuna birakmalisin.',
  connectedMessage:
      'Fiziksel baglanti kuruldu. Modem ve bilgisayar artik ayni agda konusabilir.',
  successMessage:
      'Basarili! Bilgisayar artik modeme bagli. Bir sonraki adimda IP adresini ogrenecegiz.',
  learningNote:
      'Ethernet kablosu, bilgisayar ile modem arasinda fiziksel ag baglantisi kurar.',
  nextStepMessage:
      'Bir sonraki bolumde bilgisayarin ag uzerinde IP adresi almasini ele alacagiz.',
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
      position: LevelPoint(450, 456),
    ),
    LevelObjectData(
      id: 'helper_character',
      type: LevelObjectType.character,
      position: LevelPoint(470, 286),
    ),
    LevelObjectData(
      id: 'intro_dialogue',
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
      restEnd: LevelPoint(462, 458),
      target: LevelPoint(637, 348),
    ),
  ),
);
