import 'level_data.dart';

const level3 = LevelData(
  id: 'default_gateway',
  taskType: LevelTaskType.gatewaySelection,
  title: 'Varsayılan Ağ Geçidi',
  sceneTheme: LevelSceneTheme.gateway,
  instruction: 'İnternete çıkış için doğru geçidi seç',
  dialogue:
      'IP adresi tamam. Şimdi bilgisayar yerel ağ dışına çıkmak için hangi cihaza gideceğini bilmeli.',
  hintMessage:
      'Yerel ağdan dışarı çıkış kapısı modemdir. Gateway olarak modemin adresini seçmelisin.',
  connectedMessage:
      'Doğru ağ geçidi seçildi. Trafik internete modem üzerinden çıkacak.',
  successMessage:
      'Başarılı! Varsayılan ağ geçidi, farklı ağlara giderken kullanılan çıkış noktasıdır.',
  learningNote:
      'Gateway, bilgisayarın yerel ağ dışına çıkmak için kullandığı modem veya router adresidir.',
  nextStepMessage:
      'Bir sonraki bölümde web sitesi adlarının IP adreslerine nasıl dönüştüğünü göreceğiz.',
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
    selection: SelectionGoalData(
      question: 'Default gateway olarak hangisi seçilmeli?',
      options: ['192.168.1.1 (Modem)', '192.168.1.24 (PC)', '8.8.8.8 (DNS)'],
      correctOption: '192.168.1.1 (Modem)',
    ),
  ),
);
