import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../mobile/lib/api/api_client.dart';
import '../../mobile/lib/api/models/user.dart';
import '../../mobile/lib/api/endpoints.dart';

class AuthService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthService({required this.apiClient, required this.sharedPreferences});

  Future<User> login(String email, String password) async {
    final response = await apiClient.post(
      Endpoints.login,
      body: json.encode({'email': email, 'senha': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data['user'] is Map<String, dynamic>) {
        final user = User.fromJson(data['user']);
        final token = data['token'] as String?;
        if (token != null) {
          await sharedPreferences.setString('auth_token', token);
        }
        return user;
      } else {
        throw Exception(
          'Falha no login: Resposta da API inválida (sem dados de usuário).',
        );
      }
    } else {
      try {
        final errorData = json.decode(response.body);
        throw Exception(
          'Falha no login: ${errorData['message'] ?? response.reasonPhrase}',
        );
      } catch (e) {
        throw Exception(
          'Falha no login: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    }
  }

  Future<User> register({
    required String nome,
    required String email,
    required String telefone,
    required String cnpj,
    required String senha,
    required String tipo,
  }) async {
    final response = await apiClient.post(
      Endpoints.register,
      body: json.encode({
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'cnpj': cnpj,
        'senha': senha,
        'tipo': tipo,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data != null && data['user'] is Map<String, dynamic>) {
        final user = User.fromJson(data['user']);
        final token = data['token'] as String?;
        if (token != null) {
          await sharedPreferences.setString('auth_token', token);
        }
        return user;
      } else {
        throw Exception(
          'Falha no registro: Resposta da API inválida (sem dados de usuário).',
        );
      }
    } else {
      try {
        final errorData = json.decode(response.body);
        throw Exception(
          'Falha no registro: ${errorData['message'] ?? response.reasonPhrase}',
        );
      } catch (e) {
        throw Exception(
          'Falha no registro: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    }
  }
}
