import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AppShapes {
  static final BorderRadius large = BorderRadius.circular(24.0);

  static Path createBookmarkShape(Size size, bool isLeftPointing) {
    final path = Path();
    const notchSize = 12.0;

    if (isLeftPointing) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(notchSize, size.height / 2);
      path.close();
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width - notchSize, size.height / 2);
      path.close();
    }

    return path;
  }

  static Path createTornPaperEdge(Size size) {
    final path = Path();
    final random = Random(1); // Seed for consistency
    final roughness = 8.0;

    path.moveTo(0, random.nextDouble() * roughness);
    for (double x = 0; x < size.width; x += 20) {
      final y = random.nextDouble() * roughness;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, random.nextDouble() * roughness);
    return path;
  }
}
