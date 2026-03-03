import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/presentation/cart/cart_view.dart';
import 'package:flutter_carrinho_de_compras/presentation/catalog/catalog_view.dart';
import 'package:flutter_carrinho_de_compras/presentation/order/order_view.dart';

abstract class AppRoutes {
  static const catalog = '/';
  static const cart = '/cart';
  static const order = '/order';

  static Map<String, WidgetBuilder> get routes => {
        catalog: (_) => const CatalogView(),
        cart: (_) => const CartView(),
        order: (_) => const OrderView(),
      };
}
