import 'package:flutter/material.dart';

import '../data/progress_state.dart';
import '../game/levels/level_data.dart';
import '../l10n/app_localizations.dart';

class LevelSelectionPanel extends StatelessWidget {
  const LevelSelectionPanel({
    super.key,
    required this.strings,
    required this.language,
    required this.levels,
    required this.selectedLevelId,
    required this.onSelect,
    required this.onLogout,
    required this.onLanguageChanged,
    this.isMainMenu = false,
  });

  final AppStrings strings;
  final AppLanguage language;
  final List<LevelProgressView> levels;
  final String selectedLevelId;
  final ValueChanged<String> onSelect;
  final VoidCallback onLogout;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final bool isMainMenu;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F2EA),
        border: Border(
          bottom:
              isLandscape
                  ? BorderSide.none
                  : const BorderSide(color: Color(0xFFE0D6C8)),
          right:
              isLandscape
                  ? const BorderSide(color: Color(0xFFE0D6C8))
                  : BorderSide.none,
        ),
      ),
      child:
          isLandscape
              ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    for (var index = 0; index < levels.length; index++) ...[
                      _LevelChip(
                        strings: strings,
                        index: index + 1,
                        view: levels[index],
                        selected: levels[index].level.id == selectedLevelId,
                        onPressed:
                            levels[index].progress.unlocked
                                ? () => onSelect(levels[index].level.id)
                                : null,
                      ),
                      if (index < levels.length - 1) const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 12),
                    _settingsButton(context),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showExitDialog(context),
                      icon: const Icon(Icons.exit_to_app),
                      label: Text(strings.exit),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    for (var index = 0; index < levels.length; index++) ...[
                      _LevelChip(
                        strings: strings,
                        index: index + 1,
                        view: levels[index],
                        selected: levels[index].level.id == selectedLevelId,
                        onPressed:
                            levels[index].progress.unlocked
                                ? () => onSelect(levels[index].level.id)
                                : null,
                      ),
                      if (index < levels.length - 1) const SizedBox(width: 8),
                    ],
                    const SizedBox(width: 12),
                    _settingsButton(context),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showExitDialog(context),
                      icon: const Icon(Icons.exit_to_app),
                      label: Text(strings.exit),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _settingsButton(BuildContext context) {
    return PopupMenuButton<AppLanguage>(
      tooltip: strings.settings,
      position: PopupMenuPosition.under,
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 240),
      onSelected: onLanguageChanged,
      itemBuilder:
          (context) => [
            PopupMenuItem<AppLanguage>(
              enabled: false,
              height: 32,
              child: Text(
                strings.language,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF263A36),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            CheckedPopupMenuItem<AppLanguage>(
              value: AppLanguage.turkish,
              checked: language == AppLanguage.turkish,
              height: 40,
              child: Text(
                strings.turkish,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CheckedPopupMenuItem<AppLanguage>(
              value: AppLanguage.english,
              checked: language == AppLanguage.english,
              height: 40,
              child: Text(
                strings.english,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
      child: _SettingsButtonFace(label: strings.settings),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(strings.exitGameTitle),
            content: Text(strings.exitGameMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(strings.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onLogout();
                },
                child: Text(
                  strings.exit,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}

class _SettingsButtonFace extends StatelessWidget {
  const _SettingsButtonFace({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCDE5DD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.settings, size: 18, color: Color(0xFF2F5F59)),
          const SizedBox(width: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF2F5F59),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.strings,
    required this.index,
    required this.view,
    required this.selected,
    required this.onPressed,
  });

  final AppStrings strings;
  final int index;
  final LevelProgressView view;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final progress = view.progress;
    final foreground =
        progress.unlocked ? const Color(0xFF263A36) : const Color(0xFF918D84);
    final background =
        selected
            ? const Color(0xFFE8F5F1)
            : progress.completed
            ? const Color(0xFFE5FAEF)
            : Colors.white;
    final border =
        selected
            ? const Color(0xFF3A8F86)
            : progress.completed
            ? const Color(0xFF97E3B6)
            : const Color(0xFFE0D6C8);

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(_iconFor(view.level.taskType, progress), size: 18),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index. ${view.level.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            _statusLabel(progress, strings),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground.withValues(alpha: 0.72),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledForegroundColor: const Color(0xFF918D84),
        side: BorderSide(color: border, width: selected ? 2 : 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.w900),
      ),
    );
  }

  IconData _iconFor(LevelTaskType taskType, LevelProgress progress) {
    if (!progress.unlocked) {
      return Icons.lock_outline;
    }
    if (progress.completed) {
      return Icons.check_circle_outline;
    }
    switch (taskType) {
      case LevelTaskType.ethernetConnection:
        return Icons.settings_ethernet;
      case LevelTaskType.ipAddressSelection:
        return Icons.numbers;
      case LevelTaskType.gatewaySelection:
        return Icons.route_outlined;
      case LevelTaskType.dnsSelection:
        return Icons.travel_explore_outlined;
      case LevelTaskType.subnetMaskSelection:
        return Icons.grid_on;
      case LevelTaskType.dhcpSelection:
        return Icons.settings_applications;
      case LevelTaskType.firewallSelection:
        return Icons.security;
    }
  }

  String _statusLabel(LevelProgress progress, AppStrings strings) {
    if (!progress.unlocked) {
      return strings.locked;
    }
    if (progress.completed) {
      return strings.completed;
    }
    return strings.open;
  }
}
