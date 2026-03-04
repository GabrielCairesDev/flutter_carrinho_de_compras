import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/routes/app_routes.dart';

class CartIconBadge extends StatelessWidget {
  final int count;

  const CartIconBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        tooltip: 'Ver carrinho',
        style: IconButton.styleFrom(
          backgroundColor: count > 0
              ? cs.primaryContainer
              : cs.surfaceContainerHigh,
          foregroundColor: count > 0
              ? cs.onPrimaryContainer
              : cs.onSurfaceVariant,
        ),
        icon: Badge(
          isLabelVisible: count > 0,
          label: Text(
            '$count',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          child: const Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
