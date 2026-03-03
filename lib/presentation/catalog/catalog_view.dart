import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/view_scaffold.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/catalog_viewmodel.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/widgets/cart_icon_badge.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/widgets/product_card.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  late final CatalogViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CatalogViewModel();
    viewModel.loadProducts();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return ViewScaffold(
          isLoading: viewModel.isLoading,
          errorMessage: viewModel.errorMessage,
          emptyMessage: viewModel.emptyMessage,
          appBar: AppBar(
            title: const Text('Catálogo'),
            actions: [
              CartIconBadge(count: CartStore.instance.cart.uniqueCount),
            ],
          ),

          body: RefreshIndicator(
            onRefresh: viewModel.loadProducts,
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
                    onAdd: () => viewModel.addToCart(product),
                    onIncrement: () => viewModel.incrementQuantity(product),
                    onDecrement: () => viewModel.decrementQuantity(product),
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
