import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/administrador.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<Administrador> login(String email, String senha) async {
    try {
      final response = await _apiClient.post(
        Endpoints.login,
        body: json.encode({'email': email, 'senha': senha}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Administrador.fromJson(json.decode(response.body));
      } else {
        throw AuthException(
          'Falha no login: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw AuthException('Erro durante o login', e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(
        Endpoints.logout,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      throw AuthException('Erro durante logout', e.toString());
    }
  }

  Future<Administrador> getPerfil() async {
    try {
      final response = await _apiClient.get(
        Endpoints.perfil,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Administrador.fromJson(json.decode(response.body));
      } else {
        throw AuthException(
          'Erro ao obter perfil: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw AuthException('Erro ao obter perfil', e.toString());
    }
  }
}

class AuthException implements Exception {
  final String message;
  final String details;

  AuthException(this.message, [this.details = '']);

  @override
  String toString() => '$message${details.isNotEmpty ? ': $details' : ''}';
}
