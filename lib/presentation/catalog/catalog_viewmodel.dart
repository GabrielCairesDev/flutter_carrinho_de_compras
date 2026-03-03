import 'package:flutter/foundation.dart';
import 'package:flutter_carrinho_de_compras/core/command.dart';
import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/data/services/cart_api.dart';
import 'package:flutter_carrinho_de_compras/data/services/products_api.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/domain/models/product.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';

class CatalogViewModel extends ChangeNotifier {
  CatalogViewModel({ProductsApi? productsApi, CartApi? cartApi})
      : _productsApi = productsApi ?? ProductsApi(),
        _cartApi = cartApi ?? CartApi() {
    loadProducts = Command(_loadProducts);
    addToCart = Command1(_addToCart);
    incrementQuantity = Command1(_incrementQuantity);
    decrementQuantity = Command1(_decrementQuantity);

    loadProducts.addListener(notifyListeners);
    addToCart.addListener(notifyListeners);
    incrementQuantity.addListener(notifyListeners);
    decrementQuantity.addListener(notifyListeners);
  }

  final ProductsApi _productsApi;
  final CartApi _cartApi;

  List<Product> _products = [];
  List<Product> get products => _products;

  bool get isCartOperationRunning =>
      addToCart.running || incrementQuantity.running || decrementQuantity.running;

  late final Command<List<Product>> loadProducts;
  late final Command1<Cart, Product> addToCart;
  late final Command1<Cart, Product> incrementQuantity;
  late final Command1<Cart, Product> decrementQuantity;

  @override
  void dispose() {
    loadProducts.dispose();
    addToCart.dispose();
    incrementQuantity.dispose();
    decrementQuantity.dispose();
    super.dispose();
  }

  Future<Result<List<Product>>> _loadProducts() async {
    final result = await _productsApi.getProducts();
    if (result case Success(:final data)) {
      _products = data;
    }
    return result;
  }

  Future<Result<Cart>> _addToCart(Product product) async {
    final cart = CartStore.instance.cart;
    if (cart.isFinished) {
      return const Failure('Não é possível editar um carrinho finalizado.');
    }
    if (cart.uniqueCount >= 10 && !cart.containsProduct(product.id)) {
      return const Failure('Máximo de 10 produtos diferentes no carrinho.');
    }
    final result = await _cartApi.addItem(cart, product);
    if (result case Success(:final data)) {
      CartStore.instance.setCart(data);
    }
    return result;
  }

  Future<Result<Cart>> _incrementQuantity(Product product) async {
    final cart = CartStore.instance.cart;
    if (cart.isFinished) {
      return const Failure('Não é possível editar um carrinho finalizado.');
    }
    final qty = CartStore.instance.quantityForProduct(product.id);
    final result = await _cartApi.updateQuantity(cart, product.id, qty + 1);
    if (result case Success(:final data)) {
      CartStore.instance.setCart(data);
    }
    return result;
  }

  Future<Result<Cart>> _decrementQuantity(Product product) async {
    final cart = CartStore.instance.cart;
    if (cart.isFinished) {
      return const Failure('Não é possível editar um carrinho finalizado.');
    }
    final qty = CartStore.instance.quantityForProduct(product.id);
    final result = qty == 1
        ? await _cartApi.removeItem(cart, product.id)
        : await _cartApi.updateQuantity(cart, product.id, qty - 1);
    if (result case Success(:final data)) {
      CartStore.instance.setCart(data);
    }
    return result;
  }
}
