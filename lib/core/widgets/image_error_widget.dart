import 'package:flutter/material.dart';

class ImageErrorWidget extends StatelessWidget {
  final double iconSize;

  const ImageErrorWidget({super.key, this.iconSize = 32});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: iconSize,
        color: cs.onSurfaceVariant.withAlpha(100),
      ),
    );
  }
}
