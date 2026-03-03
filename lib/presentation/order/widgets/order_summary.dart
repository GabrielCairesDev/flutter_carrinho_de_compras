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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: formatBRL(subtotal),
            textTheme: textTheme,
          ),
          const SizedBox(height: 4),
          _SummaryRow(
            label: 'Frete',
            value: formatBRL(shippingFee),
            textTheme: textTheme,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            label: 'Total',
            value: formatBRL(total),
            textTheme: textTheme,
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
  final TextTheme textTheme;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.textTheme,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
