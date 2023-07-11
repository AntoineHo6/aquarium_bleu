import 'package:flutter/material.dart';

class ColoredDot extends StatelessWidget {
  final Color color;
  final double diameter;

  const ColoredDot({super.key, required this.color, this.diameter = 8.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
