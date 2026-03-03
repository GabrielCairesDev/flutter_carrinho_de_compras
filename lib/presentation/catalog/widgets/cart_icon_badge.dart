import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/routes/app_routes.dart';

class CartIconBadge extends StatelessWidget {
  final int count;

  const CartIconBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      child: IconButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
