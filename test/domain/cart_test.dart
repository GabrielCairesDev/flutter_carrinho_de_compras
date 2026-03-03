import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';

import '../helpers/fixtures.dart';

void main() {
  group('Cart', () {
    test('carrinho vazio tem uniqueCount = 0', () {
      const cart = Cart();
      expect(cart.uniqueCount, 0);
    });

    test('carrinho vazio tem totalItems = 0', () {
      const cart = Cart();
      expect(cart.totalItems, 0);
    });

    test('carrinho vazio tem subtotal = 0.0', () {
      const cart = Cart();
      expect(cart.subtotal, 0.0);
    });

    test('uniqueCount retorna número de produtos distintos', () {
      final cart = cartWith([(tProduct1, 3), (tProduct2, 1)]);
      expect(cart.uniqueCount, 2);
    });

    test('totalItems soma todas as quantidades', () {
      final cart = cartWith([(tProduct1, 3), (tProduct2, 2)]);
      expect(cart.totalItems, 5);
    });

    test('subtotal soma os subtotais de cada item', () {
      // 3 × 10.0 + 2 × 25.0 = 30.0 + 50.0 = 80.0
      final cart = cartWith([(tProduct1, 3), (tProduct2, 2)]);
      expect(cart.subtotal, closeTo(80.0, 0.001));
    });

    test('containsProduct retorna true quando produto está no carrinho', () {
      final cart = cartWith([(tProduct1, 1)]);
      expect(cart.containsProduct(tProduct1.id), isTrue);
    });

    test('containsProduct retorna false quando produto não está no carrinho', () {
      final cart = cartWith([(tProduct1, 1)]);
      expect(cart.containsProduct(tProduct2.id), isFalse);
    });

    test('isFinished é false por padrão', () {
      const cart = Cart();
      expect(cart.isFinished, isFalse);
    });

    test('Cart pode ser marcado como finalizado', () {
      final cart = Cart(
        items: [CartItem(product: tProduct1)],
        isFinished: true,
      );
      expect(cart.isFinished, isTrue);
    });
  });
}
