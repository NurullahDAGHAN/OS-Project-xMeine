import 'level_data.dart';

const level6 = LevelData(
  id: 'dhcp_service',
  taskType: LevelTaskType.dhcpSelection,
  title: 'DHCP Servisi',
  sceneTheme: LevelSceneTheme.dataCenter,
  instruction: 'IP ayarlarını otomatik dağıtan servisi seç',
  dialogue:
      'Ağ büyüdüğünde her bilgisayara tek tek IP yazmak zorlaşır. Bunu otomatik yapan servisi bulalım.',
  hintMessage:
      'Cihazlara IP, maske, gateway ve DNS bilgisini otomatik veren servis DHCP olur.',
  connectedMessage:
      'Doğru servis seçildi. Yeni cihazlar ağa katılınca ayarları otomatik alabilecek.',
  successMessage:
      'Harika! DHCP, cihazlara ağ ayarlarını otomatik dağıtarak kurulum yükünü azaltır.',
  learningNote:
      'DHCP sunucusu; IP adresi, alt ağ maskesi, gateway ve DNS gibi bilgileri istemcilere verebilir.',
  nextStepMessage:
      'Son bölümde ağdan geçen trafiği kurallarla kontrol eden güvenlik duvarını inceleyeceğiz.',
  objects: [
    LevelObjectData(
      id: 'computer',
      type: LevelObjectType.computer,
      position: LevelPoint(205, 336),
    ),
    LevelObjectData(
      id: 'modem',
      type: LevelObjectType.modem,
      position: LevelPoint(668, 318),
    ),
    LevelObjectData(
      id: 'ethernet_cable',
      type: LevelObjectType.cable,
      position: LevelPoint(462, 458),
    ),
    LevelObjectData(
      id: 'helper_character',
      type: LevelObjectType.character,
      position: LevelPoint(470, 290),
    ),
    LevelObjectData(
      id: 'dhcp_dialogue',
      type: LevelObjectType.dialogueBubble,
      position: LevelPoint(296, 146),
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
      question: 'IP ayarlarını otomatik dağıtan servis hangisi?',
      options: ['DHCP Sunucusu', 'DNS Sunucusu', 'Varsayılan Gateway'],
      correctOption: 'DHCP Sunucusu',
    ),
  ),
);
