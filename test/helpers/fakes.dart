import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/data/services/cart_api.dart';
import 'package:flutter_carrinho_de_compras/data/services/checkout_api.dart';
import 'package:flutter_carrinho_de_compras/data/services/products_api.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';
import 'package:flutter_carrinho_de_compras/domain/models/product.dart';

class FakeProductsApi extends ProductsApi {
  FakeProductsApi({this.shouldFail = false, this.products = const []});

  final bool shouldFail;
  final List<Product> products;

  @override
  Future<Result<List<Product>>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 1));
    if (shouldFail) return const Failure('Erro simulado ao carregar produtos.');
    return Success(List.of(products));
  }
}

class FakeCartApi extends CartApi {
  FakeCartApi({this.shouldFail = false});

  bool shouldFail;

  @override
  Future<Result<Cart>> addItem(Cart current, Product product) async {
    await Future.delayed(const Duration(milliseconds: 1));
    if (shouldFail) return const Failure('Erro ao adicionar ao carrinho.');

    final items = List<CartItem>.from(current.items);
    final idx = items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      items[idx] = CartItem(product: product, quantity: items[idx].quantity + 1);
    } else {
      items.add(CartItem(product: product, quantity: 1));
    }
    return Success(Cart(items: items));
  }

  @override
  Future<Result<Cart>> updateQuantity(Cart current, int productId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 1));
    if (shouldFail) return const Failure('Erro ao atualizar quantidade.');

    final items = List<CartItem>.from(current.items);
    final idx = items.indexWhere((i) => i.product.id == productId);
    if (idx < 0) return const Failure('Produto não encontrado.');
    items[idx] = CartItem(product: items[idx].product, quantity: quantity);
    return Success(Cart(items: items));
  }

  @override
  Future<Result<Cart>> removeItem(Cart current, int productId) async {
    await Future.delayed(const Duration(milliseconds: 1));
    if (shouldFail) return const Failure('Erro ao remover item.');

    final items = current.items.where((i) => i.product.id != productId).toList();
    return Success(Cart(items: items));
  }
}

class FakeCheckoutApi extends CheckoutApi {
  FakeCheckoutApi({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<Result<Cart>> checkout(Cart cart) async {
    await Future.delayed(const Duration(milliseconds: 1));
    if (shouldFail) return const Failure('Erro ao finalizar pedido. Tente novamente.');
    return Success(Cart(items: cart.items, isFinished: true));
  }
}
