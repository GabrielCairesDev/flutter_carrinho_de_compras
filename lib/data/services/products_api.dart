import 'dart:convert';
import 'dart:math';

import 'package:flutter_carrinho_de_compras/core/result.dart';
import 'package:flutter_carrinho_de_compras/domain/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsApi {
  static const _baseUrl = 'https://fakestoreapi.com';

  Future<Result<List<Product>>> getProducts() async {
    if (Random().nextDouble() < 0.2) {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Failure('Erro simulado ao carregar produtos.');
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/products'));
      if (response.statusCode != 200) {
        return Failure('Erro ao carregar: ${response.statusCode}');
      }
      final list = json.decode(response.body) as List;
      final products = list
          .map((e) => Product(
                id: e['id'] as int,
                title: e['title'] as String,
                price: (e['price'] as num).toDouble(),
                image: e['image'] as String,
              ))
          .toList();
      return Success(products);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
