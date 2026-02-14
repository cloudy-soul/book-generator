import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.bibliophileRed,
        secondary: AppColors.sageGreen,
        tertiary: AppColors.serenity,
        surface: AppColors.oldLace,
        surfaceVariant: AppColors.lavenderWeb,
        onSurface: AppColors.deepMoss,
        outline: AppColors.burntUmber.withOpacity(0.3),
      ),
      
      // Organic Shape System
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        elevation: 2,
        color: Colors.white.withOpacity(0.95),
        surfaceTintColor: Colors.transparent,
      ),
      
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bibliophileRed,
          foregroundColor: AppColors.oldLace,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 3,
          shadowColor: AppColors.bibliophileRed.withOpacity(0.3),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppColors.burntUmber.withOpacity(0.5),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: AppColors.burntUmber.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: AppColors.burntUmber.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.bibliophileRed,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: const EdgeInsets.all(16),
      ),
      
      // Typography
      textTheme: AppTypography.textTheme,

      // Theme extensions
      extensions: <ThemeExtension<dynamic>>[
        customColors,
      ],
      
      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.burntUmber.withOpacity(0.3),
        thickness: 1,
        space: 20,
      ),
      
      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
  
  // Custom theme extensions for your unique aesthetic
  static ThemeExtension<CustomColors> get customColors {
    return CustomColors(
      bookmarkRibbon: AppColors.bibliophileRed,
      paperTexture: AppColors.oldLace,
      watercolorWash: AppColors.serenity.withOpacity(0.1),
      laceBorder: AppColors.burntUmber.withOpacity(0.2),
    );
  }
}

// Custom Theme Extension
class CustomColors extends ThemeExtension<CustomColors> {
  final Color bookmarkRibbon;
  final Color paperTexture;
  final Color watercolorWash;
  final Color laceBorder;
  
  const CustomColors({
    required this.bookmarkRibbon,
    required this.paperTexture,
    required this.watercolorWash,
    required this.laceBorder,
  });
  
  @override
  ThemeExtension<CustomColors> copyWith({
    Color? bookmarkRibbon,
    Color? paperTexture,
    Color? watercolorWash,
    Color? laceBorder,
  }) {
    return CustomColors(
      bookmarkRibbon: bookmarkRibbon ?? this.bookmarkRibbon,
      paperTexture: paperTexture ?? this.paperTexture,
      watercolorWash: watercolorWash ?? this.watercolorWash,
      laceBorder: laceBorder ?? this.laceBorder,
    );
  }
  
  @override
  ThemeExtension<CustomColors> lerp(
    ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) return this;
    
    return CustomColors(
      bookmarkRibbon: Color.lerp(bookmarkRibbon, other.bookmarkRibbon, t)!,
      paperTexture: Color.lerp(paperTexture, other.paperTexture, t)!,
      watercolorWash: Color.lerp(watercolorWash, other.watercolorWash, t)!,
      laceBorder: Color.lerp(laceBorder, other.laceBorder, t)!,
    );
  }
}
