import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _httpClient;
  static const String baseUrl = 'http://localhost:8080';
  String? token;

  ApiClient(this._httpClient);

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = '$baseUrl$endpoint';
    print('GET request: $url');

    try {
      final response = await _httpClient.get(
        Uri.parse(url),
        headers: _buildHeaders(headers),
      );
      _logResponse(response);
      return response;
    } catch (e) {
      print('Error in GET request: $e');
      throw Exception('Falha na requisição: $e');
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final url = '$baseUrl$endpoint';
    print('POST request: $url');
    print('Request body: ${jsonEncode(body)}');

    try {
      final response = await _httpClient.post(
        Uri.parse(url),
        headers: _buildHeaders(headers),
        body: jsonEncode(body),
      );
      _logResponse(response);
      return response;
    } catch (e) {
      print('Error in POST request: $e');
      throw Exception('Falha na requisição: $e');
    }
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final url = '$baseUrl$endpoint';
    print('PUT request: $url');

    try {
      final response = await _httpClient.put(
        Uri.parse(url),
        headers: _buildHeaders(headers),
        body: jsonEncode(body),
      );
      _logResponse(response);
      return response;
    } catch (e) {
      print('Error in PUT request: $e');
      throw Exception('Falha na requisição: $e');
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = '$baseUrl$endpoint';
    print('DELETE request: $url');

    try {
      final response = await _httpClient.delete(
        Uri.parse(url),
        headers: _buildHeaders(headers),
      );
      _logResponse(response);
      return response;
    } catch (e) {
      print('Error in DELETE request: $e');
      throw Exception('Falha na requisição: $e');
    }
  }

  Map<String, String> _buildHeaders(Map<String, String>? additionalHeaders) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  void setToken(String newToken) {
    token = newToken;
  }

  void _logResponse(http.Response response) {
    print('Response status: ${response.statusCode}');
    print(
      'Response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...',
    );
  }
}
