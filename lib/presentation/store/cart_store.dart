import 'package:flutter/foundation.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';

class CartStore extends ChangeNotifier {
  static final CartStore instance = CartStore._();
  CartStore._();

  Cart _cart = const Cart();
  Cart get cart => _cart;

  void setCart(Cart cart) {
    _cart = cart;
    notifyListeners();
  }

  void clear() {
    _cart = const Cart();
    notifyListeners();
  }

  int quantityForProduct(int productId) {
    final item = _cart.items.where((i) => i.product.id == productId).firstOrNull;
    return item?.quantity ?? 0;
  }
}
