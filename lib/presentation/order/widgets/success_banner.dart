import 'package:flutter/material.dart';

class SuccessBanner extends StatelessWidget {
  const SuccessBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(height: 8),
          Text(
            'Pedido realizado com sucesso!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
