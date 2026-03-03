import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';

class Cart {
  final List<CartItem> items;
  final bool isFinished;

  const Cart({
    this.items = const [],
    this.isFinished = false,
  });

  int get uniqueCount => items.length;
  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);
  double get subtotal => items.fold(0.0, (sum, i) => sum + i.subtotal);

  bool containsProduct(int productId) =>
      items.any((i) => i.product.id == productId);
}
