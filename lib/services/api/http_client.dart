import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/errors/failures.dart';

class HttpClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  HttpClient({
    required this.baseUrl,
    this.defaultHeaders = const {},
  });

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );

      final response = await http.get(
        uri,
        headers: {...defaultHeaders, ...?headers},
      );

      return _handleResponse(response);
    } catch (e) {
      throw NetworkFailure('GET request failed: $e');
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {...defaultHeaders, ...?headers},
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw NetworkFailure('POST request failed: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else {
      throw NetworkFailure(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
