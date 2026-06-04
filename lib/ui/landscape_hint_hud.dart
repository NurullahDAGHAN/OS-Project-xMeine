import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/network_game.dart';
import '../l10n/app_localizations.dart';
import 'game_hud.dart';

class LandscapeHintHud extends StatefulWidget {
  const LandscapeHintHud({
    super.key,
    required this.strings,
    required this.levelKey,
    required this.title,
    required this.instruction,
    required this.feedback,
    required this.status,
    required this.onRestart,
    required this.onHint,
    required this.onCloseApp,
    required this.maxExpandedWidth,
  });

  final AppStrings strings;
  final String levelKey;
  final String title;
  final String instruction;
  final String feedback;
  final NetworkGameStatus status;
  final VoidCallback onRestart;
  final VoidCallback onHint;
  final VoidCallback onCloseApp;
  final double maxExpandedWidth;

  @override
  State<LandscapeHintHud> createState() => _LandscapeHintHudState();
}

class _LandscapeHintHudState extends State<LandscapeHintHud>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _pulseController.forward();
  }

  @override
  void didUpdateWidget(covariant LandscapeHintHud oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.levelKey != widget.levelKey) {
      _expanded = false;
      _pulseController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child:
          _expanded
              ? _ExpandedHintCard(
                key: const ValueKey('expanded_hint_card'),
                strings: widget.strings,
                title: widget.title,
                instruction: widget.instruction,
                feedback: widget.feedback,
                status: widget.status,
                maxWidth: widget.maxExpandedWidth,
                onRestart: widget.onRestart,
                onHint: widget.onHint,
                onCloseApp: widget.onCloseApp,
                onCollapse: () => setState(() => _expanded = false),
              )
              : _HintLauncher(
                key: const ValueKey('collapsed_hint_launcher'),
                strings: widget.strings,
                pulseController: _pulseController,
                onTap: () => setState(() => _expanded = true),
              ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}

class _ExpandedHintCard extends StatelessWidget {
  const _ExpandedHintCard({
    super.key,
    required this.strings,
    required this.title,
    required this.instruction,
    required this.feedback,
    required this.status,
    required this.maxWidth,
    required this.onRestart,
    required this.onHint,
    required this.onCloseApp,
    required this.onCollapse,
  });

  final AppStrings strings;
  final String title;
  final String instruction;
  final String feedback;
  final NetworkGameStatus status;
  final double maxWidth;
  final VoidCallback onRestart;
  final VoidCallback onHint;
  final VoidCallback onCloseApp;
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GameHud(
            strings: strings,
            title: title,
            instruction: instruction,
            feedback: feedback,
            status: status,
            onRestart: onRestart,
            onHint: onHint,
            onCloseApp: onCloseApp,
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Tooltip(
              message: strings.closeCard,
              child: SizedBox.square(
                dimension: 30,
                child: IconButton.filled(
                  onPressed: onCollapse,
                  icon: const Icon(Icons.close, size: 16),
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF2D736A),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HintLauncher extends StatelessWidget {
  const _HintLauncher({
    super.key,
    required this.strings,
    required this.pulseController,
    required this.onTap,
  });

  final AppStrings strings;
  final AnimationController pulseController;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final pulse = (math.sin(pulseController.value * math.pi * 5).abs() *
                (1 - pulseController.value))
            .clamp(0.0, 1.0);

        return Transform.scale(
          scale: 1 + pulse * 0.08,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color.lerp(
                const Color(0xF2FFFFFF),
                const Color(0xFFFFF7D8),
                pulse,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    Color.lerp(
                      const Color(0xFFCDE5DD),
                      const Color(0xFFFFC83D),
                      pulse,
                    )!,
                width: 1 + pulse,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Color.lerp(
                        const Color(0x1F000000),
                        const Color(0x66FFC83D),
                        pulse,
                      )!,
                  blurRadius: 10 + pulse * 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Tooltip(
        message: strings.openInfoCard,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: const SizedBox.square(
              dimension: 42,
              child: Icon(
                Icons.lightbulb_outline,
                color: Color(0xFF2D736A),
                size: 23,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
