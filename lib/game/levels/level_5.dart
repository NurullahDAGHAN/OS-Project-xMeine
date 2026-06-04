import 'level_data.dart';

const level5 = LevelData(
  id: 'subnet_mask',
  taskType: LevelTaskType.subnetMaskSelection,
  title: 'Alt Ağ Maskesi',
  sceneTheme: LevelSceneTheme.office,
  instruction: 'Bilgisayarın yerel ağ sınırını belirle',
  dialogue:
      'IP adresi var ama bilgisayar hangi adreslerin aynı yerel ağda olduğunu maske ile anlar.',
  hintMessage:
      '192.168.1.x gibi ev ve okul ağlarında en yaygın maske 255.255.255.0 olur.',
  connectedMessage:
      'Doğru maske seçildi. Bilgisayar artık yerel ağ sınırını doğru yorumluyor.',
  successMessage:
      'Başarılı! Alt ağ maskesi, IP adresinin ağ bölümü ile cihaz bölümünü ayırır.',
  learningNote:
      '255.255.255.0 maskesi, 192.168.1.x adreslerinin aynı yerel ağda olduğunu anlatır.',
  nextStepMessage:
      'Bir sonraki bölümde IP ayarlarının otomatik dağıtılmasını sağlayan DHCP servisini göreceğiz.',
  objects: [
    LevelObjectData(
      id: 'computer',
      type: LevelObjectType.computer,
      position: LevelPoint(210, 340),
    ),
    LevelObjectData(
      id: 'modem',
      type: LevelObjectType.modem,
      position: LevelPoint(660, 320),
    ),
    LevelObjectData(
      id: 'ethernet_cable',
      type: LevelObjectType.cable,
      position: LevelPoint(462, 458),
    ),
    LevelObjectData(
      id: 'helper_character',
      type: LevelObjectType.character,
      position: LevelPoint(472, 292),
    ),
    LevelObjectData(
      id: 'subnet_dialogue',
      type: LevelObjectType.dialogueBubble,
      position: LevelPoint(300, 148),
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
      question: '192.168.1.x ağı için uygun maske hangisi?',
      options: ['255.255.255.0', '255.0.0.0', '255.255.0.255'],
      correctOption: '255.255.255.0',
    ),
  ),
);
