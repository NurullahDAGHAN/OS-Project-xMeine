import 'level_data.dart';

const level2 = LevelData(
  id: 'ip_address',
  taskType: LevelTaskType.ipAddressSelection,
  title: 'IP Adresi',
  sceneTheme: LevelSceneTheme.home,
  instruction: 'Bilgisayar için doğru IP adresini seç',
  dialogue:
      'Kablo bağlandı. Şimdi bilgisayarın aynı ağda konuşabilmesi için uygun bir IP adresi seçmeliyiz.',
  hintMessage:
      'Modem 192.168.1.x ağında. Bilgisayar da 192.168.1 ile başlayan boş bir adres almalı.',
  connectedMessage:
      'Doğru IP seçildi. Bilgisayar artık modemle aynı yerel ağda.',
  successMessage:
      'Harika! IP adresi, cihazların ağ üzerinde birbirini bulmasını sağlar.',
  learningNote:
      'IP adresi, cihazların aynı yerel ağ üzerinde birbirini bulmasını sağlar.',
  nextStepMessage:
      'Bir sonraki bölümde yerel ağdan internete çıkış için gateway seçeceğiz.',
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
    selection: SelectionGoalData(
      question: 'Bu ağ için en uygun IP hangisi?',
      options: ['192.168.1.24', '10.0.0.9', '172.16.4.2'],
      correctOption: '192.168.1.24',
    ),
  ),
);
