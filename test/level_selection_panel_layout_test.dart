import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_cable_demo/data/progress_state.dart';
import 'package:network_cable_demo/game/levels/levels.dart';
import 'package:network_cable_demo/l10n/app_localizations.dart';
import 'package:network_cable_demo/ui/level_selection_panel.dart';

void main() {
  testWidgets('settings menu fits in a short landscape viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(640, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LevelSelectionPanel(
            strings: stringsFor(AppLanguage.turkish),
            language: AppLanguage.turkish,
            levels: [
              for (final level in levels)
                LevelProgressView(
                  level: level,
                  progress: LevelProgress(
                    levelId: level.id,
                    unlocked: true,
                    completed: false,
                    attempts: 0,
                    hintsUsed: 0,
                  ),
                ),
            ],
            selectedLevelId: levels.first.id,
            onSelect: (_) {},
            onLogout: () {},
            onLanguageChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(PopupMenuItem<AppLanguage>), findsWidgets);
    expect(find.text(stringsFor(AppLanguage.turkish).english), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
