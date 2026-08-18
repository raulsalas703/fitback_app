import 'dart:convert';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final String? photoBase64;
  final VoidCallback? onEdit;

  const ProfileAvatar({
    super.key,
    this.size = 110,
    this.photoBase64,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final Widget photo;

    if (photoBase64 != null && photoBase64!.isNotEmpty) {
      photo = Image.memory(
        base64Decode(photoBase64!),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    } else {
      photo = Image.asset(
        'assets/images/cover_training.jpg',
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37), width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66D4AF37),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(child: photo),
          ),

          if (onEdit != null)
            Positioned(
              right: 2,
              bottom: 2,
              child: GestureDetector(
                onTap: onEdit,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD4AF37),
                    border: Border.all(
                      color: const Color(0xFF151515),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
