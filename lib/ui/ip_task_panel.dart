import 'package:flutter/material.dart';

class IpTaskPanel extends StatelessWidget {
  const IpTaskPanel({
    super.key,
    required this.question,
    required this.options,
    required this.onSelect,
    this.leadingIcon = Icons.numbers,
    this.optionIcon = Icons.dns_outlined,
  });

  final String question;
  final List<String> options;
  final ValueChanged<String> onSelect;
  final IconData leadingIcon;
  final IconData optionIcon;

  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8E7E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
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
            final buttons =
                options.map((option) {
                  return _IpOptionButton(
                    label: option,
                    icon: optionIcon,
                    onPressed: () => onSelect(option),
                  );
                }).toList();

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5F1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFCDE5DD)),
                      ),
                      child: Icon(
                        leadingIcon,
                        color: Color(0xFF2D736A),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        question,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF263A36),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (compact)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                        buttons
                            .map(
                              (button) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: button,
                              ),
                            )
                            .toList(),
                  )
                else
                  Row(
                    children:
                        buttons
                            .map(
                              (button) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: button,
                                ),
                              ),
                            )
                            .toList(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _IpOptionButton extends StatelessWidget {
  const _IpOptionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2F5F59),
        side: const BorderSide(color: Color(0xFFCDE5DD)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}
