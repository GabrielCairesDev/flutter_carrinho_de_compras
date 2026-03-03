import 'package:flutter_carrinho_de_compras/domain/models/product.dart';

class ProductDto {
  final int id;
  final String title;
  final double price;
  final String image;

  const ProductDto({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) => ProductDto(
        id: json['id'] as int,
        title: json['title'] as String,
        price: (json['price'] as num).toDouble(),
        image: json['image'] as String,
      );

  Product toEntity() => Product(
        id: id,
        title: title,
        price: price,
        image: image,
      );
}
