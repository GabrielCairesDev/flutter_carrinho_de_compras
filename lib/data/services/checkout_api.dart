import 'dart:math';

import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';

class CheckoutApi {
  static const _errorRate = 0.2;

  Future<Result<Cart>> checkout(Cart cart) async {
    await Future.delayed(const Duration(seconds: 1));
    if (Random().nextDouble() < _errorRate) {
      return const Failure('Erro ao finalizar pedido. Tente novamente.');
    }
    return Success(Cart(items: cart.items, isFinished: true));
  }
}
