import 'level_data.dart';

const level4 = LevelData(
  id: 'dns_lookup',
  taskType: LevelTaskType.dnsSelection,
  title: 'DNS Sunucusu',
  sceneTheme: LevelSceneTheme.dns,
  instruction: 'Site adini IP adresine cevirecek servisi sec',
  dialogue:
      'Ag gecidi hazir. Simdi bilgisayar example.com adini hangi servisle IP adresine cevirecegini bilmeli.',
  hintMessage:
      'Web sitesi adlarini IP adreslerine ceviren servis DNS sunucusudur.',
  connectedMessage:
      'Dogru DNS secildi. Bilgisayar artik alan adindan IP sonucuna ulasabilir.',
  successMessage:
      'Harika! DNS, site adlarini bilgisayarin baglanabilecegi IP adreslerine cevirir.',
  learningNote:
      'DNS, example.com gibi okunabilir adlari ag uzerinde kullanilan IP adresleriyle eslestirir.',
  nextStepMessage:
      'Temel akis tamamlandi: kablo, IP, gateway ve DNS birlikte internet baglantisini anlamli hale getirir.',
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
    ipSelection: IpSelectionData(
      question: 'Site adini IP adresine hangi servis cevirir?',
      options: ['DNS Sunucusu', 'Ethernet Kablosu', 'Guvenlik Duvari'],
      correctOption: 'DNS Sunucusu',
    ),
  ),
);
