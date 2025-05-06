import 'dart:convert';
import '../api_client.dart';
import '../models/formulario.dart';
import 'package:mobile/api/services/api_exception.dart';

class FormularioService {
  final ApiClient _apiClient;

  FormularioService(this._apiClient);

  Future<List<Formulario>> getFormularios() async {
    try {
      final response = await _apiClient.get(
        '/formularios/todos-formularios',
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

  Future<Formulario> getFormularioById(String id) async {
    try {
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

  Future<Formulario> criarForms(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        '/formularios/add',
        body: json.encode(data),
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

  Future<Formulario> alterarForms(
    String formId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.post(
        '/formularios/alterar/$formId',
        body: json.encode(data),
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Formulario.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'alterar formulário'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao alterar formulário: ${e.toString()}', 0);
    }
  }

  Future<Formulario> removerForms(String id) async {
    try {
      final response = await _apiClient.delete(
        '/formularios/remove/$id',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Formulario.fromJson(json.decode(response.body));
      } else {
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

      if (responseBody == null || responseBody.isEmpty) {
        return 'Resposta vazia do servidor ao tentar $operation';
      }

      final decoded = json.decode(responseBody);

      return decoded['message'] ??
          decoded['error'] ??
          decoded['error_description'] ??
          'Falha ao $operation: Status ${response.statusCode}';
    } catch (e) {
      return _getDefaultErrorMessage(response?.statusCode, operation);
    }
  }

  String _getDefaultErrorMessage(int? statusCode, String operation) {
    switch (statusCode) {
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
        return 'Falha ao $operation: Status $statusCode';
    }
  }
}
