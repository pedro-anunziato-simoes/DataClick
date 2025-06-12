import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import 'package:mobile/api/api_client.dart';
import 'package:mobile/api/services/api_exception.dart';
import '../endpoints.dart';

class AuthService {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;
  User? _currentUser;

  static const String _authTokenKey = 'auth_token';
  static const String _authUserKey = 'auth_user';

  AuthService(this._apiClient, this._prefs);

  Future<bool> login(String email, String senha) async {
    try {
      final response = await _apiClient.post(
        Endpoints.login,
        body: {'email': email, 'senha': senha},
        includeAuth: false,
      );

      if (response.statusCode != 200) {
        String errorMessage = 'Credenciais inválidas';
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
        throw ApiException(errorMessage, response.statusCode);
      }

      final responseData = json.decode(response.body);
      final token = _extractToken(responseData);

      if (token == null) {
        throw ApiException('Token não encontrado na resposta do login', 401);
      }

      final userDataFromToken = _extractUserDataFromToken(token);
      if (userDataFromToken.isEmpty) {
        throw ApiException(
          'Não foi possível extrair dados do usuário do token',
          401,
        );
      }

      await _saveAuthData(token, userDataFromToken);
      _apiClient.setAuthToken(token);
      _currentUser = User.fromJson(userDataFromToken);

      return true;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro durante o processo de login: ${e.toString()}',
        0,
      );
    }
  }

  Map<String, dynamic> _extractUserDataFromToken(String token) {
    final payload = _parseJwtPayload(token);
    if (payload != null) {
      return {
        'id': payload['sub'] ?? '',
        'email': payload['sub'] ?? '',
        'tipo': _getRoleFromPayload(payload),
        'nome': '',
        'telefone': '',
        'token': token,
      };
    }
    return {};
  }

  String _getRoleFromPayload(Map<String, dynamic> payload) {
    final authorities = payload['authorities'];
    if (authorities is List && authorities.isNotEmpty) {
      for (var authority in authorities) {
        final role = authority.toString();
        if (role == 'ROLE_ADMIN' || role == 'ADMIN') return 'admin';
        if (role == 'ROLE_USER' || role == 'USER') return 'user';
      }
    }
    return 'usuario'; //
  }

  Future<bool> register({
    required String nome,
    required String email,
    required String telefone,
    required String cnpj,
    required String senha,
  }) async {
    try {
      final body = {
        'cnpj': cnpj,
        'nome': nome,
        'senha': senha,
        'telefone': telefone,
        'email': email,
      };

      final response = await _apiClient.post(
        Endpoints.register,
        body: body,
        includeAuth: false,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        String errorMessage = 'Falha no registro';
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
        throw ApiException(errorMessage, response.statusCode);
      }
      return true;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro durante o processo de registro: ${e.toString()}',
        0,
      );
    }
  }

  Future<bool> registerRecrutador({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    try {
      final body = {
        'nome': nome,
        'senha': senha,
        'telefone': telefone,
        'email': email,
      };

      final response = await _apiClient.post(
        Endpoints.recrutadores,
        body: body,
        includeAuth: false,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        String errorMessage = 'Falha no registro';
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
        throw ApiException(errorMessage, response.statusCode);
      }
      return true;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro durante o processo de registro: ${e.toString()}',
        0,
      );
    }
  }

  String? _extractToken(Map<String, dynamic> responseData) {
    return responseData['token'];
  }

  Map<String, dynamic>? _parseJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      var normalized = base64Url.normalize(payload);
      var decoded = utf8.decode(base64Url.decode(normalized));

      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      print('Erro ao decodificar JWT: $e');
      return null;
    }
  }

  Future<void> _saveAuthData(
    String token,
    Map<String, dynamic> userData,
  ) async {
    try {
      await _prefs.setString(_authTokenKey, token);
      await _prefs.setString(_authUserKey, json.encode(userData));
    } catch (e) {
      await _clearAuthData();
      throw ApiException('Falha ao salvar dados de autenticação', 0);
    }
  }

  Future<void> _clearAuthData() async {
    try {
      await _prefs.remove(_authTokenKey);
      await _prefs.remove(_authUserKey);
      _currentUser = null;
      _apiClient.setAuthToken(null);
    } catch (e) {
      throw ApiException('Falha ao limpar dados de autenticação', 0);
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      if (_currentUser != null) return _currentUser;

      final userJson = _prefs.getString(_authUserKey);
      if (userJson != null && userJson.isNotEmpty) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        _currentUser = User.fromJson(userMap);
        if (_currentUser?.token != null && _apiClient.authToken == null) {
          _apiClient.setAuthToken(_currentUser!.token!);
        }
        return _currentUser;
      }
      return null;
    } catch (e) {
      await _clearAuthData();
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _clearAuthData();
    } catch (e) {
      throw ApiException('Falha durante o logout: ${e.toString()}', 0);
    }
  }

  Future<bool> isAuthenticated() async {
    final token = _prefs.getString(_authTokenKey);
    if (token == null) return false;

    final payload = _parseJwtPayload(token);
    if (payload != null && payload['exp'] != null) {
      try {
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(
          (payload['exp'] as int) * 1000,
        );
        if (DateTime.now().isAfter(expiryDate)) {
          await _clearAuthData();
          return false;
        }
      } catch (e) {
        await _clearAuthData();
        return false;
      }
    }

    if (_currentUser == null) {
      await getCurrentUser();
    }
    return _currentUser != null;
  }

  String? getToken() {
    return _prefs.getString(_authTokenKey);
  }
}
