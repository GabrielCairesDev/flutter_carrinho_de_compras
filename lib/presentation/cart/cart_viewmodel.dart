import 'package:flutter/foundation.dart';
import 'package:flutter_carrinho_de_compras/core/command.dart';
import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/data/services/cart_api.dart';
import 'package:flutter_carrinho_de_compras/data/services/checkout_api.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel() {
    removeItem = Command1(_removeItem);
    incrementItem = Command1(_incrementItem);
    decrementItem = Command1(_decrementItem);
    checkout = Command(_checkout);

    removeItem.addListener(notifyListeners);
    incrementItem.addListener(notifyListeners);
    decrementItem.addListener(notifyListeners);
    checkout.addListener(notifyListeners);
  }

  final _cartApi = CartApi();
  final _checkoutApi = CheckoutApi();

  late final Command1<Cart, int> removeItem;
  late final Command1<Cart, int> incrementItem;
  late final Command1<Cart, int> decrementItem;
  late final Command<Cart> checkout;

  bool get isItemOperationRunning =>
      removeItem.running || incrementItem.running || decrementItem.running;

  Cart get cart => CartStore.instance.cart;

  @override
  void dispose() {
    removeItem.dispose();
    incrementItem.dispose();
    decrementItem.dispose();
    checkout.dispose();
    super.dispose();
  }

  Future<Result<Cart>> _removeItem(int productId) async {
    final cart = CartStore.instance.cart;
    if (cart.isFinished) {
      return const Failure('Não é possível editar um carrinho finalizado.');
    }
    final result = await _cartApi.removeItem(cart, productId);
    if (result case Success(:final data)) {
      CartStore.instance.setCart(data);
    }
    return result;
  }

  Future<Result<Cart>> _incrementItem(int productId) async {
    final cart = CartStore.instance.cart;
    if (cart.isFinished) {
      return const Failure('Não é possível editar um carrinho finalizado.');
    }
    final qty = CartStore.instance.quantityForProduct(productId);
    final result = await _cartApi.updateQuantity(cart, productId, qty + 1);
    if (result case Success(:final data)) {
      CartStore.instance.setCart(data);
    }
    return result;
  }

  Future<Result<Cart>> _decrementItem(int productId) async {
    final cart = CartStore.instance.cart;
    if (cart.isFinished) {
      return const Failure('Não é possível editar um carrinho finalizado.');
    }
    final qty = CartStore.instance.quantityForProduct(productId);
    final result = qty == 1
        ? await _cartApi.removeItem(cart, productId)
        : await _cartApi.updateQuantity(cart, productId, qty - 1);
    if (result case Success(:final data)) {
      CartStore.instance.setCart(data);
    }
    return result;
  }

  Future<Result<Cart>> _checkout() async {
    final cart = CartStore.instance.cart;
    if (cart.items.isEmpty) {
      return const Failure('Seu carrinho está vazio.');
    }
    if (cart.isFinished) {
      return const Failure('Este pedido já foi finalizado.');
    }
    final result = await _checkoutApi.checkout(cart);
    if (result case Success(:final data)) {
      CartStore.instance.setCart(data);
    }
    return result;
  }
}
