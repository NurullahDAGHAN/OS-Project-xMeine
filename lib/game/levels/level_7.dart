import 'level_data.dart';

const level7 = LevelData(
  id: 'firewall_rules',
  taskType: LevelTaskType.firewallSelection,
  title: 'Güvenlik Duvarı',
  sceneTheme: LevelSceneTheme.security,
  instruction: 'Web erişimi için doğru trafik kuralını seç',
  dialogue:
      'Bağlantı çalışıyor. Şimdi ağdan geçen trafiğin hangi kuralla güvenli şekilde izin alacağını seçelim.',
  hintMessage:
      'Web sitelerine erişmek için HTTP ve HTTPS trafiğine izin veren kural gerekir.',
  connectedMessage:
      'Doğru kural seçildi. Web trafiği geçebilir, gereksiz trafik kontrol altında kalır.',
  successMessage:
      'Başarılı! Güvenlik duvarı, ağ trafiğini kurallara göre izinli veya engelli hale getirir.',
  learningNote:
      'Firewall kuralları, hangi servislerin ağa girip çıkabileceğini belirleyerek bağlantıyı güvenli tutar.',
  nextStepMessage:
      'Tüm akış tamamlandı: kablo, IP, maske, gateway, DNS, DHCP ve firewall birlikte sağlıklı ağ kurar.',
  objects: [
    LevelObjectData(
      id: 'computer',
      type: LevelObjectType.computer,
      position: LevelPoint(215, 338),
    ),
    LevelObjectData(
      id: 'modem',
      type: LevelObjectType.modem,
      position: LevelPoint(660, 322),
    ),
    LevelObjectData(
      id: 'ethernet_cable',
      type: LevelObjectType.cable,
      position: LevelPoint(462, 458),
    ),
    LevelObjectData(
      id: 'helper_character',
      type: LevelObjectType.character,
      position: LevelPoint(470, 292),
    ),
    LevelObjectData(
      id: 'firewall_dialogue',
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
      question: 'Web erişimi için hangi kural doğru?',
      options: [
        'HTTP/HTTPS trafiğine izin ver',
        'DNS isteklerini engelle',
        'Gateway adresini sil',
      ],
      correctOption: 'HTTP/HTTPS trafiğine izin ver',
    ),
  ),
);
