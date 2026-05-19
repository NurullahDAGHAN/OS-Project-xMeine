import 'package:flutter/material.dart';

import '../game/network_game.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.title,
    required this.instruction,
    required this.feedback,
    required this.status,
    required this.onRestart,
    required this.onHint,
  });

  final String title;
  final String instruction;
  final String feedback;
  final NetworkGameStatus status;
  final VoidCallback onRestart;
  final VoidCallback onHint;

  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(status);
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
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 620;
            final titleBlock = _HudTextBlock(
              title: title,
              instruction: instruction,
              feedback: feedback,
              compact: compact,
            );
            final controls = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusPill(style: statusStyle),
                const SizedBox(width: 8),
                _HudIconButton(
                  tooltip: 'Ipucu',
                  onPressed: isLocked ? null : onHint,
                  icon: Icons.lightbulb_outline,
                ),
                const SizedBox(width: 4),
                _HudIconButton(
                  tooltip: 'Yeniden baslat',
                  onPressed: onRestart,
                  icon: Icons.restart_alt,
                ),
              ],
            );

            if (compact) {
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
                const SizedBox(width: 14),
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
  });

  final String title;
  final String instruction;
  final String feedback;
  final bool compact;

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCDE5DD)),
          ),
          child: const Icon(
            Icons.lan_outlined,
            color: Color(0xFF2D736A),
            size: 22,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF263A36),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                instruction,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF3F524E),
                  fontWeight: FontWeight.w700,
                ),
              ),
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
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.style});

  final _HudStatusStyle style;

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: style.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 16, color: style.foreground),
          const SizedBox(width: 6),
          Text(
            style.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: style.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
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
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final IconData icon;

  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox.square(
        dimension: 40,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
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

_HudStatusStyle _statusStyle(NetworkGameStatus status) {
  switch (status) {
    case NetworkGameStatus.ready:
      return const _HudStatusStyle(
        label: 'Hazir',
        icon: Icons.radio_button_unchecked,
        background: Color(0xFFF3F7F6),
        border: Color(0xFFD8E7E4),
        foreground: Color(0xFF3F625D),
      );
    case NetworkGameStatus.needsRetry:
      return const _HudStatusStyle(
        label: 'Tekrar dene',
        icon: Icons.info_outline,
        background: Color(0xFFFFF6DF),
        border: Color(0xFFFFD36B),
        foreground: Color(0xFF835E16),
      );
    case NetworkGameStatus.connected:
      return const _HudStatusStyle(
        label: 'Baglandi',
        icon: Icons.cable,
        background: Color(0xFFE5FAEF),
        border: Color(0xFF97E3B6),
        foreground: Color(0xFF267447),
      );
    case NetworkGameStatus.completed:
      return const _HudStatusStyle(
        label: 'Tamamlandi',
        icon: Icons.check_circle_outline,
        background: Color(0xFFE5FAEF),
        border: Color(0xFF78DFA4),
        foreground: Color(0xFF1F6B3D),
      );
  }
}
