import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'CormorantGaramond',
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    color: AppColors.deepMoss,
    letterSpacing: -0.02,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'CormorantGaramond',
    fontSize: 28.0,
    fontWeight: FontWeight.w500,
    color: AppColors.burntUmber,
    height: 1.3,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'CormorantGaramond',
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    color: AppColors.bibliophileRed,
    height: 1.4,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.deepMoss,
    height: 1.4,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: AppColors.burntUmber,
    height: 1.4,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.deepMoss,
    height: 1.5,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.deepMoss,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Color(0xCC2E4600), // deepMoss with 0.8 opacity
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Color(0x992E4600), // deepMoss with 0.6 opacity
    height: 1.6,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.bibliophileRed,
    letterSpacing: 0.1,
    height: 1.4,
  );

  // Accent/Cursive text
  static const TextStyle accentLarge = TextStyle(
    fontFamily: 'DancingScript',
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    color: AppColors.bibliophileRed,
    height: 1.3,
  );

  static const TextStyle accentMedium = TextStyle(
    fontFamily: 'DancingScript',
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    color: AppColors.bibliophileRed,
    height: 1.3,
  );

  static const TextStyle captionAccent = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: AppColors.sageGreen,
    letterSpacing: 0.05,
    height: 1.4,
  );

  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
    );
  }

  // Helper method for underlined text (hand-drawn style)
  static Widget underlinedText(String text, TextStyle style) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: style),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: (text.length * 8.0).toDouble(), // Dynamic width based on text
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.bibliophileRed.withOpacity(0.8),
                AppColors.sageGreen.withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}