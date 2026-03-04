import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/utils/currency_formatter.dart';
import 'package:flutter_carrinho_de_compras/domain/models/cart.dart';

class OrderSummary extends StatelessWidget {
  final Cart cart;

  const OrderSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: cs.outlineVariant.withAlpha(100)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Itens no carrinho',
            value:
                '${cart.totalItems} ${cart.totalItems == 1 ? 'item' : 'itens'}',
            tt: tt,
            cs: cs,
          ),
          const SizedBox(height: 6),
          _SummaryRow(
            label: 'Subtotal',
            value: formatBRL(cart.subtotal),
            tt: tt,
            cs: cs,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: cs.outlineVariant.withAlpha(120)),
          ),
          _SummaryRow(
            label: 'Total',
            value: formatBRL(cart.subtotal),
            tt: tt,
            cs: cs,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme tt;
  final ColorScheme cs;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.tt,
    required this.cs,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isBold) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            value,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.primary,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
