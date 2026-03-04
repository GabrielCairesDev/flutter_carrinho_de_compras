import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/utils/currency_formatter.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/image_error_widget.dart';
import 'package:flutter_carrinho_de_compras/core/widgets/image_skeleton.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart_item.dart';

class OrderItemTile extends StatelessWidget {
  final CartItem item;

  const OrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColoredBox(
                color: cs.surfaceContainerLowest,
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: CachedNetworkImage(
                    imageUrl: item.product.image,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const ImageSkeleton(),
                    errorWidget: (_, __, ___) => const ImageErrorWidget(iconSize: 28),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${item.quantity}x',
                          style: tt.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(formatBRL(item.product.price), style: tt.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatBRL(item.subtotal),
              style: tt.titleSmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
