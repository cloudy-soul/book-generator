import 'package:flutter/material.dart';
import 'package:frontend/theme/app_shapes.dart';
import 'package:frontend/theme/app_theme.dart';

class WatercolorCard extends StatelessWidget {
  final Widget child;
  final Color? watercolorColor;
  final double intensity;
  final BorderRadius? borderRadius;
  
  const WatercolorCard({
    super.key,
    required this.child,
    this.watercolorColor,
    this.intensity = 0.1,
    this.borderRadius,
  });
  
  @override
  Widget build(BuildContext context) {
    final color = watercolorColor ?? 
        Theme.of(context).extension<CustomColors>()!.watercolorWash;
    
    return Stack(
      children: [
        // Watercolor background
        Positioned.fill(
          child: CustomPaint(
            painter: _WatercolorPainter(
              color: color,
              intensity: intensity,
            ),
          ),
        ),
        
        // Content with torn paper edge
        ClipPath(
          clipper: _TornPaperClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: borderRadius ?? AppShapes.large,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _WatercolorPainter extends CustomPainter {
  final Color color;
  final double intensity;
  
  _WatercolorPainter({
    required this.color,
    required this.intensity,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(intensity)
      ..style = PaintingStyle.fill;
    
    // Create organic blob shapes
    final blobs = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.1),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.8, size.height * 0.6),
    ];
    
    for (final center in blobs) {
      final radius = size.shortestSide * 0.2;
      canvas.drawCircle(center, radius, paint);
    }
    
    // Add some texture with smaller circles
    final texturePaint = Paint()
      ..color = color.withOpacity(intensity * 0.5);
    
    for (int i = 0; i < 20; i++) {
      final x = size.width * (0.1 + 0.8 * (i / 20));
      final y = size.height * (0.1 + 0.8 * ((i * 1.618) % 1));
      canvas.drawCircle(
        Offset(x, y),
        size.shortestSide * 0.05,
        texturePaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TornPaperClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 8); // Start with torn edge offset
    
    // Add torn edge at top
    final tear = AppShapes.createTornPaperEdge(size);
    path.addPath(tear, Offset.zero);
    
    // Complete rectangle
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    return path;
  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}