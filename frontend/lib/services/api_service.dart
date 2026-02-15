import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;
  final String _baseUrl = _getBaseUrl();

  ApiService({required this.client});

  static String _getBaseUrl() {
    // Use a compile-time variable to allow overriding the API base URL.
    const apiUrlFromEnv = String.fromEnvironment('API_URL');
    if (apiUrlFromEnv.isNotEmpty) {
      return apiUrlFromEnv;
    }

    // Fallback to platform-specific defaults for local development.
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    // Default to localhost for iOS simulators, desktop, etc.
    return 'http://localhost:8000';
  }

  Future<Map<String, dynamic>> getRecommendations(
      Map<String, dynamic> userInput) async {
    final uri = Uri.parse('$_baseUrl/recommend');
    http.Response response;

    try {
      response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userInput),
      );
    } catch (e) {
      // Provide a more helpful error message for network issues.
      throw Exception(
          'Network error when connecting to $uri. Error: $e\nPlease check the following:\n1. Your local backend server is running.\n2. If on Web, ensure your backend has CORS enabled (Access-Control-Allow-Origin).\n3. If using a physical device, you have set the correct IP address for the API_URL.');
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // Provide more details on server errors (400, 500, etc.)
      throw Exception(
          'Server returned an error: ${response.statusCode}\nResponse body: ${response.body}');
    }
  }
}
