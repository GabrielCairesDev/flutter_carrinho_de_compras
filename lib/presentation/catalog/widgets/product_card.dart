import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/utils/currency_formatter.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/image_error_widget.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/image_skeleton.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/quantity_counter.dart';
import 'package:flutter_carrinho_de_compras/domain/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int quantityInCart;
  final bool isLoading;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductCard({
    super.key,
    required this.product,
    required this.quantityInCart,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: _ProductImage(image: product.image, cs: cs),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formatBRL(product.price),
                    style: tt.titleSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (quantityInCart == 0)
                    _AddButton(isLoading: isLoading, onAdd: onAdd)
                  else
                    Center(
                      child: QuantityCounter(
                        quantity: quantityInCart,
                        onIncrement: isLoading ? null : onIncrement,
                        onDecrement: isLoading ? null : onDecrement,
                        compact: true,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String image;
  final ColorScheme cs;

  const _ProductImage({required this.image, required this.cs});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: cs.surfaceContainerLowest,
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.contain,
        placeholder: (_, _) => const ImageSkeleton(),
        errorWidget: (_, _, _) => const ImageErrorWidget(iconSize: 40),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onAdd;

  const _AddButton({required this.isLoading, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onAdd,
        icon: isLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.add_shopping_cart_rounded, size: 14),
        label: const Text('Adicionar'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
