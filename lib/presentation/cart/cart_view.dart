import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/presentation/cart/cart_viewmodel.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late final CartViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CartViewModel();
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
        title: const Text('Carrinho'),
      ),
      body: const Center(
        child: Text('Itens do carrinho'),
      ),
    );
  }
}
