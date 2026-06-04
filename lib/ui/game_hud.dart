import 'package:flutter/material.dart';

import '../game/network_game.dart';
import '../l10n/app_localizations.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.strings,
    required this.title,
    required this.instruction,
    required this.feedback,
    required this.status,
    required this.onRestart,
    required this.onHint,
    required this.onCloseApp,
    this.dense = false,
  });

  final AppStrings strings;
  final String title;
  final String instruction;
  final String feedback;
  final NetworkGameStatus status;
  final VoidCallback onRestart;
  final VoidCallback onHint;
  final VoidCallback onCloseApp;
  final bool dense;

  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(status, strings);
    final isLocked =
        status == NetworkGameStatus.connected ||
        status == NetworkGameStatus.completed;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0D6C8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(dense ? 6 : 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = dense || constraints.maxWidth < 620;
            final titleBlock = _HudTextBlock(
              title: title,
              instruction: instruction,
              feedback: feedback,
              compact: compact,
              dense: dense,
            );
            final controls = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusPill(style: statusStyle, dense: dense),
                SizedBox(width: dense ? 4 : 8),
                _HudIconButton(
                  tooltip: strings.hint,
                  onPressed: isLocked ? null : onHint,
                  icon: Icons.lightbulb_outline,
                  dense: dense,
                ),
                SizedBox(width: dense ? 2 : 4),
                _HudIconButton(
                  tooltip: strings.restart,
                  onPressed: onRestart,
                  icon: Icons.restart_alt,
                  dense: dense,
                ),
                SizedBox(width: dense ? 2 : 4),
                _HudIconButton(
                  tooltip: strings.closeApp,
                  onPressed: onCloseApp,
                  icon: Icons.power_settings_new,
                  dense: dense,
                ),
              ],
            );

            if (compact && !dense) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleBlock,
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerRight, child: controls),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: titleBlock),
                SizedBox(width: dense ? 8 : 14),
                controls,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HudTextBlock extends StatelessWidget {
  const _HudTextBlock({
    required this.title,
    required this.instruction,
    required this.feedback,
    required this.compact,
    required this.dense,
  });

  final String title;
  final String instruction;
  final String feedback;
  final bool compact;
  final bool dense;

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: dense ? 24 : 38,
          height: dense ? 24 : 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCDE5DD)),
          ),
          child: Icon(
            Icons.lan_outlined,
            color: const Color(0xFF2D736A),
            size: dense ? 15 : 22,
          ),
        ),
        SizedBox(width: dense ? 6 : 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF263A36),
                  fontSize: dense ? 12 : null,
                ),
              ),
              if (!dense) ...[
                const SizedBox(height: 3),
                Text(
                  instruction,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF3F524E),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              if (!dense) ...[
                const SizedBox(height: 6),
                Text(
                  feedback,
                  maxLines: compact ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF6B7673),
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.style, required this.dense});

  final _HudStatusStyle style;
  final bool dense;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 6 : 10,
        vertical: dense ? 5 : 8,
      ),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: style.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: dense ? 14 : 16, color: style.foreground),
          if (!dense) ...[
            const SizedBox(width: 6),
            Text(
              style.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: style.foreground,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HudIconButton extends StatelessWidget {
  const _HudIconButton({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
    required this.dense,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool dense;

  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox.square(
        dimension: dense ? 28 : 40,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: dense ? 16 : 24),
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFF6F3EC),
            disabledBackgroundColor: const Color(0xFFE8E5DF),
            foregroundColor: const Color(0xFF3D5E5A),
            disabledForegroundColor: const Color(0xFF9B9992),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFFE0D6C8)),
            ),
          ),
        ),
      ),
    );
  }
}

class _HudStatusStyle {
  const _HudStatusStyle({
    required this.label,
    required this.icon,
    required this.background,
    required this.border,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color border;
  final Color foreground;
}

_HudStatusStyle _statusStyle(NetworkGameStatus status, AppStrings strings) {
  switch (status) {
    case NetworkGameStatus.ready:
      return _HudStatusStyle(
        label: strings.ready,
        icon: Icons.radio_button_unchecked,
        background: const Color(0xFFF3F7F6),
        border: const Color(0xFFD8E7E4),
        foreground: const Color(0xFF3F625D),
      );
    case NetworkGameStatus.needsRetry:
      return _HudStatusStyle(
        label: strings.tryAgainStatus,
        icon: Icons.info_outline,
        background: const Color(0xFFFFF6DF),
        border: const Color(0xFFFFD36B),
        foreground: const Color(0xFF835E16),
      );
    case NetworkGameStatus.connected:
      return _HudStatusStyle(
        label: strings.connected,
        icon: Icons.cable,
        background: const Color(0xFFE5FAEF),
        border: const Color(0xFF97E3B6),
        foreground: const Color(0xFF267447),
      );
    case NetworkGameStatus.completed:
      return _HudStatusStyle(
        label: strings.completed,
        icon: Icons.check_circle_outline,
        background: const Color(0xFFE5FAEF),
        border: const Color(0xFF78DFA4),
        foreground: const Color(0xFF1F6B3D),
      );
  }
}
