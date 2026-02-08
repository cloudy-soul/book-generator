import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;
  // Use a compile-time environment variable to allow overriding the API base URL
  // when running or building the app. Falls back to localhost:8000 for dev.
  final String _baseUrl = const String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000');

  ApiService({required this.client});

  Future<Map<String, dynamic>> getRecommendations(Map<String, dynamic> userInput) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/recommend'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userInput),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get recommendations: ${response.statusCode}');
    }
  }
}
