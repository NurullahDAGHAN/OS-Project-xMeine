import 'level_data.dart';

const level4 = LevelData(
  id: 'dns_lookup',
  taskType: LevelTaskType.dnsSelection,
  title: 'DNS Sunucusu',
  sceneTheme: LevelSceneTheme.dns,
  instruction: 'Site adını IP adresine çevirecek servisi seç',
  dialogue:
      'Ağ geçidi hazır. Şimdi bilgisayar example.com adını hangi servisle IP adresine çevireceğini bilmeli.',
  hintMessage:
      'Web sitesi adlarını IP adreslerine çeviren servis DNS sunucusudur.',
  connectedMessage:
      'Doğru DNS seçildi. Bilgisayar artık alan adından IP sonucuna ulaşabilir.',
  successMessage:
      'Harika! DNS, site adlarını bilgisayarın bağlanabileceği IP adreslerine çevirir.',
  learningNote:
      'DNS, example.com gibi okunabilir adları ağ üzerinde kullanılan IP adresleriyle eşleştirir.',
  nextStepMessage:
      'Temel akış tamamlandı: kablo, IP, gateway ve DNS birlikte internet bağlantısını anlamlı hale getirir.',
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
      id: 'dns_dialogue',
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
      question: 'Site adını IP adresine hangi servis çevirir?',
      options: ['DNS Sunucusu', 'Ethernet Kablosu', 'Güvenlik Duvarı'],
      correctOption: 'DNS Sunucusu',
    ),
  ),
);
