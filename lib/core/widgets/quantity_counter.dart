import 'package:flutter/material.dart';

class QuantityCounter extends StatelessWidget {
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final bool compact;

  const QuantityCounter({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final btnSize = compact ? 30.0 : 38.0;
    final iconSize = compact ? 14.0 : 18.0;
    final textWidth = compact ? 28.0 : 36.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CounterButton(
          onPressed: onDecrement,
          icon: Icons.remove_rounded,
          size: btnSize,
          iconSize: iconSize,
          cs: cs,
          compact: compact,
        ),
        SizedBox(
          width: textWidth,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: (compact ? tt.labelLarge : tt.titleMedium)?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
        ),
        _CounterButton(
          onPressed: onIncrement,
          icon: Icons.add_rounded,
          size: btnSize,
          iconSize: iconSize,
          cs: cs,
          compact: compact,
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final double iconSize;
  final ColorScheme cs;
  final bool compact;

  const _CounterButton({
    required this.onPressed,
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.cs,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
      style: IconButton.styleFrom(
        minimumSize: Size(size, size),
        maximumSize: Size(size, size),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(compact ? 8 : 10),
        ),
      ),
    );
  }
}
