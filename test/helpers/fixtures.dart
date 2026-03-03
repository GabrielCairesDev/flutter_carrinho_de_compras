import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';
import 'package:flutter_carrinho_de_compras/domain/models/product.dart';

Product makeProduct({int id = 1, String title = 'Produto', double price = 10.0}) =>
    Product(id: id, title: title, price: price, image: 'https://example.com/$id.jpg');

final tProduct1 = makeProduct(id: 1, title: 'Produto 1', price: 10.0);
final tProduct2 = makeProduct(id: 2, title: 'Produto 2', price: 25.0);
final tProduct3 = makeProduct(id: 3, title: 'Produto 3', price: 5.0);

final tProducts = [tProduct1, tProduct2, tProduct3];

List<Product> make10Products() => List.generate(
      10,
      (i) => makeProduct(id: i + 1, title: 'Produto ${i + 1}', price: (i + 1) * 5.0),
    );

Cart makeCart({List<CartItem>? items, bool isFinished = false}) =>
    Cart(items: items ?? [], isFinished: isFinished);

Cart cartWith(List<(Product, int)> entries, {bool isFinished = false}) => Cart(
      items: entries.map((e) => CartItem(product: e.$1, quantity: e.$2)).toList(),
      isFinished: isFinished,
    );
