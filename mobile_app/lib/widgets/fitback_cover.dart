import 'package:flutter/material.dart';

class FitBackCover extends StatelessWidget {
  final String imagePath;
  final double height;
  final double borderRadius;

  const FitBackCover({
    super.key,
    required this.imagePath,
    this.height = 160,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.15, 1.0],
                  colors: [Colors.transparent, Color(0xFF0A0A0A)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
