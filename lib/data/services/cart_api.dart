import 'dart:math';

import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';
import 'package:flutter_carrinho_de_compras/domain/models/product.dart';

class CartApi {
  static const _maxProducts = 10;

  Future<Result<Cart>> addItem(Cart current, Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (Random().nextDouble() < 0.15) {
      return const Failure('Erro simulado ao adicionar ao carrinho.');
    }
    if (current.isFinished) {
      return const Failure('Não é possível editar carrinho finalizado.');
    }
    if (current.uniqueCount >= _maxProducts && !_hasProduct(current, product)) {
      return const Failure('Máximo de 10 produtos diferentes no carrinho.');
    }

    final items = List<CartItem>.from(current.items);
    final idx = items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      items[idx] = CartItem(product: product, quantity: items[idx].quantity + 1);
    } else {
      items.add(CartItem(product: product, quantity: 1));
    }
    return Success(Cart(items: items));
  }

  Future<Result<Cart>> updateQuantity(
    Cart current,
    int productId,
    int quantity,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (Random().nextDouble() < 0.15) {
      return const Failure('Erro simulado ao atualizar quantidade.');
    }
    if (current.isFinished) {
      return const Failure('Não é possível editar carrinho finalizado.');
    }
    if (quantity < 1) {
      return const Failure('Quantidade inválida.');
    }

    final items = List<CartItem>.from(current.items);
    final idx = items.indexWhere((i) => i.product.id == productId);
    if (idx < 0) return Failure('Produto não encontrado.');
    items[idx] = CartItem(product: items[idx].product, quantity: quantity);
    return Success(Cart(items: items));
  }

  Future<Result<Cart>> removeItem(Cart current, int productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (Random().nextDouble() < 0.15) {
      return const Failure('Erro simulado ao remover item.');
    }
    if (current.isFinished) {
      return const Failure('Não é possível editar carrinho finalizado.');
    }

    final items = current.items.where((i) => i.product.id != productId).toList();
    return Success(Cart(items: items));
  }

  bool _hasProduct(Cart cart, Product product) {
    return cart.items.any((i) => i.product.id == product.id);
  }
}
