import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/app_shapes.dart';

class BookmarkButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSelected;
  final String label;
  final bool isLeftPointing;
  final double width;
  
  const BookmarkButton({
    super.key,
    required this.onPressed,
    this.isSelected = false,
    required this.label,
    this.isLeftPointing = true,
    this.width = 120,
  });
  
  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _tiltAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _tiltAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    if (widget.isSelected) {
      _animationController.forward();
    }
  }
  
  @override
  void didUpdateWidget(covariant BookmarkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        onEnter: (_) => _animationController.forward(),
        onExit: (_) {
          if (!widget.isSelected) {
            _animationController.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..rotateZ(_tiltAnimation.value),
              alignment: Alignment.center,
              child: CustomPaint(
                painter: _BookmarkButtonPainter(
                  isSelected: widget.isSelected,
                  isLeftPointing: widget.isLeftPointing,
                  hoverProgress: _animationController.value,
                ),
                child: Container(
                  width: widget.width,
                  height: 48,
                  alignment: Alignment.center,
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: widget.isSelected 
                          ? AppColors.oldLace 
                          : AppColors.bibliophileRed,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BookmarkButtonPainter extends CustomPainter {
  final bool isSelected;
  final bool isLeftPointing;
  final double hoverProgress;
  
  _BookmarkButtonPainter({
    required this.isSelected,
    required this.isLeftPointing,
    required this.hoverProgress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final path = AppShapes.createBookmarkShape(size, isLeftPointing);
    
    final fillPaint = Paint()
      ..color = isSelected 
          ? AppColors.bibliophileRed 
          : AppColors.bibliophileRed.withOpacity(0.1 + hoverProgress * 0.3)
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = AppColors.bibliophileRed.withOpacity(0.5 + hoverProgress * 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
    
    // Add subtle shadow
    if (hoverProgress > 0) {
      final shadowPath = Path()
        ..addPath(path, const Offset(0, 2));
      
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.1 * hoverProgress)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
      canvas.drawPath(shadowPath, shadowPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}