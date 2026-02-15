import 'package:flutter/material.dart';

class AppAnimations {
  // Page transitions
  static Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
  
  // Staggered animation for lists
  static List<Widget> buildStaggeredList(
    List<Widget> children,
    Animation<double> animation,
  ) {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      
      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final itemAnimation = CurvedAnimation(
            parent: animation,
            curve: Interval(
              (index / children.length) * 0.5,
              1.0,
              curve: Curves.easeOutBack,
            ),
          );
          
          return FadeTransition(
            opacity: itemAnimation,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - itemAnimation.value)),
              child: child,
            ),
          );
        },
        child: child,
      );
    }).toList();
  }
  
  // Gentle pulse animation
  static AnimationController createPulseController(TickerProvider vsync) {
    return AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    )..repeat(reverse: true);
  }
  
  static Animation<double> createPulseAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutSine,
      ),
    );
  }
  
  // Book opening animation
  static Matrix4 bookOpenTransform(double progress) {
    return Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective
      ..rotateY(progress * 3.14); // 180 degree rotation
  }
}