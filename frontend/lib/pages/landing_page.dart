import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/app_typography.dart';
import 'package:frontend/widgets/bookmark_button.dart';
import 'package:frontend/widgets/watercolor_card.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> 
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late Animation<double> _titleAnimation;
  late AnimationController _bookAnimationController;
  
  @override
  void initState() {
    super.initState();
    
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _titleAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutCubic,
    );
    
    _bookAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _titleController.forward();
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _bookAnimationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.oldLace,
              AppColors.lavenderWeb.withOpacity(0.5),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: 50,
              right: 30,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 150,
                  color: AppColors.deepMoss,
                ),
              ),
            ),
            
            // Main content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated title reveal
                  AnimatedBuilder(
                    animation: _titleAnimation,
                    builder: (context, child) {
                      final characters = 'Discover Your Story'.split('');
                      return Wrap(
                        children: characters.asMap().entries.map((entry) {
                          final index = entry.key;
                          final character = entry.value;
                          // ignore: unused_local_variable
                          final delay = index * 50;
                          final shouldShow = 
                              _titleController.value * characters.length > index;
                          
                          return Opacity(
                            opacity: shouldShow ? 1.0 : 0.0,
                            child: Transform.translate(
                              offset: Offset(0, shouldShow ? 0 : 10),
                              child: Text(
                                character,
                                style: AppTypography.displayLarge.copyWith(
                                  color: AppColors.bibliophileRed,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _titleController.value,
                    child: Text(
                      'A personalized journey through books, scents, and moments',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.deepMoss.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Animated book stack
                  Center(
                    child: AnimatedBuilder(
                      animation: _bookAnimationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            0,
                            -10 * _bookAnimationController.value,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildBook(0, AppColors.bibliophileRed),
                              _buildBook(1, AppColors.sageGreen),
                              _buildBook(2, AppColors.serenity),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Feature cards
                  WatercolorCard(
                    intensity: 0.15,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_stories_rounded,
                                color: AppColors.sageGreen,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Personalized Book Matches',
                                style: AppTypography.headlineSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Based on your scent preferences, zodiac energy, and coffee rituals',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // CTA Buttons
                  Center(
                    child: Column(
                      children: [
                        BookmarkButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/input');
                          },
                          label: 'Begin Your Story',
                          isLeftPointing: false,
                          width: 200,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            // Show about dialog
                          },
                          child: Text(
                            'Learn How It Works',
                            style: AppTypography.bodyMedium.copyWith(
                              decoration: TextDecoration.underline,
                              color: AppColors.deepWisdom,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBook(int index, Color color) {
    // Use Transform.translate to achieve overlap instead of negative margins
    return Transform.translate(
      offset: Offset(index == 0 ? 0 : -12, 0),
      child: Transform.rotate(
        angle: -0.1 + (index * 0.05),
        child: Container(
          width: 40,
          height: 120 + (index * 20),
          // Avoid negative margins; translation handles overlap
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}