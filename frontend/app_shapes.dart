import 'package:flutter/material.dart';

class AppShapes {
  // BorderRadius system (never perfect circles - slight asymmetry)
  static const BorderRadius small = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius large = BorderRadius.all(Radius.circular(24.0));
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(32.0));
  
  // Organic shapes - slightly asymmetric
  static BorderRadius organicSmall(double variance) {
    return BorderRadius.only(
      topLeft: Radius.circular(8.0 + variance),
      topRight: Radius.circular(8.0 - variance),
      bottomLeft: Radius.circular(8.0 - variance),
      bottomRight: Radius.circular(8.0 + variance),
    );
  }
  
  // Custom shapes using ClipPath
  static Path createBookmarkShape(Size size, bool isLeft) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    
    if (isLeft) {
      path.moveTo(width * 0.2, 0);
      path.lineTo(width, 0);
      path.lineTo(width, height);
      path.lineTo(width * 0.5, height * 0.8);
      path.lineTo(0, height);
      path.lineTo(0, height * 0.3);
      path.quadraticBezierTo(0, 0, width * 0.2, 0);
    } else {
      path.moveTo(0, 0);
      path.lineTo(width * 0.8, 0);
      path.quadraticBezierTo(width, 0, width, height * 0.3);
      path.lineTo(width, height);
      path.lineTo(width * 0.5, height * 0.8);
      path.lineTo(0, height);
      path.close();
    }
    
    return path;
  }
  
  // Torn paper edge effect
  static Path createTornPaperEdge(Size size) {
    final path = Path();
    final width = size.width;
    final segmentWidth = 8.0;
    final segments = (width / segmentWidth).ceil();
    
    path.moveTo(0, 0);
    
    for (int i = 0; i < segments; i++) {
      final x = (i + 1) * segmentWidth;
      final y = i.isEven ? 4.0 : -4.0;
      path.lineTo(x, y);
    }
    
    path.lineTo(width, 0);
    return path;
  }
  
  // Curved divider shape
  static Path createWavyDivider(Size size, int waves) {
    final path = Path();
    final waveLength = size.width / waves;
    final amplitude = 4.0;
    
    path.moveTo(0, amplitude);
    
    for (int i = 0; i < waves; i++) {
      final controlX1 = waveLength * (i + 0.25);
      final controlY1 = -amplitude;
      final controlX2 = waveLength * (i + 0.75);
      final controlY2 = amplitude;
      final endX = waveLength * (i + 1);
      final endY = i.isEven ? amplitude : -amplitude;
      
      path.cubicTo(
        controlX1, controlY1,
        controlX2, controlY2,
        endX, endY,
      );
    }
    
    return path;
  }
}