import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/administrador.dart';
import 'package:mobile/api/api_client.dart';
import 'package:mobile/api/services/api_exception.dart';
import '../endpoints.dart';

class AuthService {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;
  Administrador? _currentUser;

  static const String _authTokenKey = 'auth_token';
  static const String _authUserKey = 'auth_user';

  AuthService(this._apiClient, this._prefs);

  Future<bool> login(String email, String senha) async {
    try {
      print('[AuthService] Iniciando login para $email');

      final response = await _apiClient.post(
        Endpoints.login,
        body: {'email': email, 'senha': senha},
        includeAuth: false,
      );

      print('[AuthService] Resposta recebida: ${response.statusCode}');
      print('[AuthService] Corpo da resposta: ${response.body}');

      if (response.statusCode != 200) {
        throw ApiException(
          _getErrorMessage(response.body) ?? 'Credenciais inválidas',
          response.statusCode,
        );
      }

      final responseData = json.decode(response.body);
      final token = _extractToken(responseData);
      final userData = _extractUserData(responseData);

      if (token == null) {
        throw ApiException('Token não encontrado na resposta', 401);
      }

      await _saveAuthData(token, userData);
      _apiClient.setAuthToken(token);

      print('[AuthService] Login realizado com sucesso');
      return true;
    } on ApiException {
      rethrow;
    } catch (e) {
      print('[AuthService] Erro inesperado no login: $e');
      throw ApiException('Erro durante o processo de login', 0);
    }
  }

  Future<void> register({
    required String nome,
    required String email,
    required String telefone,
    required String cnpj,
    required String senha,
  }) async {
    try {
      print('[AuthService] Registrando novo usuário: $email');

      final response = await _apiClient.post(
        Endpoints.register,
        body: {
          'nome': nome,
          'email': email,
          'telefone': telefone,
          'cnpj': cnpj,
          'senha': senha,
        },
        includeAuth: false,
      );

      print('[AuthService] Resposta do registro: ${response.statusCode}');
      print('[AuthService] Corpo da resposta: ${response.body}');

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException(
          _getErrorMessage(response.body) ?? 'Falha no registro',
          response.statusCode,
        );
      }

      // Após registro bem-sucedido, faz login automaticamente
      final loginSuccess = await login(email, senha);
      if (!loginSuccess) {
        throw ApiException(
          'Registro concluído, mas falha no login automático',
          0,
        );
      }

      print('[AuthService] Registro e login realizados com sucesso');
    } on ApiException {
      rethrow;
    } catch (e) {
      print('[AuthService] Erro inesperado no registro: $e');
      throw ApiException('Erro durante o processo de registro', 0);
    }
  }

  String? _extractToken(Map<String, dynamic> responseData) {
    // Verifica se o token está no formato {"token": "valor"}
    final token = responseData['token'];

    if (token != null && token is String) {
      print('[AuthService] Token JWT extraído com sucesso');
      return token;
    }

    print('[AuthService] Formato de token não reconhecido: $responseData');
    return null;
  }

  Map<String, dynamic> _extractUserData(Map<String, dynamic> responseData) {
    try {
      // Tenta extrair dados do usuário de várias possíveis estruturas
      final userData =
          responseData['usuario'] ??
          responseData['user'] ??
          responseData['data']?['user'] ??
          {};

      // Se não encontrou dados explícitos, tenta extrair do payload JWT
      if (userData.isEmpty && responseData['token'] != null) {
        final token = responseData['token'] as String;
        final payload = _parseJwtPayload(token);
        if (payload != null) {
          return {
            'id': payload['usuarioId'],
            'email': payload['sub'],
            'roles': payload['authorities'],
          };
        }
      }

      return userData;
    } catch (e) {
      print('[AuthService] Erro ao extrair dados do usuário: $e');
      return {};
    }
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
      print('[AuthService] Erro ao decodificar JWT: $e');
      return null;
    }
  }

  String? _getErrorMessage(String responseBody) {
    try {
      final decoded = json.decode(responseBody);
      return decoded['message'] ??
          decoded['error'] ??
          decoded['error_description'] ??
          'Erro desconhecido';
    } catch (e) {
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

      if (userData.isNotEmpty) {
        _currentUser = Administrador.fromJson(userData);
      }

      print('[AuthService] Dados de autenticação salvos com sucesso');
      final displayLength = token.length < 248 ? token.length : 248;
      print(
        '[AuthService] Token salvo: ${token.substring(0, displayLength)}... (tamanho total: ${token.length} caracteres)',
      );
      print('[AuthService] Dados do usuário: $userData');
    } catch (e) {
      await _clearAuthData();
      print('[AuthService] Erro ao salvar dados: $e');
      throw ApiException('Falha ao salvar dados de autenticação', 0);
    }
  }

  Future<void> _clearAuthData() async {
    try {
      await _prefs.remove(_authTokenKey);
      await _prefs.remove(_authUserKey);
      _currentUser = null;
      _apiClient.setAuthToken(null);
      print('[AuthService] Dados de autenticação removidos');
    } catch (e) {
      print('[AuthService] Erro ao limpar dados: $e');
      throw ApiException('Falha ao limpar dados de autenticação', 0);
    }
  }

  Future<Administrador?> getCurrentUser() async {
    try {
      if (_currentUser != null) return _currentUser;

      final userJson = _prefs.getString(_authUserKey);
      if (userJson != null && userJson.isNotEmpty) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        _currentUser = Administrador.fromJson(userMap);
        return _currentUser;
      }
      return null;
    } catch (e) {
      await _clearAuthData();
      print('[AuthService] Erro ao carregar usuário: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      print('[AuthService] Realizando logout');
      await _clearAuthData();
    } catch (e) {
      print('[AuthService] Erro no logout: $e');
      throw ApiException('Falha durante o logout', 0);
    }
  }

  bool isAuthenticated() {
    final token = _prefs.getString(_authTokenKey);
    if (token == null) return false;

    final payload = _parseJwtPayload(token);
    if (payload != null && payload['exp'] != null) {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(
        payload['exp'] * 1000,
      );
      return DateTime.now().isBefore(expiryDate);
    }

    return true;
  }

  String? getToken() {
    return _prefs.getString(_authTokenKey);
  }

  bool isTokenAboutToExpire({int minutes = 5}) {
    final token = getToken();
    if (token == null) return true;

    final payload = _parseJwtPayload(token);
    if (payload != null && payload['exp'] != null) {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(
        payload['exp'] * 1000,
      );
      return expiryDate.difference(DateTime.now()).inMinutes <= minutes;
    }

    return false;
  }
}
