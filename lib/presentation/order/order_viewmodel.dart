import 'package:flutter/foundation.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';

class OrderViewModel extends ChangeNotifier {
  OrderViewModel() {
    CartStore.instance.addListener(notifyListeners);
  }

  static const double shippingFee = 15.00;

  Cart get cart => CartStore.instance.cart;

  double get subtotal => cart.subtotal;

  double get total => subtotal + shippingFee;

  void newOrder() {
    CartStore.instance.clear();
  }

  @override
  void dispose() {
    CartStore.instance.removeListener(notifyListeners);
    super.dispose();
  }
}
