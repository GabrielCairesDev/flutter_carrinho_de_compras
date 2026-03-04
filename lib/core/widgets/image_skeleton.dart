import 'package:flutter/material.dart';

class ImageSkeleton extends StatefulWidget {
  const ImageSkeleton({super.key});

  @override
  State<ImageSkeleton> createState() => _ImageSkeletonState();
}

class _ImageSkeletonState extends State<ImageSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, _) => ColoredBox(
        color: Color.lerp(
          cs.surfaceContainerLow,
          cs.surfaceContainerHighest,
          _animation.value,
        )!,
        child: const SizedBox.expand(),
      ),
    );
  }
}
