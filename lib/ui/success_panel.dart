import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class SuccessPanel extends StatelessWidget {
  const SuccessPanel({
    super.key,
    required this.strings,
    required this.message,
    required this.learningNote,
    required this.nextStepMessage,
    required this.onRestart,
    this.isFinalLevel = false,
    this.learningIcon = Icons.school_outlined,
    this.onNext,
    this.onReturnToStart,
    this.onCloseApp,
    this.onExit,
    this.onClose,
  });

  static const overlayKey = 'success_panel';

  final AppStrings strings;
  final String message;
  final String learningNote;
  final String nextStepMessage;
  final VoidCallback onRestart;
  final bool isFinalLevel;
  final IconData learningIcon;
  final VoidCallback? onNext;
  final VoidCallback? onReturnToStart;
  final VoidCallback? onCloseApp;
  final VoidCallback? onExit;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final availableHeight =
        isPortrait ? screenHeight * 0.75 : screenHeight * 0.9;
    final title =
        isFinalLevel ? strings.gameCompleteTitle : strings.successTitle;
    final headerMessage = isFinalLevel ? strings.gameCompleteMessage : message;
    final badgeColor =
        isFinalLevel ? const Color(0xFFF2B84B) : const Color(0xFF36D47A);
    final badgeIcon = isFinalLevel ? Icons.emoji_events_outlined : Icons.check;

    return ColoredBox(
      color: const Color(0x73000000),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 460,
                maxHeight: availableHeight,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD6E8DD)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 30,
                      offset: Offset(0, 18),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: badgeColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              badgeIcon,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF263A36),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  headerMessage,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF45534F),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (onClose != null)
                            IconButton(
                              onPressed: onClose,
                              icon: const Icon(
                                Icons.logout,
                                color: Color(0xFFE57373),
                              ),
                              tooltip: strings.exit,
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _LearningNote(
                              icon: learningIcon,
                              title: strings.learnedTopic,
                              body: learningNote,
                            ),
                            const SizedBox(height: 10),
                            _LearningNote(
                              icon: Icons.route_outlined,
                              title: strings.nextStep,
                              body: nextStepMessage,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child:
                          isFinalLevel
                              ? _FinalActions(
                                strings: strings,
                                onReturnToStart: onReturnToStart,
                                onCloseApp: onCloseApp,
                                onExit: onExit,
                              )
                              : _LevelActions(
                                strings: strings,
                                onRestart: onRestart,
                                onNext: onNext,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelActions extends StatelessWidget {
  const _LevelActions({
    required this.strings,
    required this.onRestart,
    required this.onNext,
  });

  final AppStrings strings;
  final VoidCallback onRestart;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onRestart,
            icon: const Icon(Icons.restart_alt),
            label: Text(strings.retry),
          ),
        ),
        if (onNext != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward),
              label: Text(strings.nextLevel),
            ),
          ),
        ],
      ],
    );
  }
}

class _FinalActions extends StatelessWidget {
  const _FinalActions({
    required this.strings,
    required this.onReturnToStart,
    required this.onCloseApp,
    required this.onExit,
  });

  final AppStrings strings;
  final VoidCallback? onReturnToStart;
  final VoidCallback? onCloseApp;
  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: onReturnToStart,
          icon: const Icon(Icons.first_page),
          label: Text(strings.returnToStart),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onCloseApp,
          icon: const Icon(Icons.power_settings_new),
          label: Text(strings.closeApp),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red[700],
            side: BorderSide(color: Colors.red[200]!),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onExit,
          icon: const Icon(Icons.logout),
          label: Text(strings.exit),
        ),
      ],
    );
  }
}

class _LearningNote extends StatelessWidget {
  const _LearningNote({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9EBDD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2D736A), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF263A36),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF55635F),
                    height: 1.28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
