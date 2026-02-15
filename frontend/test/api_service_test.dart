import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/api_service.dart';

// Generate mocks: run `flutter pub run build_runner build`
@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late ApiService apiService;

  setUp(() {
    mockClient = MockClient();
    apiService = ApiService(client: mockClient);
  });

  test('getRecommendations sends correct request', () async {
    // Mock successful response
    final mockResponse = '''
    {
      "books": [
        {"title": "Test Book", "author": "Test Author", "reason": "Test reason"}
      ],
      "perfume": {"name": "Test Perfume"},
      "drink": {"name": "Test Drink"},
      "explanation": "Test explanation"
    }
    ''';

    when(mockClient.post(
      any,
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(mockResponse, 200));

    // Call the method
    final userInput = {
      'scent': 'woody',
      'zodiac': 'taurus',
      'coffee': 'cappuccino',
      'age': 25,
      'genres': ['mystery']
    };

    final result = await apiService.getRecommendations(userInput);

    // Verify the request was made
    verify(mockClient.post(
      Uri.parse('http://localhost:8000/recommend'),
      headers: {'Content-Type': 'application/json'},
      body: anyNamed('body'),
    )).called(1);

    expect(result, isNotNull);
    expect(result['books'], isList);
    print('✓ API service makes correct HTTP request');
  });

  test('getRecommendations handles network error', () async {
    // Mock network error
    when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenThrow(Exception('Network error'));

    final userInput = {
      'scent': 'floral',
      'zodiac': 'libra',
      'coffee': 'latte',
      'age': 22,
      'genres': ['romance']
    };

    try {
      await apiService.getRecommendations(userInput);
      fail('Should have thrown an exception');
    } catch (e) {
      expect(e, isException);
      print('✓ API service handles network errors gracefully');
    }
  });

  test('getRecommendations handles server error', () async {
    // Mock server error response
    when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer(
      (_) async => http.Response('Internal Server Error', 500),
    );

    final userInput = {
      'scent': 'fresh',
      'zodiac': 'gemini',
      'coffee': 'espresso',
      'age': 30,
      'genres': ['scifi']
    };

    try {
      await apiService.getRecommendations(userInput);
      fail('Should have thrown an exception for 500 error');
    } catch (e) {
      expect(e.toString(), contains('500'));
      print('✓ API service handles server errors');
    }
  });
}