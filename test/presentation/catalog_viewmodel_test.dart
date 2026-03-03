import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/catalog_viewmodel.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

void main() {
  late CatalogViewModel viewModel;
  late FakeProductsApi fakeProductsApi;
  late FakeCartApi fakeCartApi;

  setUp(() {
    CartStore.instance.clear();
    fakeProductsApi = FakeProductsApi(products: tProducts);
    fakeCartApi = FakeCartApi();
    viewModel = CatalogViewModel(
      productsApi: fakeProductsApi,
      cartApi: fakeCartApi,
    );
  });

  tearDown(() {
    viewModel.dispose();
    CartStore.instance.clear();
  });

  group('loadProducts', () {
    test('transiciona running para true e depois false', () async {
      bool ranWhileRunning = false;
      viewModel.addListener(() {
        if (viewModel.loadProducts.running) ranWhileRunning = true;
      });

      await viewModel.loadProducts.execute();

      expect(ranWhileRunning, isTrue);
      expect(viewModel.loadProducts.running, isFalse);
    });

    test('em caso de sucesso popula a lista de produtos', () async {
      await viewModel.loadProducts.execute();

      expect(viewModel.products, hasLength(tProducts.length));
      expect(viewModel.products.first.id, tProducts.first.id);
    });

    test('em caso de sucesso o result é Success', () async {
      await viewModel.loadProducts.execute();

      expect(viewModel.loadProducts.result, isA<Success>());
    });

    test('em caso de falha o result é Failure e lista permanece vazia', () async {
      fakeProductsApi = FakeProductsApi(shouldFail: true);
      viewModel.dispose();
      viewModel = CatalogViewModel(
        productsApi: fakeProductsApi,
        cartApi: fakeCartApi,
      );

      await viewModel.loadProducts.execute();

      expect(viewModel.loadProducts.result, isA<Failure>());
      expect(viewModel.products, isEmpty);
    });
  });

  group('addToCart', () {
    test('sucesso adiciona produto ao CartStore', () async {
      await viewModel.addToCart.execute(tProduct1);

      expect(viewModel.addToCart.result, isA<Success>());
      expect(CartStore.instance.cart.containsProduct(tProduct1.id), isTrue);
    });

    test('falha da API propaga Failure', () async {
      fakeCartApi.shouldFail = true;

      await viewModel.addToCart.execute(tProduct1);

      expect(viewModel.addToCart.result, isA<Failure>());
      expect(CartStore.instance.cart.items, isEmpty);
    });

    test('bloqueado quando o carrinho já tem 10 produtos diferentes', () async {
      final products = make10Products();
      final items = products.map((p) => CartItem(product: p)).toList();
      CartStore.instance.setCart(Cart(items: items));

      final extraProduct = makeProduct(id: 99, title: 'Extra');
      await viewModel.addToCart.execute(extraProduct);

      final result = viewModel.addToCart.result as Failure;
      expect(result.message, contains('10'));
      expect(CartStore.instance.cart.uniqueCount, 10);
    });

    test('bloqueado quando o carrinho está finalizado', () async {
      CartStore.instance.setCart(Cart(
        items: [CartItem(product: tProduct1)],
        isFinished: true,
      ));

      await viewModel.addToCart.execute(tProduct2);

      expect(viewModel.addToCart.result, isA<Failure>());
    });

    test('incrementa quantidade se produto já está no carrinho', () async {
      await viewModel.addToCart.execute(tProduct1);
      await viewModel.addToCart.execute(tProduct1);

      expect(CartStore.instance.quantityForProduct(tProduct1.id), 2);
    });
  });

  group('incrementQuantity', () {
    test('sucesso aumenta quantidade do produto no CartStore', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1, quantity: 2)]));

      await viewModel.incrementQuantity.execute(tProduct1);

      expect(viewModel.incrementQuantity.result, isA<Success>());
      expect(CartStore.instance.quantityForProduct(tProduct1.id), 3);
    });

    test('bloqueado quando o carrinho está finalizado', () async {
      CartStore.instance.setCart(Cart(
        items: [CartItem(product: tProduct1)],
        isFinished: true,
      ));

      await viewModel.incrementQuantity.execute(tProduct1);

      expect(viewModel.incrementQuantity.result, isA<Failure>());
    });
  });

  group('decrementQuantity', () {
    test('decrementa quantidade quando qty > 1', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1, quantity: 3)]));

      await viewModel.decrementQuantity.execute(tProduct1);

      expect(CartStore.instance.quantityForProduct(tProduct1.id), 2);
    });

    test('remove o item quando qty é 1', () async {
      CartStore.instance.setCart(Cart(items: [CartItem(product: tProduct1, quantity: 1)]));

      await viewModel.decrementQuantity.execute(tProduct1);

      expect(CartStore.instance.cart.containsProduct(tProduct1.id), isFalse);
    });
  });

  group('isCartOperationRunning', () {
    test('é true enquanto addToCart está em execução', () async {
      bool runningObserved = false;
      viewModel.addListener(() {
        if (viewModel.isCartOperationRunning) runningObserved = true;
      });

      await viewModel.addToCart.execute(tProduct1);

      expect(runningObserved, isTrue);
      expect(viewModel.isCartOperationRunning, isFalse);
    });
  });
}
