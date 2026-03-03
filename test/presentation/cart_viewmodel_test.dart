import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';
import 'package:flutter_carrinho_de_compras/presentation/cart/cart_viewmodel.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

void main() {
  late CartViewModel viewModel;
  late FakeCartApi fakeCartApi;
  late FakeCheckoutApi fakeCheckoutApi;

  setUp(() {
    CartStore.instance.clear();
    fakeCartApi = FakeCartApi();
    fakeCheckoutApi = FakeCheckoutApi();
    viewModel = CartViewModel(
      cartApi: fakeCartApi,
      checkoutApi: fakeCheckoutApi,
    );
  });

  tearDown(() {
    viewModel.dispose();
    CartStore.instance.clear();
  });

  group('removeItem', () {
    test('sucesso remove o produto do CartStore', () async {
      CartStore.instance.setCart(Cart(items: [
        CartItem(product: tProduct1),
        CartItem(product: tProduct2),
      ]));

      await viewModel.removeItem.execute(tProduct1.id);

      expect(viewModel.removeItem.result, isA<Success>());
      expect(CartStore.instance.cart.containsProduct(tProduct1.id), isFalse);
      expect(CartStore.instance.cart.containsProduct(tProduct2.id), isTrue);
    });

    test('falha da API propaga Failure e CartStore não é alterado', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1)]));
      fakeCartApi.shouldFail = true;

      await viewModel.removeItem.execute(tProduct1.id);

      expect(viewModel.removeItem.result, isA<Failure>());
      expect(CartStore.instance.cart.containsProduct(tProduct1.id), isTrue);
    });

    test('bloqueado quando o carrinho está finalizado', () async {
      CartStore.instance.setCart(Cart(
        items: [CartItem(product: tProduct1)],
        isFinished: true,
      ));

      await viewModel.removeItem.execute(tProduct1.id);

      expect(viewModel.removeItem.result, isA<Failure>());
    });
  });

  group('incrementItem', () {
    test('sucesso aumenta quantidade no CartStore', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1, quantity: 1)]));

      await viewModel.incrementItem.execute(tProduct1.id);

      expect(viewModel.incrementItem.result, isA<Success>());
      expect(CartStore.instance.quantityForProduct(tProduct1.id), 2);
    });

    test('bloqueado quando o carrinho está finalizado', () async {
      CartStore.instance.setCart(Cart(
        items: [CartItem(product: tProduct1)],
        isFinished: true,
      ));

      await viewModel.incrementItem.execute(tProduct1.id);

      expect(viewModel.incrementItem.result, isA<Failure>());
      expect(CartStore.instance.quantityForProduct(tProduct1.id), 1);
    });
  });

  group('decrementItem', () {
    test('decrementa quantidade quando qty > 1', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1, quantity: 3)]));

      await viewModel.decrementItem.execute(tProduct1.id);

      expect(CartStore.instance.quantityForProduct(tProduct1.id), 2);
    });

    test('remove item quando qty é 1', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1, quantity: 1)]));

      await viewModel.decrementItem.execute(tProduct1.id);

      expect(CartStore.instance.cart.containsProduct(tProduct1.id), isFalse);
    });
  });

  group('checkout', () {
    test('sucesso marca o carrinho como finalizado no CartStore', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1)]));

      await viewModel.checkout.execute();

      expect(viewModel.checkout.result, isA<Success>());
      expect(CartStore.instance.cart.isFinished, isTrue);
    });

    test('mantém os itens do carrinho após checkout bem-sucedido', () async {
      CartStore.instance.setCart(Cart(items: [
        CartItem(product: tProduct1, quantity: 2),
        CartItem(product: tProduct2, quantity: 1),
      ]));

      await viewModel.checkout.execute();

      expect(CartStore.instance.cart.items, hasLength(2));
    });

    test('retorna Failure quando o carrinho está vazio', () async {
      await viewModel.checkout.execute();

      expect(viewModel.checkout.result, isA<Failure>());
    });

    test('retorna Failure quando o carrinho já está finalizado', () async {
      CartStore.instance.setCart(Cart(
        items: [CartItem(product: tProduct1)],
        isFinished: true,
      ));

      await viewModel.checkout.execute();

      expect(viewModel.checkout.result, isA<Failure>());
    });

    test('falha da API propaga Failure e cart não é marcado como finalizado', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1)]));
      fakeCheckoutApi = FakeCheckoutApi(shouldFail: true);
      viewModel.dispose();
      viewModel = CartViewModel(cartApi: fakeCartApi, checkoutApi: fakeCheckoutApi);

      await viewModel.checkout.execute();

      expect(viewModel.checkout.result, isA<Failure>());
      expect(CartStore.instance.cart.isFinished, isFalse);
    });
  });

  group('isItemOperationRunning', () {
    test('é true enquanto removeItem está em execução', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1)]));
      bool runningObserved = false;
      viewModel.addListener(() {
        if (viewModel.isItemOperationRunning) runningObserved = true;
      });

      await viewModel.removeItem.execute(tProduct1.id);

      expect(runningObserved, isTrue);
      expect(viewModel.isItemOperationRunning, isFalse);
    });
  });
}
