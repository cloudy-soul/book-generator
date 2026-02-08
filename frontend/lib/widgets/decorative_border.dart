import 'package:flutter/material.dart';
import 'package:frontend/theme/app_theme.dart';

class LaceBorder extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final Color? color;
  
  const LaceBorder({
    super.key,
    required this.child,
    this.borderWidth = 4.0,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LaceBorderPainter(
        borderWidth: borderWidth,
        color: color ?? Theme.of(context).extension<CustomColors>()!.laceBorder,
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: child,
      ),
    );
  }
}

class _LaceBorderPainter extends CustomPainter {
  final double borderWidth;
  final Color color;
  
  _LaceBorderPainter({
    required this.borderWidth,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    final dashWidth = 8.0;
    final dashSpace = 4.0;
    final totalWidth = size.width * 2 + size.height * 2;
    // ignore: unused_local_variable
    final totalDashes = totalWidth / (dashWidth + dashSpace);
    
    double distance = 0;
    
    // Top edge
    for (double x = 0; x < size.width; x += dashWidth + dashSpace) {
      if (distance + dashWidth <= size.width) {
        path.moveTo(x, 0);
        path.quadraticBezierTo(
          x + dashWidth / 2,
          -borderWidth / 2,
          x + dashWidth,
          0,
        );
      }
      distance += dashWidth + dashSpace;
    }
    
    // Add more path segments for other edges...
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}