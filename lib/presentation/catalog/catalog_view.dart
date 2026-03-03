import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/catalog_viewmodel.dart';

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
        title: const Text('Catálogo'),
      ),
      body: const Center(
        child: Text('Catálogo de produtos'),
      ),
    );
  }
}
