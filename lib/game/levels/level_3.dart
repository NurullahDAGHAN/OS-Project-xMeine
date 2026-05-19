import 'level_data.dart';

const level3 = LevelData(
  id: 'default_gateway',
  taskType: LevelTaskType.gatewaySelection,
  title: 'Varsayilan Ag Gecidi',
  sceneTheme: LevelSceneTheme.gateway,
  instruction: 'Internete cikis icin dogru gecidi sec',
  dialogue:
      'IP adresi tamam. Simdi bilgisayar yerel ag disina cikmak icin hangi cihaza gidecegini bilmeli.',
  hintMessage:
      'Yerel agdan disari cikis kapisi modemdir. Gateway olarak modemin adresini secmelisin.',
  connectedMessage:
      'Dogru ag gecidi secildi. Trafik internete modem uzerinden cikacak.',
  successMessage:
      'Basarili! Varsayilan ag gecidi, farkli aglara giderken kullanilan cikis noktasidir.',
  learningNote:
      'Gateway, bilgisayarin yerel ag disina cikmak icin kullandigi modem veya router adresidir.',
  nextStepMessage:
      'Bir sonraki bolumde web sitesi adlarinin IP adreslerine nasil donustugunu gorecegiz.',
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
      id: 'gateway_dialogue',
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
      question: 'Default gateway olarak hangisi secilmeli?',
      options: ['192.168.1.1 (Modem)', '192.168.1.24 (PC)', '8.8.8.8 (DNS)'],
      correctOption: '192.168.1.1 (Modem)',
    ),
  ),
);
