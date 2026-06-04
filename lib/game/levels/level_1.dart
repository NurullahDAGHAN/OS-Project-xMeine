import 'level_data.dart';

const level1 = LevelData(
  id: 'ethernet_connection',
  taskType: LevelTaskType.ethernetConnection,
  title: 'Ethernet Bağlantısı',
  sceneTheme: LevelSceneTheme.home,
  instruction: 'Bilgisayarı modeme bağla',
  dialogue:
      'Bilgisayar internete çıkamıyor. Önce Ethernet kablosunu modeme bağlayalım.',
  hintMessage:
      'Kablo ucunu modem üzerindeki koyu renkli Ethernet portuna bırakmalısın.',
  connectedMessage:
      'Fiziksel bağlantı kuruldu. Modem ve bilgisayar artık aynı ağda konuşabilir.',
  successMessage:
      'Başarılı! Bilgisayar artık modeme bağlı. Bir sonraki adımda IP adresini öğreneceğiz.',
  learningNote:
      'Ethernet kablosu, bilgisayar ile modem arasında fiziksel ağ bağlantısı kurar.',
  nextStepMessage:
      'Bir sonraki bölümde bilgisayarın ağ üzerinde IP adresi almasını ele alacağız.',
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
