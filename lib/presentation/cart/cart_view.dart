import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/app_snackbar.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/view_scaffold.dart';
import 'package:flutter_carrinho_de_compras/presentation/cart/cart_viewmodel.dart';
import 'package:flutter_carrinho_de_compras/presentation/cart/widgets/cart_item_tile.dart';
import 'package:flutter_carrinho_de_compras/presentation/cart/widgets/order_summary.dart';
import 'package:flutter_carrinho_de_compras/presentation/store/cart_store.dart';
import 'package:flutter_carrinho_de_compras/routes/app_routes.dart';

class CartView extends StatefulWidget {
  const CartView({super.key, this.viewModelFactory});

  final CartViewModel Function()? viewModelFactory;

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late final CartViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModelFactory?.call() ?? CartViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void _handleItemResult(Result<dynamic>? result) {
    if (!mounted || result == null) return;
    if (result case Failure(:final message)) {
      showErrorSnackbar(context, message);
    }
  }

  Future<void> _onCheckout() async {
    await viewModel.checkout.execute();
    if (!mounted) return;
    switch (viewModel.checkout.result) {
      case Success():
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.order,
          (route) => route.settings.name == AppRoutes.catalog,
        );
      case Failure(:final message):
        showErrorSnackbar(context, message);
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([viewModel, CartStore.instance]),
      builder: (context, _) {
        return ViewScaffold(
          appBar: AppBar(title: const Text('Carrinho')),
          isLoading: viewModel.checkout.running,
          emptyMessage: viewModel.cart.items.isEmpty
              ? 'Seu carrinho está vazio.'
              : '',
          emptyIcon: Icons.shopping_cart_outlined,
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: viewModel.cart.items.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.cart.items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CartItemTile(
                        item: item,
                        isLoading: viewModel.isItemOperationRunning,
                        onIncrement: () async {
                          await viewModel.incrementItem.execute(
                            item.product.id,
                          );
                          _handleItemResult(viewModel.incrementItem.result);
                        },
                        onDecrement: () async {
                          await viewModel.decrementItem.execute(
                            item.product.id,
                          );
                          _handleItemResult(viewModel.decrementItem.result);
                        },
                        onRemove: () async {
                          await viewModel.removeItem.execute(item.product.id);
                          _handleItemResult(viewModel.removeItem.result);
                        },
                      ),
                    );
                  },
                ),
              ),
              OrderSummary(cart: viewModel.cart),
              _CheckoutButton(
                isLoading: viewModel.isItemOperationRunning,
                onCheckout: _onCheckout,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCheckout;

  const _CheckoutButton({required this.isLoading, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: isLoading ? null : onCheckout,
          icon: const Icon(Icons.check_circle_outline_rounded),
          label: const Text('Finalizar Pedido'),
          style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
        ),
      ),
    );
  }
}
