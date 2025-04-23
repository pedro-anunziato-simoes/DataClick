import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _httpClient;
  final String baseUrl;
  String? token;

  ApiClient(
    this._httpClient, {
    this.baseUrl = 'http://localhost:8080',
    this.token,
  });

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = '$baseUrl$endpoint';
    _logRequest('GET', url);

    try {
      final response = await _httpClient
          .get(Uri.parse(url), headers: _buildHeaders(headers))
          .timeout(const Duration(seconds: 15));

      _logResponse(response);
      return response;
    } catch (e) {
      _logError('GET', url, e);
      rethrow;
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = '$baseUrl$endpoint';
    _logRequest('POST', url, body: body);

    try {
      final response = await _httpClient
          .post(
            Uri.parse(url),
            headers: _buildHeaders(headers),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      _logResponse(response);
      return response;
    } catch (e) {
      _logError('POST', url, e);
      rethrow;
    }
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = '$baseUrl$endpoint';
    _logRequest('PUT', url, body: body);

    try {
      final response = await _httpClient
          .put(
            Uri.parse(url),
            headers: _buildHeaders(headers),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      _logResponse(response);
      return response;
    } catch (e) {
      _logError('PUT', url, e);
      rethrow;
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = '$baseUrl$endpoint';
    _logRequest('DELETE', url);

    try {
      final response = await _httpClient
          .delete(Uri.parse(url), headers: _buildHeaders(headers))
          .timeout(const Duration(seconds: 15));

      _logResponse(response);
      return response;
    } catch (e) {
      _logError('DELETE', url, e);
      rethrow;
    }
  }

  Map<String, String> _buildHeaders(Map<String, String>? additionalHeaders) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    additionalHeaders?.forEach((key, value) {
      headers[key] = value;
    });

    return headers;
  }

  void setToken(String newToken) {
    token = newToken;
  }

  void _logRequest(String method, String url, {dynamic body}) {
    print('$method request: $url');
    if (body != null) {
      print('Request body: ${jsonEncode(body)}');
    }
  }

  void _logResponse(http.Response response) {
    print('Response status: ${response.statusCode}');
    final body = response.body;
    print(
      'Response body: ${body.length > 200 ? '${body.substring(0, 200)}...' : body}',
    );
  }

  void _logError(String method, String url, dynamic error) {
    print('Error in $method request to $url: $error');
  }
}
