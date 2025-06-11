import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/administrador.dart';
import 'api_exception.dart';

class AdministradorService {
  final ApiClient _apiClient;

  AdministradorService(this._apiClient);

  Future<Administrador> criarAdministrador(Administrador administrador) async {
    try {
      final response = await _apiClient.post(
        Endpoints.administradores,
        body: json.encode(administrador.toJson()),
        includeAuth: true,
      );

      if (response.statusCode == 201) {
        return Administrador.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'criar administrador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao criar administrador: ${e.toString()}', 0);
    }
  }

  Future<Administrador> obterPorId(String id) async {
    try {
      final response = await _apiClient.get(
        '${Endpoints.administradores}/$id',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Administrador.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'obter administrador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao obter administrador: ${e.toString()}', 0);
    }
  }

  Future<Administrador> getAdministradorInfo() async {
    try {
      final response = await _apiClient.get(
        '${Endpoints.administradores}/info',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Administrador.fromJson(jsonData);
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar informações do administrador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro ao buscar informações do administrador: ${e.toString()}',
        0,
      );
    }
  }

  Future<void> alterarEmail(String email) async {
    try {
      final response = await _apiClient.post(
        '${Endpoints.administradores}/alterar/email',
        body: json.encode(email),
        includeAuth: true,
      );

      if (response.statusCode != 204) {
        throw ApiException(
          _getErrorMessage(response, 'alterar email'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao alterar email: ${e.toString()}', 0);
    }
  }

  Future<void> alterarSenha(String senha) async {
    try {
      final response = await _apiClient.post(
        '${Endpoints.administradores}/alterar/senha',
        body: json.encode(senha),
        includeAuth: true,
      );

      if (response.statusCode != 204) {
        throw ApiException(
          _getErrorMessage(response, 'alterar senha'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao alterar senha: ${e.toString()}', 0);
    }
  }

  Future<void> removerAdministrador(String id) async {
    try {
      final response = await _apiClient.delete(
        Endpoints.removerAdministrador(id),
        includeAuth: true,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          _getErrorMessage(response, 'remover administrador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao remover administrador: ${e.toString()}', 0);
    }
  }

  String _getErrorMessage(dynamic response, String operation) {
    try {
      if (response.body != null && response.body.isNotEmpty) {
        final errorData = json.decode(response.body);
        if (errorData is Map<String, dynamic>) {
          return errorData['message'] ?? 'Erro ao $operation';
        }
      }
    } catch (e) {
      // Ignora erros de parsing
    }

    switch (response.statusCode) {
      case 400:
        return 'Dados inválidos para $operation';
      case 401:
        return 'Não autorizado para $operation';
      case 403:
        return 'Acesso negado para $operation';
      case 404:
        return 'Administrador não encontrado';
      case 500:
        return 'Erro interno do servidor';
      default:
        return 'Erro ao $operation (${response.statusCode})';
    }
  }
}
