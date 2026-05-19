import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_cable_demo/game/assets/game_assets.dart';
import 'package:network_cable_demo/game/levels/level_1.dart';
import 'package:network_cable_demo/game/levels/level_2.dart';
import 'package:network_cable_demo/game/levels/level_3.dart';
import 'package:network_cable_demo/game/levels/level_4.dart';
import 'package:network_cable_demo/game/levels/level_data.dart';
import 'package:network_cable_demo/game/levels/levels.dart';
import 'package:network_cable_demo/main.dart';

void main() {
  testWidgets('shows the first task title', (WidgetTester tester) async {
    await tester.pumpWidget(const NetworkCableDemoApp());

    expect(find.text('Ethernet Baglantisi'), findsOneWidget);
    expect(find.text('Bilgisayari modeme bagla'), findsOneWidget);
    expect(find.textContaining('Ethernet kablosunu modeme'), findsOneWidget);
  });

  testWidgets('renders on a phone-sized screen and restart is safe', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const NetworkCableDemoApp());
    await tester.pump();

    await tester.tap(find.byTooltip('Yeniden baslat'));
    await tester.pump();
    await tester.tap(find.byTooltip('Yeniden baslat'));
    await tester.pump();

    expect(find.text('Ethernet Baglantisi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('level one defines the ethernet connection goal', () {
    final computer = level1.objectByType(LevelObjectType.computer);
    final modem = level1.objectByType(LevelObjectType.modem);
    final connection = level1.connectionGoal;

    expect(computer.id, 'computer');
    expect(modem.id, 'modem');
    expect(connection.fromObjectId, computer.id);
    expect(connection.toObjectId, modem.id);
    expect(connection.cableId, 'ethernet_cable');
    expect(level1.hintMessage, contains('Ethernet portuna'));
    expect(level1.connectedMessage, contains('Fiziksel baglanti'));
  });

  test('level two defines an IP address selection goal', () {
    final ipGoal = level2.ipSelectionGoal;

    expect(levels.length, 4);
    expect(level2.taskType, LevelTaskType.ipAddressSelection);
    expect(ipGoal.correctOption, '192.168.1.24');
    expect(ipGoal.options, contains(ipGoal.correctOption));
  });

  test('new gateway and DNS levels define selection goals', () {
    expect(levels.map((level) => level.id), [
      'ethernet_connection',
      'ip_address',
      'default_gateway',
      'dns_lookup',
    ]);

    expect(level3.taskType, LevelTaskType.gatewaySelection);
    expect(level3.sceneTheme, LevelSceneTheme.gateway);
    expect(level3.selectionGoal.correctOption, '192.168.1.1 (Modem)');
    expect(level3.learningNote, contains('Gateway'));

    expect(level4.taskType, LevelTaskType.dnsSelection);
    expect(level4.sceneTheme, LevelSceneTheme.dns);
    expect(level4.selectionGoal.correctOption, 'DNS Sunucusu');
    expect(level4.learningNote, contains('DNS'));
  });

  test('asset slots use the expected final filenames', () {
    expect(GameImageAssets.computer, 'assets/images/computer.png');
    expect(GameImageAssets.modem, 'assets/images/modem.png');
    expect(GameImageAssets.ethernetCable, 'assets/images/ethernet_cable.png');
    expect(GameAudioAssets.success, 'assets/audio/success.wav');
  });
}
