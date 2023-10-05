import 'package:flutter/material.dart';

class CustomPixel extends StatelessWidget {
  const CustomPixel({
    super.key,
    required this.color,
    required this.child,
  });

  final Color color;
  final String child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(1),
      child: Center(
        child: Text(
          child,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
