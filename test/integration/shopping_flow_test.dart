import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carrinho_de_compras/presentation/cart/cart_view.dart';
import 'package:flutter_carrinho_de_compras/presentation/cart/cart_viewmodel.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/catalog_view.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/catalog_viewmodel.dart';
import 'package:flutter_carrinho_de_compras/presentation/order/order_view.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';
import 'package:flutter_carrinho_de_compras/routes/app_routes.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

Widget buildTestApp({bool checkoutFails = false}) {
  final fakeProductsApi = FakeProductsApi(products: tProducts);
  final fakeCartApi = FakeCartApi();
  final fakeCheckoutApi = FakeCheckoutApi(shouldFail: checkoutFails);

  return MaterialApp(
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    routes: {
      AppRoutes.catalog: (_) => CatalogView(
            viewModelFactory: () => CatalogViewModel(
              productsApi: fakeProductsApi,
              cartApi: fakeCartApi,
            ),
          ),
      AppRoutes.cart: (_) => CartView(
            viewModelFactory: () => CartViewModel(
              cartApi: fakeCartApi,
              checkoutApi: fakeCheckoutApi,
            ),
          ),
      AppRoutes.order: (_) => const OrderView(),
    },
    initialRoute: AppRoutes.catalog,
  );
}

/// O SnackBar de sucesso do catálogo persiste no ScaffoldMessenger ao navegar
/// para o carrinho. Como pumpAndSettle() não avança timers pendentes que não
/// agendaram um frame, é necessário avançar o relógio manualmente para que
/// o SnackBar seja descartado antes de interagir com elementos da CartView.
Future<void> dismissSnackbars(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => CartStore.instance.clear());
  tearDown(() => CartStore.instance.clear());

  group('Tela de Catálogo', () {
    testWidgets('exibe lista de produtos após carregamento', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Catálogo'), findsOneWidget);
      for (final p in tProducts) {
        expect(find.text(p.title, skipOffstage: false), findsOneWidget);
      }
    });

    testWidgets('exibe botão "Adicionar" para cada produto', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Adicionar', skipOffstage: false), findsNWidgets(tProducts.length));
    });

    testWidgets('tela de erro aparece quando a API falha', (tester) async {
      final app = MaterialApp(
        routes: {
          AppRoutes.catalog: (_) => CatalogView(
                viewModelFactory: () => CatalogViewModel(
                  productsApi: FakeProductsApi(shouldFail: true),
                  cartApi: FakeCartApi(),
                ),
              ),
        },
        initialRoute: AppRoutes.catalog,
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Erro simulado ao carregar produtos.'), findsOneWidget);
    });
  });

  group('Adicionar produto ao carrinho', () {
    testWidgets('botão "Adicionar" vira contador após adição', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final addButton = find.text('Adicionar').first;
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // O botão "Adicionar" do primeiro produto sumiu
      expect(find.text('Adicionar', skipOffstage: false), findsNWidgets(tProducts.length - 1));
      // Badge e counter mostram "1"
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('badge do AppBar exibe contagem de produtos únicos', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Adiciona primeiro produto
      final firstAdd = find.text('Adicionar').first;
      await tester.ensureVisible(firstAdd);
      await tester.tap(firstAdd);
      await tester.pumpAndSettle();

      // Adiciona segundo produto
      final secondAdd = find.text('Adicionar').first;
      await tester.ensureVisible(secondAdd);
      await tester.tap(secondAdd);
      await tester.pumpAndSettle();

      // Badge deve mostrar 2 (dois produtos únicos)
      expect(find.text('2'), findsWidgets);
    });
  });

  group('Tela de Carrinho', () {
    testWidgets('exibe itens adicionados ao carrinho', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final addButton = find.text('Adicionar').first;
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Navega para o carrinho
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      expect(find.text('Carrinho'), findsOneWidget);
      expect(find.text(tProducts.first.title), findsOneWidget);
      expect(find.text('Finalizar Pedido'), findsOneWidget);
    });

    testWidgets('carrinho vazio exibe mensagem de estado vazio', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      expect(find.text('Seu carrinho está vazio.'), findsOneWidget);
    });
  });

  group('Checkout', () {
    testWidgets('checkout bem-sucedido navega para tela de pedido finalizado', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final addButton = find.text('Adicionar').first;
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      await dismissSnackbars(tester);

      await tester.tap(find.text('Finalizar Pedido'));
      await tester.pumpAndSettle();

      expect(find.text('Pedido Finalizado'), findsOneWidget);
      expect(find.text('Novo Pedido'), findsOneWidget);
    });

    testWidgets('checkout com falha exibe mensagem de erro sem sair do carrinho', (tester) async {
      await tester.pumpWidget(buildTestApp(checkoutFails: true));
      await tester.pumpAndSettle();

      final addButton = find.text('Adicionar').first;
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      await dismissSnackbars(tester);

      await tester.tap(find.text('Finalizar Pedido'));
      await tester.pumpAndSettle();

      expect(find.text('Carrinho'), findsOneWidget);
      expect(find.text('Pedido Finalizado'), findsNothing);
    });
  });

  group('Tela de Pedido Finalizado', () {
    testWidgets('exibe itens do pedido e botão de novo pedido', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final addButton = find.text('Adicionar').first;
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      await dismissSnackbars(tester);
      await tester.tap(find.text('Finalizar Pedido'));
      await tester.pumpAndSettle();

      expect(find.text(tProducts.first.title), findsOneWidget);
      expect(find.text('Novo Pedido'), findsOneWidget);
    });

    testWidgets('não exibe botão de voltar (sem retorno ao carrinho)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final addButton = find.text('Adicionar').first;
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      await dismissSnackbars(tester);
      await tester.tap(find.text('Finalizar Pedido'));
      await tester.pumpAndSettle();

      // automaticallyImplyLeading: false → sem botão de voltar
      expect(find.byType(BackButton), findsNothing);
    });
  });

  group('Fluxo completo', () {
    testWidgets('novo pedido retorna ao catálogo com carrinho limpo', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Adiciona produto → carrinho → checkout → pedido finalizado
      final addButton = find.text('Adicionar').first;
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      await dismissSnackbars(tester);
      await tester.tap(find.text('Finalizar Pedido'));
      await tester.pumpAndSettle();

      // Inicia novo pedido
      await tester.tap(find.text('Novo Pedido'));
      await tester.pumpAndSettle();

      // Voltou ao catálogo
      expect(find.text('Catálogo'), findsOneWidget);
      // CartStore foi limpo – badge não aparece
      expect(CartStore.instance.cart.items, isEmpty);
    });
  });
}
