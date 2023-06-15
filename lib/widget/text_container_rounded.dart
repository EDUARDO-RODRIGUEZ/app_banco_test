import 'package:flutter/material.dart';

class TextContainerRounded extends StatelessWidget {
  final Widget child;
  final Color color;
  const TextContainerRounded({super.key, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration : BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}