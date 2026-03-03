import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/app_snackbar.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/view_scaffold.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/catalog_viewmodel.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/widgets/cart_icon_badge.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/widgets/product_card.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key, this.viewModelFactory});

  final CatalogViewModel Function()? viewModelFactory;

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  late final CatalogViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModelFactory?.call() ?? CatalogViewModel();
    viewModel.loadProducts.execute();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void _handleCartResult(Result<dynamic>? result, String productTitle) {
    if (!mounted || result == null) return;
    switch (result) {
      case Success():
        showSuccessSnackbar(context, '$productTitle adicionado ao carrinho!');
      case Failure(:final message):
        showErrorSnackbar(context, message);
    }
  }

  void _handleUpdateResult(Result<dynamic>? result, {required bool wasLastItem, required String productTitle}) {
    if (!mounted || result == null) return;
    switch (result) {
      case Success():
        final msg = wasLastItem
            ? '$productTitle removido do carrinho!'
            : 'Quantidade atualizada!';
        showSuccessSnackbar(context, msg);
      case Failure(:final message):
        showErrorSnackbar(context, message);
    }
  }

  String get _loadErrorMessage => switch (viewModel.loadProducts.result) {
        Failure(:final message) => message,
        _ => '',
      };

  String get _emptyMessage {
    if (viewModel.loadProducts.running) return '';
    if (viewModel.loadProducts.result is Failure) return '';
    return viewModel.products.isEmpty ? 'Nenhum produto encontrado.' : '';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([viewModel, CartStore.instance]),
      builder: (context, _) {
        return ViewScaffold(
          isLoading: viewModel.loadProducts.running,
          errorMessage: _loadErrorMessage,
          emptyMessage: _emptyMessage,
          appBar: AppBar(
            title: const Text('Catálogo'),
            actions: [
              CartIconBadge(count: CartStore.instance.cart.uniqueCount),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: viewModel.loadProducts.execute,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: viewModel.products.length,
              itemBuilder: (context, index) {
                final product = viewModel.products[index];
                final qty = CartStore.instance.quantityForProduct(product.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ProductCard(
                    product: product,
                    quantityInCart: qty,
                    isLoading: viewModel.isCartOperationRunning,
                    onAdd: () async {
                      await viewModel.addToCart.execute(product);
                      _handleCartResult(viewModel.addToCart.result, product.title);
                    },
                    onIncrement: () async {
                      await viewModel.incrementQuantity.execute(product);
                      _handleUpdateResult(
                        viewModel.incrementQuantity.result,
                        wasLastItem: false,
                        productTitle: product.title,
                      );
                    },
                    onDecrement: () async {
                      final wasLastItem = CartStore.instance.quantityForProduct(product.id) == 1;
                      await viewModel.decrementQuantity.execute(product);
                      _handleUpdateResult(
                        viewModel.decrementQuantity.result,
                        wasLastItem: wasLastItem,
                        productTitle: product.title,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
