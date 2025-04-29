import 'dart:convert';
import '../api_client.dart';
import '../models/formulario.dart';
import '../models/campo.dart';
import 'package:mobile/api/services/api_exception.dart';
import 'package:mobile/api/services/auth_service.dart';

class FormularioService {
  final ApiClient _apiClient;
  final AuthService _authService;

  FormularioService(this._apiClient, this._authService);

  Future<List<Formulario>> getMeusFormularios() async {
    try {
      if (!_authService.isAuthenticated()) {
        throw ApiException('Sessão expirada. Faça login novamente.', 401);
      }

      final response = await _apiClient.get(
        '/formularios/{id}',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Formulario.fromJson(json)).toList();
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar formulários'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar formulários: ${e.toString()}', 0);
    }
  }

  Future<Formulario> obterFormularioPorId(String id) async {
    try {
      if (!_authService.isAuthenticated()) {
        throw ApiException('Sessão expirada. Faça login novamente.', 401);
      }

      final response = await _apiClient.get(
        '/formularios/$id',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Formulario.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'obter formulário'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao obter formulário: ${e.toString()}', 0);
    }
  }

  Future<Formulario> criarFormulario({
    required String titulo,
    required List<Campo> campos,
  }) async {
    try {
      if (!_authService.isAuthenticated()) {
        throw ApiException('Sessão expirada. Faça login novamente.', 401);
      }

      if (_authService.isTokenAboutToExpire()) {
        print('[FormularioService] Token prestes a expirar, considere renovar');
      }

      final response = await _apiClient.post(
        '/formularios/add',
        body: {
          'titulo': titulo,
          'campos': campos.map((c) => c.toJson()).toList(),
        },
        includeAuth: true,
      );

      if (response.statusCode == 201) {
        return Formulario.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'criar formulário'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao criar formulário: ${e.toString()}', 0);
    }
  }

  Future<Formulario> atualizarFormulario({
    required String formId,
    required String titulo,
    required List<Campo> campos,
  }) async {
    try {
      if (!_authService.isAuthenticated()) {
        throw ApiException('Sessão expirada. Faça login novamente.', 401);
      }

      final response = await _apiClient.post(
        '/formularios/alterar/$formId',
        body: {
          'titulo': titulo,
          'campos': campos.map((c) => c.toJson()).toList(),
        },
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Formulario.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'atualizar formulário'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao atualizar formulário: ${e.toString()}', 0);
    }
  }

  Future<void> removerFormulario(String id) async {
    try {
      if (!_authService.isAuthenticated()) {
        throw ApiException('Sessão expirada. Faça login novamente.', 401);
      }

      final response = await _apiClient.delete(
        '/formularios/remove/$id',
        includeAuth: true,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          _getErrorMessage(response, 'remover formulário'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao remover formulário: ${e.toString()}', 0);
    }
  }

  String _getErrorMessage(dynamic response, String operation) {
    try {
      final responseBody = response is String ? response : response.body;
      final decoded = json.decode(responseBody);

      return decoded['message'] ??
          decoded['error'] ??
          decoded['error_description'] ??
          'Falha ao $operation: Status ${response.statusCode}';
    } catch (e) {
      switch (response.statusCode) {
        case 400:
          return 'Requisição inválida ao $operation';
        case 401:
          return 'Não autorizado. Faça login novamente.';
        case 403:
          return 'Acesso negado. Permissões insuficientes para $operation';
        case 404:
          return 'Formulário não encontrado';
        case 500:
          return 'Erro interno do servidor ao $operation';
        default:
          return 'Falha ao $operation: Status ${response.statusCode}';
      }
    }
  }
}
