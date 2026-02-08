import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/app_typography.dart';
import 'package:frontend/widgets/watercolor_card.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    Map<String, dynamic>? args;

    print('📦 RESULTS PAGE RECEIVED: $rawArgs');

    if (rawArgs is Map) {
      try {
        args = Map<String, dynamic>.from(rawArgs as Map);
      } catch (_) {
        args = null;
      }
    }

    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.oldLace,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppColors.deepMoss),
        ),
        body: const Center(child: Text('No results available')),
      );
    }

    final books = args['books'] as List<dynamic>? ?? [];
    Map<String, dynamic>? perfume;
    Map<String, dynamic>? drink;

    if (args['perfume'] is Map) {
      try {
        perfume = Map<String, dynamic>.from(args['perfume'] as Map);
      } catch (_) {
        perfume = null;
      }
    }

    if (args['drink'] is Map) {
      try {
        drink = Map<String, dynamic>.from(args['drink'] as Map);
      } catch (_) {
        drink = null;
      }
    }
    final error = args['error'] as String?;
    final errorCode = args['errorCode'] as int?;
    final explanation = args['explanation'] as String?;

    return Scaffold(
      backgroundColor: AppColors.oldLace,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.deepMoss),
        title: Text('Your Curated Collection', style: AppTypography.headlineMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error),
                ),
                child: Text('Error: $error', style: const TextStyle(color: AppColors.error)),
              ),
              const SizedBox(height: 24),
            ],

            if (explanation != null) ...[
              Text(explanation, style: AppTypography.bodyLarge.copyWith(fontStyle: FontStyle.italic)),
              const SizedBox(height: 32),
            ],

            Text('Literary Matches', style: AppTypography.displayMedium),
            const SizedBox(height: 16),
            if (books.isEmpty) 
              const Text('No book recommendations available.')
            else
              ...books.map((b) => _buildBookCard(b)),

            const SizedBox(height: 32),

            Text('Sensory Pairings', style: AppTypography.displayMedium),
            const SizedBox(height: 16),
            
            if (perfume != null && perfume.isNotEmpty)
              _buildPairingCard(
                title: 'Signature Scent',
                name: perfume['name'] ?? 'Unknown',
                detail: perfume['brand'] ?? '',
                description: perfume['scent'] ?? '',
                icon: Icons.spa_outlined,
              ),
              
            const SizedBox(height: 16),

            if (drink != null && drink.isNotEmpty)
              _buildPairingCard(
                title: 'Comfort Drink',
                name: drink['drink'] ?? 'Unknown', // Key is 'drink' in drinks.yaml
                detail: '',
                description: (drink['taste'] as List<dynamic>?)?.join(', ') ?? '',
                icon: Icons.local_cafe_outlined,
              ),
              
            const SizedBox(height: 48),
            
            Center(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.burntUmber),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Start Over', style: TextStyle(color: AppColors.burntUmber)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(dynamic bookData) {
    final book = bookData is Map ? bookData : <String, dynamic>{};
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: WatercolorCard(
        intensity: 0.05,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book['title'] ?? 'Unknown Title', style: AppTypography.headlineSmall),
              const SizedBox(height: 4),
              Text('by ${book['author'] ?? 'Unknown Author'}', style: AppTypography.captionAccent.copyWith(fontSize: 14)),
              const SizedBox(height: 12),
              Text(book['reason'] ?? '', style: AppTypography.bodyMedium),
              if (book['main_genre'] != null) ...[
                const SizedBox(height: 12),
                Chip(
                  label: Text(book['main_genre'], style: AppTypography.bodySmall.copyWith(color: AppColors.oldLace)),
                  backgroundColor: AppColors.deepMoss.withOpacity(0.8),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPairingCard({
    required String title,
    required String name,
    required String detail,
    required String description,
    required IconData icon,
  }) {
    return WatercolorCard(
      intensity: 0.1,
      watercolorColor: AppColors.serenity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: AppColors.deepWisdom),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.labelLarge.copyWith(color: AppColors.deepWisdom)),
                  const SizedBox(height: 4),
                  Text(name, style: AppTypography.titleLarge),
                  if (detail.isNotEmpty)
                    Text(detail, style: AppTypography.captionAccent),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(description, style: AppTypography.bodySmall),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}