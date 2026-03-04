import 'package:flutter/material.dart';
import 'package:flutter_carrinho_de_compras/core/utils/currency_formatter.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double total;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
  });

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
            label: 'Subtotal',
            value: formatBRL(subtotal),
            tt: tt,
            cs: cs,
          ),
          const SizedBox(height: 6),
          _SummaryRow(
            label: 'Frete',
            value: shippingFee == 0 ? 'Grátis' : formatBRL(shippingFee),
            tt: tt,
            cs: cs,
            valueColor: shippingFee == 0 ? const Color(0xFF16A34A) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: cs.outlineVariant.withAlpha(120)),
          ),
          _SummaryRow(
            label: 'Total',
            value: formatBRL(total),
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
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.tt,
    required this.cs,
    this.isBold = false,
    this.valueColor,
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
          style: tt.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
