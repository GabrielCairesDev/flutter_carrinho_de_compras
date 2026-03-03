import 'package:flutter/foundation.dart';
import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/data/services/cart_api.dart';
import 'package:flutter_carrinho_de_compras/data/services/products_api.dart';
import 'package:flutter_carrinho_de_compras/domain/models/product.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';

class CatalogViewModel extends ChangeNotifier {
  final ProductsApi _productsApi = ProductsApi();
  final CartApi _cartApi = CartApi();

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _loadError = '';
  String get errorMessage => _loadError;

  String _cartError = '';
  String get cartError => _cartError;

  String _cartSuccess = '';
  String get cartSuccess => _cartSuccess;

  String get emptyMessage =>
      _products.isEmpty && !_isLoading && _loadError.isEmpty
      ? 'Nenhum produto encontrado.'
      : '';

  Future<void> loadProducts() async {
    _isLoading = true;
    _loadError = '';
    notifyListeners();

    final result = await _productsApi.getProducts();

    _isLoading = false;
    switch (result) {
      case Success(:final data):
        _products = data;
        _loadError = '';
      case Failure(:final message):
        _loadError = message;
        _products = [];
    }
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    final current = CartStore.instance.cart;
    final result = await _cartApi.addItem(current, product);
    switch (result) {
      case Success(:final data):
        CartStore.instance.setCart(data);
        _cartSuccess = '${product.title} adicionado ao carrinho!';
        _cartError = '';
      case Failure(:final message):
        _cartError = message;
        _cartSuccess = '';
    }
    notifyListeners();
  }

  Future<void> incrementQuantity(Product product) async {
    final qty = CartStore.instance.quantityForProduct(product.id);
    final result = await _cartApi.updateQuantity(
      CartStore.instance.cart,
      product.id,
      qty + 1,
    );
    switch (result) {
      case Success(:final data):
        CartStore.instance.setCart(data);
        _cartSuccess = 'Quantidade atualizada!';
        _cartError = '';
      case Failure(:final message):
        _cartError = message;
        _cartSuccess = '';
    }
    notifyListeners();
  }

  Future<void> decrementQuantity(Product product) async {
    final qty = CartStore.instance.quantityForProduct(product.id);
    final result = qty == 1
        ? await _cartApi.removeItem(CartStore.instance.cart, product.id)
        : await _cartApi.updateQuantity(
            CartStore.instance.cart,
            product.id,
            qty - 1,
          );
    switch (result) {
      case Success(:final data):
        CartStore.instance.setCart(data);
        _cartSuccess = qty == 1
            ? '${product.title} removido do carrinho!'
            : 'Quantidade atualizada!';
        _cartError = '';
      case Failure(:final message):
        _cartError = message;
        _cartSuccess = '';
    }
    notifyListeners();
  }

  void consumeCartFeedback() {
    _cartError = '';
    _cartSuccess = '';
  }
}
