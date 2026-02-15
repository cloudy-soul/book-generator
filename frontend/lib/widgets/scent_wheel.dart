import 'package:flutter/material.dart';
import 'dart:math';
import 'package:frontend/theme/app_colors.dart';

class ScentWheelSelector extends StatefulWidget {
  final String? initialScent;
  final ValueChanged<String?>? onScentSelected;

  const ScentWheelSelector({super.key, this.initialScent, this.onScentSelected});
  
  @override
  State<ScentWheelSelector> createState() => _ScentWheelSelectorState();
}

class _ScentWheelSelectorState extends State<ScentWheelSelector> 
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  String? _selectedScent;
  
  final List<Map<String, dynamic>> _scents = [
    {'name': 'Citrus', 'color': const Color(0xFFFFD700), 'icon': '🍋'},
    {'name': 'Floral', 'color': const Color(0xFFFFB6C1), 'icon': '🌸'},
    {'name': 'Woody', 'color': const Color(0xFF8B7355), 'icon': '🌲'},
    {'name': 'Fresh', 'color': const Color(0xFF87CEEB), 'icon': '🌊'},
    {'name': 'Spicy', 'color': const Color(0xFFDC143C), 'icon': '🌶️'},
    {'name': 'Herbal', 'color': const Color(0xFF32CD32), 'icon': '🌿'},
  ];
  
  @override
  void initState() {
    super.initState();
    _selectedScent = widget.initialScent;
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            // Rotating wheel
            SizedBox(
              width: 280,
              height: 280,
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 2 * pi, // 2π
                    child: CustomPaint(
                      key: const Key('scent_wheel_paint'),
                      painter: _ScentWheelPainter(
                        scents: _scents,
                        selectedIndex: _selectedScent != null
                            ? _scents.indexWhere((s) => s['name'] == _selectedScent)
                            : -1,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Scent buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _scents.map((scent) {
                final isSelected = _selectedScent == scent['name'];
                
                return ChoiceChip(
                  label: Text(scent['name']! as String),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedScent = selected ? scent['name'] as String? : null;
                    });
                    widget.onScentSelected?.call(_selectedScent);
                  },
                  avatar: Text(scent['icon']! as String),
                  backgroundColor: (scent['color']! as Color).withOpacity(0.1),
                  selectedColor: (scent['color']! as Color).withOpacity(0.3),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.deepMoss
                        : AppColors.deepMoss.withOpacity(0.7),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: (scent['color']! as Color).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  elevation: isSelected ? 2 : 0,
                  pressElevation: 1,
                );
              }).toList(),
            ),
            
            // Selection indicator
            if (_selectedScent != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  'You selected: $_selectedScent',
                  style: const TextStyle(
                    fontFamily: 'DancingScript',
                    fontSize: 20,
                    color: AppColors.bibliophileRed,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _ScentWheelPainter extends CustomPainter {
  final List<Map<String, dynamic>> scents;
  final int selectedIndex;
  
  _ScentWheelPainter({
    required this.scents,
    required this.selectedIndex,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * pi / scents.length;
    
    for (int i = 0; i < scents.length; i++) {
      final startAngle = i * segmentAngle;
      final isSelected = i == selectedIndex;
      
      // Draw segment
      final paint = Paint()
        ..color = (scents[i]['color']! as Color).withOpacity(isSelected ? 0.4 : 0.2)
        ..style = PaintingStyle.fill;
      
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          segmentAngle,
          false,
        )
        ..close();
      
      canvas.drawPath(path, paint);
      
      // Draw segment border
      final borderPaint = Paint()
        ..color = (scents[i]['color']! as Color).withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3.0 : 1.0;
      
      canvas.drawPath(path, borderPaint);
      
      // Draw icon/text in center of segment
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.6;
      final textX = center.dx + textRadius * cos(textAngle);
      final textY = center.dy + textRadius * sin(textAngle);
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: scents[i]['icon']! as String,
          style: TextStyle(
            fontSize: 24,
            color: (scents[i]['color']! as Color).withOpacity(0.9),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}