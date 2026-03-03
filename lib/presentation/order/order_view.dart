import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/presentation/order/order_viewmodel.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido Finalizado'),
      ),
      body: const Center(
        child: Text('Resumo do pedido'),
      ),
    );
  }
}
