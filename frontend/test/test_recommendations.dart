import 'dart:convert';
import 'dart:io';
import 'package:frontend/services/api_service.dart';
import 'package:http/http.dart' as http;

/// Run this script from the project root using:
/// dart run test/test_recommendations.dart

void main() async {
  print('\n==========================================');
  print('   Recommendation Algorithm Terminal Test');
  print('==========================================');
  print('Please enter the user data to test the scoring algorithm.\n');

  // 1. Age
  stdout.write('1. Age (default 25): ');
  String? ageInput = stdin.readLineSync();
  int age = int.tryParse(ageInput ?? '') ?? 25;

  // 2. Scent
  stdout.write('2. Scent (e.g., Citrus, Woody, Floral, Fresh, Spicy, Herbal): ');
  String? scent = stdin.readLineSync()?.trim();
  if (scent != null && scent.isEmpty) scent = null;

  // 3. Zodiac
  stdout.write('3. Zodiac (e.g., Aries, Taurus, Gemini, etc.): ');
  String? zodiac = stdin.readLineSync()?.trim();
  if (zodiac != null && zodiac.isEmpty) zodiac = null;

  // 4. Coffee
  stdout.write('4. Coffee (e.g., Espresso, Latte, Americano, Cappuccino): ');
  String? coffee = stdin.readLineSync()?.trim();
  if (coffee != null && coffee.isEmpty) coffee = null;

  // 5. Genres
  stdout.write('5. Genres (comma separated, e.g., Fiction, Mystery): ');
  String? genresInput = stdin.readLineSync();
  List<String>? genres;
  if (genresInput != null && genresInput.trim().isNotEmpty) {
    genres = genresInput.split(',').map((e) => e.trim()).toList();
  }

  // Construct the payload exactly as the App does
  final Map<String, dynamic> userSelections = {
    'age': age,
    if (scent != null) 'scent': scent,
    if (zodiac != null) 'zodiac': zodiac,
    if (coffee != null) 'coffee': coffee,
    if (genres != null) 'genres': genres,
  };

  print('\n------------------------------------------');
  print('Sending payload to API:');
  print(const JsonEncoder.withIndent('  ').convert(userSelections));
  print('------------------------------------------\n');

  final api = ApiService(client: http.Client());

  try {
    print('Calling getRecommendations()...');
    final stopwatch = Stopwatch()..start();
    
    final result = await api.getRecommendations(userSelections);
    
    stopwatch.stop();
    print('Request completed in ${stopwatch.elapsedMilliseconds}ms\n');

    print('--- API RESULT ---');
    print(const JsonEncoder.withIndent('  ').convert(result));
    print('------------------');

    // Summary check
    if (result != null) {
      final drink = result['drink'];
      final perfume = result['perfume'];
      print('\n🔎 SUMMARY CHECK:');
      print('🍷 Drink:   ${drink is Map ? drink['drink'] : 'None'}');
      print('🌸 Perfume: ${perfume is Map ? perfume['name'] : 'None'}');
    }
  } catch (e) {
    print('\nERROR: Failed to get recommendations.');
    if (e.toString().contains('Connection refused')) {
      print('\n[!] Could not connect to the server.');
      print('Make sure the backend is running on http://localhost:8000');
      print('To start it, open a new terminal in the backend/ directory and run:');
      print('  uvicorn app.main:app --reload');
    }
    print('\nDetails: $e');
  }
  print('\n==========================================');
}