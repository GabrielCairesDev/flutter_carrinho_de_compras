import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';
import 'package:flutter_carrinho_de_compras/presentation/order/order_viewmodel.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';

import '../helpers/fixtures.dart';

void main() {
  late OrderViewModel viewModel;

  setUp(() {
    CartStore.instance.clear();
    viewModel = OrderViewModel();
  });

  tearDown(() {
    viewModel.dispose();
    CartStore.instance.clear();
  });

  group('OrderViewModel', () {
    test('shippingFee é R\$ 15,00', () {
      expect(OrderViewModel.shippingFee, closeTo(15.0, 0.001));
    });

    test('subtotal reflete o subtotal do CartStore', () {
      // 2 × 10.0 + 1 × 25.0 = 45.0
      CartStore.instance.setCart(Cart(items: [
        CartItem(product: tProduct1, quantity: 2),
        CartItem(product: tProduct2, quantity: 1),
      ], isFinished: true));

      expect(viewModel.subtotal, closeTo(45.0, 0.001));
    });

    test('total é subtotal + shippingFee', () {
      CartStore.instance.setCart(Cart(items: [
        CartItem(product: tProduct1, quantity: 2),
      ], isFinished: true));
      // subtotal = 20.0, frete = 15.0 → total = 35.0
      expect(viewModel.total, closeTo(35.0, 0.001));
    });

    test('total de carrinho vazio é apenas o frete', () {
      expect(viewModel.total, closeTo(OrderViewModel.shippingFee, 0.001));
    });

    test('newOrder limpa o CartStore', () {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1)], isFinished: true));

      viewModel.newOrder();

      expect(CartStore.instance.cart.items, isEmpty);
      expect(CartStore.instance.cart.isFinished, isFalse);
    });

    test('notifica listeners quando CartStore muda', () {
      int notifyCount = 0;
      viewModel.addListener(() => notifyCount++);

      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1)]));

      expect(notifyCount, greaterThan(0));
    });
  });
}
