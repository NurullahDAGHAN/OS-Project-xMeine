import 'package:flutter/material.dart';

class SuccessPanel extends StatelessWidget {
  const SuccessPanel({
    super.key,
    required this.message,
    required this.learningNote,
    required this.nextStepMessage,
    required this.onRestart,
    this.learningIcon = Icons.school_outlined,
    this.onNext,
  });

  static const overlayKey = 'success_panel';

  final String message;
  final String learningNote;
  final String nextStepMessage;
  final VoidCallback onRestart;
  final IconData learningIcon;
  final VoidCallback? onNext;

  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0x73000000),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
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
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: Color(0xFF36D47A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
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
                                  'Basarili!',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF263A36),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message,
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
                        ],
                      ),
                      const SizedBox(height: 18),
                      _LearningNote(
                        icon: learningIcon,
                        title: 'Ogrenilen konu',
                        body: learningNote,
                      ),
                      const SizedBox(height: 10),
                      _LearningNote(
                        icon: Icons.route_outlined,
                        title: 'Sonraki adim',
                        body: nextStepMessage,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: onRestart,
                            icon: const Icon(Icons.restart_alt),
                            label: const Text('Tekrar dene'),
                          ),
                          if (onNext != null) ...[
                            const SizedBox(width: 10),
                            FilledButton.icon(
                              onPressed: onNext,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Sonraki bolum'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
