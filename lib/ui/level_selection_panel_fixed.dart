import 'package:flutter/material.dart';

import '../data/progress_state.dart';
import '../game/levels/level_data.dart';

class LevelSelectionPanel extends StatelessWidget {
  const LevelSelectionPanel({
    super.key,
    required this.levels,
    required this.selectedLevelId,
    required this.onSelect,
    required this.onLogout,
    this.isMainMenu = false,
  });

  final List<LevelProgressView> levels;
  final String selectedLevelId;
  final ValueChanged<String> onSelect;
  final VoidCallback onLogout;
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
                    ElevatedButton.icon(
                      onPressed: () => _showExitDialog(context),
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('Çıkış'),
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
                    // DİKEY MOD İÇİN EKSİK OLAN ÇIKIŞ BUTONUNU BURAYA EKLEDİK
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _showExitDialog(context),
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('Çıkış'),
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

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Oyundan Çık'),
            content: const Text('Oyundan çıkmak istediğinize emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onLogout();
                },
                child: const Text('Çık', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.index,
    required this.view,
    required this.selected,
    required this.onPressed,
  });

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
            _statusLabel(progress),
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

  String _statusLabel(LevelProgress progress) {
    if (!progress.unlocked) {
      return 'Kilitli';
    }
    if (progress.completed) {
      return 'Tamamlandı';
    }
    return 'Açık';
  }
}
