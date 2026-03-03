import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';

import '../helpers/fixtures.dart';

void main() {
  group('CartItem', () {
    test('quantity padrão é 1', () {
      final item = CartItem(product: tProduct1);
      expect(item.quantity, 1);
    });

    test('subtotal é price × quantity com quantity = 1', () {
      final item = CartItem(product: tProduct1, quantity: 1);
      expect(item.subtotal, closeTo(10.0, 0.001));
    });

    test('subtotal é price × quantity com quantity > 1', () {
      final item = CartItem(product: tProduct2, quantity: 3);
      // 25.0 × 3 = 75.0
      expect(item.subtotal, closeTo(75.0, 0.001));
    });

    test('quantity pode ser alterado após criação', () {
      final item = CartItem(product: tProduct1, quantity: 2);
      item.quantity = 5;
      expect(item.quantity, 5);
      expect(item.subtotal, closeTo(50.0, 0.001));
    });
  });
}
