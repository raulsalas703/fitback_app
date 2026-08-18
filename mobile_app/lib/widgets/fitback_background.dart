import 'package:flutter/material.dart';

class FitBackBackground extends StatelessWidget {
  final Widget child;

  const FitBackBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF140E05),
            Color(0xFF5C4414),
            Color(0xFF3A2C0E),
            Color(0xFF120C04),
          ],
          stops: [0.0, 0.35, 0.7, 1.0],
        ),
      ),
      child: child,
    );
  }
}
