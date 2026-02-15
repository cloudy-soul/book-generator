import 'package:flutter/material.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/animations/app_animations.dart';
import 'package:frontend/pages/landing_page.dart';
import 'package:frontend/pages/input_form_page.dart';
import 'package:frontend/pages/loading_page.dart';
import 'package:frontend/pages/results_page.dart';
import 'package:frontend/pages/collections_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiet Charm',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/input': (context) => const InputFormPage(),
        '/loading': (context) => const LoadingPage(),
        '/results': (context) => const ResultsPage(),
        '/collections': (context) => const CollectionsPage(),
      },
      
      // Custom page transitions
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/input':
            return AppAnimations.createRoute(const InputFormPage());
          case '/results':
            return AppAnimations.createRoute(const ResultsPage());
          default:
            return null;
        }
      },
      
      // Scroll behavior
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
      ),
    );
  }
}
