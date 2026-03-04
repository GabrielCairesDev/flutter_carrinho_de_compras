import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/utils/currency_formatter.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/image_error_widget.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/image_skeleton.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/quantity_counter.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final bool isLoading;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ItemImage(image: item.product.image, cs: cs),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _RemoveButton(
                        isLoading: isLoading,
                        onRemove: onRemove,
                        cs: cs,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatBRL(item.product.price),
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      QuantityCounter(
                        quantity: item.quantity,
                        onIncrement: isLoading ? null : onIncrement,
                        onDecrement: isLoading ? null : onDecrement,
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Subtotal', style: tt.labelSmall),
                          const SizedBox(height: 2),
                          Text(
                            formatBRL(item.subtotal),
                            style: tt.titleSmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  final String image;
  final ColorScheme cs;

  const _ItemImage({required this.image, required this.cs});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColoredBox(
        color: cs.surfaceContainerLowest,
        child: SizedBox(
          width: 80,
          height: 80,
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.contain,
            placeholder: (_, _) => const ImageSkeleton(),
            errorWidget: (_, _, _) => const ImageErrorWidget(),
          ),
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRemove;
  final ColorScheme cs;

  const _RemoveButton({
    required this.isLoading,
    required this.onRemove,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isLoading ? null : onRemove,
      icon: Icon(
        Icons.delete_outline_rounded,
        color: isLoading ? cs.onSurface.withAlpha(60) : cs.error,
        size: 20,
      ),
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(6),
        minimumSize: const Size(32, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: isLoading
            ? Colors.transparent
            : cs.errorContainer.withAlpha(60),
      ),
      tooltip: 'Remover item',
    );
  }
}
