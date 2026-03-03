import 'package:flutter/material.dart';

class QuantityCounter extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityCounter({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove),
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(8),
            minimumSize: const Size(36, 36),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$quantity',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton.filled(
          onPressed: onIncrement,
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(8),
            minimumSize: const Size(36, 36),
          ),
        ),
      ],
    );
  }
}
