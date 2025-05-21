import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiClient {
  final http.Client _httpClient;
  final SharedPreferences _prefs;
  String? _authToken;
  final String baseUrl = 'http://localhost:8080';

  ApiClient(this._httpClient, this._prefs) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _authToken = _prefs.getString('auth_token');
  }

  void setAuthToken(String? token) {
    _authToken = token;
    if (token != null) {
      _prefs.setString('auth_token', token);
    } else {
      _prefs.remove('auth_token');
    }
  }

  String? get authToken => _authToken;

  Future<http.Response> get(String endpoint, {bool includeAuth = true}) async {
    final headers = await _buildHeaders(includeAuth);
    final uri = Uri.parse('$baseUrl$endpoint');
    print('GET Request: $uri');
    return await _httpClient.get(uri, headers: headers);
  }

  Future<http.Response> post(
    String endpoint, {
    dynamic body,
    bool includeAuth = true,
  }) async {
    final headers = await _buildHeaders(includeAuth);
    final uri = Uri.parse('$baseUrl$endpoint');

    final String bodyContent = body is String ? body : json.encode(body);

    print('POST Request: $uri');
    print('Headers: $headers');
    print('Body: $bodyContent');

    return await _httpClient.post(uri, headers: headers, body: bodyContent);
  }

  Future<http.Response> put(
    String endpoint, {
    dynamic body,
    bool includeAuth = true,
  }) async {
    final headers = await _buildHeaders(includeAuth);
    final uri = Uri.parse('$baseUrl$endpoint');

    final String bodyContent = body is String ? body : json.encode(body);

    print('PUT Request: $uri');
    print('Headers: $headers');
    print('Body: $bodyContent');

    return await _httpClient.put(uri, headers: headers, body: bodyContent);
  }

  Future<http.Response> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    final headers = await _buildHeaders(includeAuth);
    final uri = Uri.parse('$baseUrl$endpoint');
    print('DELETE Request: $uri');
    return await _httpClient.delete(uri, headers: headers);
  }

  Future<Map<String, String>> _buildHeaders(bool includeAuth) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }
}
