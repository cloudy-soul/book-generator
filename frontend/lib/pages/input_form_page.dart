import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/app_typography.dart';
import 'package:frontend/widgets/scent_wheel.dart';
import 'package:frontend/widgets/coffee_cup_selector.dart';
import 'package:frontend/widgets/genre_bookshelf.dart';
import 'package:frontend/widgets/zodiac_selector.dart';
import 'package:frontend/widgets/age_selector.dart';
import 'package:frontend/services/api_service.dart';
import 'package:http/http.dart' as http;

class InputFormPage extends StatefulWidget {
  final http.Client? httpClient;
  const InputFormPage({super.key, this.httpClient});
  
  @override
  State<InputFormPage> createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  final Map<String, dynamic> _userSelections = {'age': 25}; // Default age
  bool _isSubmitting = false;
  
  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Scent Preference',
      'subtitle': 'What fragrance feels most like you today?',
      'color': AppColors.lavenderWeb,
      'icon': Icons.spa_rounded,
    },
    {
      'title': 'Zodiac Sign',
      'subtitle': 'Share your celestial energy',
      'color': AppColors.serenity,
      'icon': Icons.star_rounded,
    },
    {
      'title': 'Coffee Order',
      'subtitle': 'Your go-to comfort drink',
      'color': AppColors.oldLace,
      'icon': Icons.coffee_rounded,
    },
    {
      'title': 'Age',
      'subtitle': 'To tailor recommendations',
      'color': AppColors.roseQuartz,
      'icon': Icons.cake_rounded,
    },
    {
      'title': 'Preferred Genres',
      'subtitle': 'What stories do you love?',
      'color': AppColors.sageGreen,
      'icon': Icons.book_rounded,
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.deepMoss,
          ),
          onPressed: () {
            if (_currentStep > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: _buildProgressIndicator(),
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _steps.length,
        onPageChanged: (index) {
          setState(() {
            _currentStep = index;
          });
        },
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _steps[index]['color'].withOpacity(0.1),
                  Colors.white.withOpacity(0.9),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step indicator
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _steps[index]['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _steps[index]['icon'],
                              size: 16,
                              color: _steps[index]['color'],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Step ${index + 1}',
                              style: AppTypography.labelLarge.copyWith(
                                color: _steps[index]['color'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    _steps[index]['title'],
                    style: AppTypography.displaySmall,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Text(
                    _steps[index]['subtitle'],
                    style: AppTypography.bodyLarge.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Dynamic content based on step
                  Expanded(
                    child: _buildStepContent(index),
                  ),
                  
                  // Navigation
                  const SizedBox(height: 32),
                  _buildNavigationButtons(index),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: index == _currentStep ? 24 : 12,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index <= _currentStep
                ? _steps[index]['color']
                : AppColors.timberwolf,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
  
  Widget _buildStepContent(int index) {
    switch (index) {
      case 0:
        return ScentWheelSelector(
          initialScent: _userSelections['scent'],
          onScentSelected: (val) => _userSelections['scent'] = val,
        );
      case 1:
        return ZodiacConstellationSelector(
          initialZodiac: _userSelections['zodiac'],
          onZodiacSelected: (val) => _userSelections['zodiac'] = val,
        );
      case 2:
        return CoffeeCupSelector(
          initialCoffee: _userSelections['coffee'],
          onCoffeeSelected: (val) => _userSelections['coffee'] = val,
        );
      case 3:
        return AgeDialSelector(
          initialAge: _userSelections['age'],
          onAgeSelected: (val) => _userSelections['age'] = val,
        );
      case 4:
        return GenreBookshelfSelector(
          initialGenres: _userSelections['genres'] != null ? List<String>.from(_userSelections['genres']) : null,
          onGenresSelected: (val) => _userSelections['genres'] = val,
        );
      default:
        return const SizedBox();
    }
  }
  
  Widget _buildNavigationButtons(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button (hidden on first step)
        if (index > 0)
          OutlinedButton.icon(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.deepWisdom,
              side: BorderSide(
                color: AppColors.deepWisdom.withOpacity(0.5),
              ),
            ),
          )
        else
          const SizedBox(width: 100),
        
        // Next/Submit button
        ElevatedButton.icon(
          key: index == _steps.length - 1 ? const Key('submit_button') : null,
          onPressed: _isSubmitting
              ? null
              : () {
                  if (index < _steps.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Submit form and navigate to results (calls backend)
                    _submitForm();
                  }
                },
          icon: Icon(
            index < _steps.length - 1
                ? Icons.arrow_forward_rounded
                : Icons.check_rounded,
          ),
          label: Text(
            index < _steps.length - 1 ? 'Continue' : 'Discover Matches',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _steps[index]['color'],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ],
    );
  }
  
  void _submitForm() async {
    setState(() => _isSubmitting = true);

    // 1. Clean the payload: Remove null values so we don't send {"scent": null}
    final cleanSelections = Map<String, dynamic>.from(_userSelections)
      ..removeWhere((key, value) => value == null);

    // 2. DEBUG LOG: Check your console to see if this changes when you change inputs!
    print('🚀 SENDING TO API: $cleanSelections');

  final api = ApiService(client: widget.httpClient ?? http.Client());
  Map<String, dynamic>? result;

    try {
      result = await api.getRecommendations(cleanSelections).timeout(const Duration(seconds: 5));
      print('✅ API RESPONSE: $result');
    } catch (e) {
      print('❌ API ERROR: $e');
      result = {
        'books': [],
        'perfume': {},
        'drink': {},
        'error': e.toString(),
      };
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.pushNamed(context, '/results', arguments: result ?? {
          'books': [],
          'perfume': {},
          'drink': {},
        });
      }
    }
  }
}