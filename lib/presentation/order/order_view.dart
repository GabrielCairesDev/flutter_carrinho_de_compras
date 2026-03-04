import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/view_scaffold.dart';
import 'package:flutter_carrinho_de_compras/presentation/order/order_viewmodel.dart';
import 'package:flutter_carrinho_de_compras/presentation/order/widgets/order_item_tile.dart';
import 'package:flutter_carrinho_de_compras/presentation/order/widgets/order_summary.dart';
import 'package:flutter_carrinho_de_compras/presentation/order/widgets/success_banner.dart';
import 'package:flutter_carrinho_de_compras/routes/app_routes.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  late final OrderViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = OrderViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void _onNewOrder() {
    viewModel.newOrder();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.catalog,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => _build(context),
    );
  }

  Widget _build(BuildContext context) {
    final cart = viewModel.cart;

    return ViewScaffold(
      appBar: AppBar(
        title: const Text('Pedido Finalizado'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SuccessBanner(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: cart.items.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OrderItemTile(item: cart.items[index]),
              ),
            ),
          ),
          OrderSummary(
            subtotal: viewModel.subtotal,
            shippingFee: OrderViewModel.shippingFee,
            total: viewModel.total,
          ),
          _NewOrderButton(onNewOrder: _onNewOrder),
        ],
      ),
    );
  }
}

class _NewOrderButton extends StatelessWidget {
  final VoidCallback onNewOrder;

  const _NewOrderButton({required this.onNewOrder});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onNewOrder,
          icon: const Icon(Icons.shopping_bag_outlined),
          label: const Text('Novo Pedido'),
          style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
        ),
      ),
    );
  }
}
