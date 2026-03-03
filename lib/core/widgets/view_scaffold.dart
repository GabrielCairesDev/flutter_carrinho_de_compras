import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/empty_state.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/error_state.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/loading_state.dart';

class ViewScaffold extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final String emptyMessage;
  final bool isLoading;
  final String errorMessage;
  const ViewScaffold({
    super.key,
    required this.appBar,
    required this.body,
    this.emptyMessage = '',
    this.isLoading = false,
    this.errorMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const LoadingState()
          : errorMessage.isNotEmpty
          ? ErrorState(message: errorMessage)
          : emptyMessage.isNotEmpty
          ? EmptyState(message: emptyMessage)
          : body,
    );
  }
}
