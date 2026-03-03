import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carrinho_de_compras/data/dtos/product_dto.dart';

void main() {
  group('ProductDto', () {
    const tJson = {
      'id': 42,
      'title': 'Camisa Azul',
      'price': 99.9,
      'image': 'https://example.com/img.jpg',
    };

    test('fromJson mapeia todos os campos corretamente', () {
      final dto = ProductDto.fromJson(tJson);

      expect(dto.id, 42);
      expect(dto.title, 'Camisa Azul');
      expect(dto.price, closeTo(99.9, 0.001));
      expect(dto.image, 'https://example.com/img.jpg');
    });

    test('toEntity retorna Product com os mesmos valores', () {
      final product = ProductDto.fromJson(tJson).toEntity();

      expect(product.id, 42);
      expect(product.title, 'Camisa Azul');
      expect(product.price, closeTo(99.9, 0.001));
      expect(product.image, 'https://example.com/img.jpg');
    });

    test('fromJson aceita price como int convertendo para double', () {
      final dto = ProductDto.fromJson({...tJson, 'price': 50});
      expect(dto.price, isA<double>());
      expect(dto.price, closeTo(50.0, 0.001));
    });
  });
}
