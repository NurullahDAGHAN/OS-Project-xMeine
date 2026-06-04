import '../game/levels/level_data.dart';
import '../game/levels/levels.dart' as tr_levels;

enum AppLanguage { turkish, english }

class AppStrings {
  const AppStrings({
    required this.appTitle,
    required this.settings,
    required this.language,
    required this.turkish,
    required this.english,
    required this.close,
    required this.exit,
    required this.exitGameTitle,
    required this.exitGameMessage,
    required this.cancel,
    required this.locked,
    required this.completed,
    required this.open,
    required this.ready,
    required this.tryAgainStatus,
    required this.connected,
    required this.hint,
    required this.restart,
    required this.closeApp,
    required this.closeAppTitle,
    required this.closeAppMessage,
    required this.successTitle,
    required this.learnedTopic,
    required this.nextStep,
    required this.retry,
    required this.nextLevel,
    required this.returnToStart,
    required this.gameCompleteTitle,
    required this.gameCompleteMessage,
    required this.closeCard,
    required this.openInfoCard,
    required this.progressLoadError,
    required this.errorPrefix,
    required this.dropIpCard,
    required this.dropGatewayCard,
    required this.dropDnsCard,
    required this.dropMaskCard,
    required this.dropDhcpCard,
    required this.dropRuleCard,
    required this.connectCable,
    required this.signIn,
    required this.createAccount,
    required this.email,
    required this.emailHint,
    required this.password,
    required this.passwordHint,
    required this.alreadyHaveAccount,
    required this.noAccountCreate,
    required this.fillAllFields,
    required this.accountCreated,
    required this.registerFailed,
    required this.invalidLogin,
  });

  final String appTitle;
  final String settings;
  final String language;
  final String turkish;
  final String english;
  final String close;
  final String exit;
  final String exitGameTitle;
  final String exitGameMessage;
  final String cancel;
  final String locked;
  final String completed;
  final String open;
  final String ready;
  final String tryAgainStatus;
  final String connected;
  final String hint;
  final String restart;
  final String closeApp;
  final String closeAppTitle;
  final String closeAppMessage;
  final String successTitle;
  final String learnedTopic;
  final String nextStep;
  final String retry;
  final String nextLevel;
  final String returnToStart;
  final String gameCompleteTitle;
  final String gameCompleteMessage;
  final String closeCard;
  final String openInfoCard;
  final String progressLoadError;
  final String errorPrefix;
  final String dropIpCard;
  final String dropGatewayCard;
  final String dropDnsCard;
  final String dropMaskCard;
  final String dropDhcpCard;
  final String dropRuleCard;
  final String connectCable;
  final String signIn;
  final String createAccount;
  final String email;
  final String emailHint;
  final String password;
  final String passwordHint;
  final String alreadyHaveAccount;
  final String noAccountCreate;
  final String fillAllFields;
  final String accountCreated;
  final String registerFailed;
  final String invalidLogin;
}

const _tr = AppStrings(
  appTitle: 'Ağ Eğitimi Oyunu',
  settings: 'Ayarlar',
  language: 'Dil',
  turkish: 'Türkçe',
  english: 'English',
  close: 'Kapat',
  exit: 'Çıkış',
  exitGameTitle: 'Oyundan Çık',
  exitGameMessage: 'Oyundan çıkmak istediğine emin misin?',
  cancel: 'İptal',
  locked: 'Kilitli',
  completed: 'Tamamlandı',
  open: 'Açık',
  ready: 'Hazır',
  tryAgainStatus: 'Tekrar dene',
  connected: 'Bağlandı',
  hint: 'İpucu',
  restart: 'Yeniden başlat',
  closeApp: 'Uygulamayı kapat',
  closeAppTitle: 'Uygulamayı kapat',
  closeAppMessage: 'Uygulamayı kapatmak istediğine emin misin?',
  successTitle: 'Başarılı!',
  learnedTopic: 'Öğrenilen konu',
  nextStep: 'Sonraki adım',
  retry: 'Tekrar dene',
  nextLevel: 'Sonraki bölüm',
  returnToStart: 'En başa dön',
  gameCompleteTitle: 'Tebrikler!',
  gameCompleteMessage:
      'Tüm bölümleri tamamladın. Artık temel ağ akışını baştan sona kurabiliyorsun.',
  closeCard: 'Kartı kapat',
  openInfoCard: 'Bilgi kartını aç',
  progressLoadError: 'İlerleme verisi yüklenemedi',
  errorPrefix: 'Hata',
  dropIpCard: 'IP kartını buraya bırak',
  dropGatewayCard: 'Gateway kartını bırak',
  dropDnsCard: 'DNS kartını bırak',
  dropMaskCard: 'Maske kartını bırak',
  dropDhcpCard: 'DHCP kartını bırak',
  dropRuleCard: 'Kural kartını bırak',
  connectCable: 'Kabloyu bağla',
  signIn: 'Giriş Yap',
  createAccount: 'Hesap Oluştur',
  email: 'E-Posta',
  emailHint: 'ornek@email.com',
  password: 'Şifre',
  passwordHint: 'En az 4 karakter',
  alreadyHaveAccount: 'Zaten hesabın var mı? Giriş Yap',
  noAccountCreate: 'Hesabın yok mu? Oluştur',
  fillAllFields: 'Lütfen tüm alanları doldurun',
  accountCreated: 'Hesap başarıyla oluşturuldu! Lütfen giriş yapın.',
  registerFailed: 'Kayıt başarısız. E-posta geçerli mi veya zaten kayıtlı mı?',
  invalidLogin: 'E-posta veya şifre yanlış. Lütfen kontrol edin.',
);

const _en = AppStrings(
  appTitle: 'Network Learning Game',
  settings: 'Settings',
  language: 'Language',
  turkish: 'Turkish',
  english: 'English',
  close: 'Close',
  exit: 'Exit',
  exitGameTitle: 'Exit Game',
  exitGameMessage: 'Are you sure you want to exit the game?',
  cancel: 'Cancel',
  locked: 'Locked',
  completed: 'Completed',
  open: 'Open',
  ready: 'Ready',
  tryAgainStatus: 'Try again',
  connected: 'Connected',
  hint: 'Hint',
  restart: 'Restart',
  closeApp: 'Close app',
  closeAppTitle: 'Close app',
  closeAppMessage: 'Are you sure you want to close the app?',
  successTitle: 'Success!',
  learnedTopic: 'Learned topic',
  nextStep: 'Next step',
  retry: 'Retry',
  nextLevel: 'Next level',
  returnToStart: 'Back to start',
  gameCompleteTitle: 'Congratulations!',
  gameCompleteMessage:
      'You completed every level. You can now build the basic network flow from start to finish.',
  closeCard: 'Close card',
  openInfoCard: 'Open info card',
  progressLoadError: 'Progress data could not be loaded',
  errorPrefix: 'Error',
  dropIpCard: 'Drop the IP card here',
  dropGatewayCard: 'Drop the gateway card',
  dropDnsCard: 'Drop the DNS card',
  dropMaskCard: 'Drop the mask card',
  dropDhcpCard: 'Drop the DHCP card',
  dropRuleCard: 'Drop the rule card',
  connectCable: 'Connect the cable',
  signIn: 'Sign in',
  createAccount: 'Create account',
  email: 'Email',
  emailHint: 'name@example.com',
  password: 'Password',
  passwordHint: 'At least 4 characters',
  alreadyHaveAccount: 'Already have an account? Sign in',
  noAccountCreate: 'No account yet? Create one',
  fillAllFields: 'Please fill in all fields',
  accountCreated: 'Account created successfully. Please sign in.',
  registerFailed: 'Registration failed. Check the email or use another one.',
  invalidLogin: 'Email or password is incorrect. Please check and try again.',
);

AppStrings stringsFor(AppLanguage language) {
  return switch (language) {
    AppLanguage.turkish => _tr,
    AppLanguage.english => _en,
  };
}

List<LevelData> localizedLevels(AppLanguage language) {
  return switch (language) {
    AppLanguage.turkish => tr_levels.levels,
    AppLanguage.english => _englishLevels(),
  };
}

List<LevelData> _englishLevels() {
  final source = tr_levels.levels;
  return [
    _copyLevel(
      source[0],
      title: 'Ethernet Connection',
      instruction: 'Connect the computer to the modem',
      dialogue:
          'Drag the Ethernet cable from the computer to the modem port to start the network connection.',
      hintMessage: 'Hold the cable plug and drop it onto the modem port.',
      connectedMessage:
          'The physical connection is ready. The computer and modem can now talk on the same network.',
      successMessage:
          'Success! The Ethernet cable created a physical network connection.',
      learningNote:
          'An Ethernet cable carries data between the computer and modem through a wired connection.',
      nextStepMessage:
          'Next, we will choose the IP address the computer uses on the network.',
    ),
    _copyLevel(
      source[1],
      title: 'IP Address',
      instruction: 'Drag the correct IP address to the computer',
      dialogue:
          'The cable is connected. Now the computer needs an IP address that fits this local network.',
      hintMessage:
          'This network uses 192.168.1.x addresses. Pick the address in that range.',
      connectedMessage:
          'Correct IP selected. The computer now has an address on the local network.',
      successMessage:
          'Success! An IP address identifies a device on a network.',
      learningNote:
          'Devices in the same local network usually share the same network part of the IP address.',
      nextStepMessage:
          'Next, we will choose the gateway used to reach outside networks.',
      question: 'Which IP fits this network best?',
      options: ['192.168.1.24', '10.0.0.9', '172.16.4.2'],
      correctOption: '192.168.1.24',
    ),
    _copyLevel(
      source[2],
      title: 'Default Gateway',
      instruction: 'Drag the correct gateway to the computer',
      dialogue:
          'The IP address is ready. Now the computer needs to know where to send traffic for the internet.',
      hintMessage:
          'The default gateway is usually the modem or router address on the same local network.',
      connectedMessage:
          'Correct gateway selected. The computer can now send traffic outside the local network.',
      successMessage:
          'Success! The gateway is the exit point from the local network.',
      learningNote:
          'A default gateway forwards traffic from your local network to other networks, such as the internet.',
      nextStepMessage:
          'Next, we will choose the service that turns website names into IP addresses.',
      question: 'Which one should be the default gateway?',
      options: ['192.168.1.1 (Modem)', '192.168.1.24 (PC)', '8.8.8.8 (DNS)'],
      correctOption: '192.168.1.1 (Modem)',
    ),
    _copyLevel(
      source[3],
      title: 'DNS Server',
      instruction: 'Drag the service that resolves site names',
      dialogue:
          'The gateway is ready. Now the computer needs a service that turns example.com into an IP address.',
      hintMessage:
          'DNS translates website names into IP addresses that computers can connect to.',
      connectedMessage:
          'Correct service selected. Website names can now be resolved to IP addresses.',
      successMessage: 'Success! DNS translates domain names into IP addresses.',
      learningNote:
          'Without DNS, users would need to remember numeric IP addresses instead of website names.',
      nextStepMessage:
          'Next, we will define the local network boundary with a subnet mask.',
      question: 'Which service translates site names into IP addresses?',
      options: ['DNS Server', 'Ethernet Cable', 'Firewall'],
      correctOption: 'DNS Server',
    ),
    _copyLevel(
      source[4],
      title: 'Subnet Mask',
      instruction: 'Drag the correct local network mask',
      dialogue:
          'The computer has an IP address, but it uses a mask to understand which addresses are local.',
      hintMessage:
          'For a 192.168.1.x home network, 255.255.255.0 is the usual /24 subnet mask.',
      connectedMessage:
          'Correct mask selected. The computer can identify the local network boundary.',
      successMessage:
          'Success! A subnet mask separates the network part and device part of an IP address.',
      learningNote:
          'The subnet mask tells the computer which addresses are nearby and which need the gateway.',
      nextStepMessage:
          'Next, we will see the service that automatically gives network settings to devices.',
      question: 'Which mask fits the 192.168.1.x network?',
      options: ['255.255.255.0', '255.0.0.0', '255.255.0.255'],
      correctOption: '255.255.255.0',
    ),
    _copyLevel(
      source[5],
      title: 'DHCP Service',
      instruction: 'Drag the service that assigns settings automatically',
      dialogue:
          'As networks grow, writing IP settings by hand becomes hard. Let us choose the service that automates it.',
      hintMessage:
          'DHCP can automatically provide IP address, mask, gateway, and DNS settings.',
      connectedMessage:
          'Correct service selected. Network settings can now be assigned automatically.',
      successMessage:
          'Success! DHCP automatically distributes network settings to devices.',
      learningNote:
          'A DHCP server can give clients an IP address, subnet mask, gateway, and DNS server.',
      nextStepMessage:
          'Finally, we will look at the firewall that controls allowed network traffic.',
      question: 'Which service assigns IP settings automatically?',
      options: ['DHCP Server', 'DNS Server', 'Default Gateway'],
      correctOption: 'DHCP Server',
    ),
    _copyLevel(
      source[6],
      title: 'Firewall',
      instruction: 'Drag the correct traffic rule for web access',
      dialogue:
          'The connection works. Now choose the rule that allows web traffic safely.',
      hintMessage:
          'Web access needs a rule that allows HTTP and HTTPS traffic.',
      connectedMessage:
          'Correct rule selected. Web traffic can pass while unnecessary traffic stays controlled.',
      successMessage:
          'Success! A firewall allows or blocks network traffic based on rules.',
      learningNote:
          'Firewall rules define which services can enter or leave the network.',
      nextStepMessage:
          'All steps are complete: cable, IP, mask, gateway, DNS, DHCP, and firewall work together.',
      question: 'Which rule is correct for web access?',
      options: [
        'Allow HTTP/HTTPS traffic',
        'Block DNS requests',
        'Delete the gateway address',
      ],
      correctOption: 'Allow HTTP/HTTPS traffic',
    ),
  ];
}

LevelData _copyLevel(
  LevelData source, {
  required String title,
  required String instruction,
  required String dialogue,
  required String hintMessage,
  required String connectedMessage,
  required String successMessage,
  required String learningNote,
  required String nextStepMessage,
  String? question,
  List<String>? options,
  String? correctOption,
}) {
  return LevelData(
    id: source.id,
    taskType: source.taskType,
    title: title,
    sceneTheme: source.sceneTheme,
    instruction: instruction,
    dialogue: dialogue,
    hintMessage: hintMessage,
    connectedMessage: connectedMessage,
    successMessage: successMessage,
    learningNote: learningNote,
    nextStepMessage: nextStepMessage,
    objects: source.objects,
    goal: LevelGoalData(
      connection: source.goal.connection,
      selection:
          question == null || options == null || correctOption == null
              ? null
              : SelectionGoalData(
                question: question,
                options: options,
                correctOption: correctOption,
              ),
    ),
  );
}
