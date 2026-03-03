import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrinho de Compras',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.catalog,
      routes: AppRoutes.routes,
    );
  }
}
