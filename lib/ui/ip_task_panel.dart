import 'package:flutter/material.dart';

class IpTaskPanel extends StatelessWidget {
  const IpTaskPanel({
    super.key,
    required this.question,
    required this.options,
    required this.onSelect,
    this.leadingIcon = Icons.numbers,
    this.optionIcon = Icons.dns_outlined,
    this.dense = false,
  });

  final String question;
  final List<String> options;
  final ValueChanged<String> onSelect;
  final IconData leadingIcon;
  final IconData optionIcon;
  final bool dense;

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = !dense && constraints.maxWidth < 620;
          final buttons =
              options.map((option) {
                return _IpOptionButton(
                  label: option,
                  icon: optionIcon,
                  onPressed: () => onSelect(option),
                  dense: dense,
                );
              }).toList();

          final header = Row(
            children: [
              Container(
                width: dense ? 28 : 34,
                height: dense ? 28 : 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCDE5DD)),
                ),
                child: Icon(
                  leadingIcon,
                  color: const Color(0xFF2D736A),
                  size: dense ? 17 : 20,
                ),
              ),
              SizedBox(width: dense ? 8 : 10),
              Expanded(
                child: Text(
                  question,
                  maxLines: dense ? 1 : null,
                  overflow: dense ? TextOverflow.ellipsis : null,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF263A36),
                    fontWeight: FontWeight.w900,
                    fontSize: dense ? 13 : null,
                  ),
                ),
              ),
            ],
          );

          final buttonRow =
              compact
                  ? Column(
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
                  : Row(
                    children: List.generate(buttons.length, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index == buttons.length - 1 ? 0 : 8,
                          ),
                          child: buttons[index],
                        ),
                      );
                    }),
                  );

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(dense ? 8 : 12), child: header),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 12),
                child: buttonRow,
              ),
              SizedBox(height: dense ? 8 : 12),
            ],
          );
        },
      ),
    );
  }
}

class _IpOptionButton extends StatelessWidget {
  const _IpOptionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.dense,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool dense;

  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: dense ? 16 : 18),
      label: Text(
        label,
        maxLines: dense ? 1 : null,
        overflow: dense ? TextOverflow.ellipsis : null,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2F5F59),
        side: const BorderSide(color: Color(0xFFCDE5DD)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 8 : 12,
          vertical: dense ? 8 : 12,
        ),
        textStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: dense ? 12 : null,
        ),
      ),
    );
  }
}
