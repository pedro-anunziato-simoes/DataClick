import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  static const String baseUrl = 'http://localhost:8080/';
  String? token;

  ApiClient(this.client);

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return await client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
    );
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return await client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return await client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return await client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
    );
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
}
