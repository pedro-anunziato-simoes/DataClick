import 'dart:convert';
import '../api_client.dart';
import '../models/campo.dart';
import 'package:mobile/api/services/api_exception.dart';

class CampoService {
  final ApiClient _apiClient;

  CampoService(this._apiClient);

  Future<List<Campo>> getCamposByFormId(String formId) async {
    try {
      final response = await _apiClient.get(
        '/campos/findByFormId/$formId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Campo.fromJson(json)).toList();
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar campos do formulário'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar campos: ${e.toString()}', 0);
    }
  }

  Future<List<Campo>> getCamposObrigatorios(String formId) async {
    try {
      final response = await _apiClient.get(
        '/campos/findObrigatorios/$formId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Campo.fromJson(json)).toList();
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar campos obrigatórios'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro ao buscar campos obrigatórios: ${e.toString()}',
        0,
      );
    }
  }

  Future<Campo> getCampoById(String campoId) async {
    try {
      final response = await _apiClient.get(
        '/campos/$campoId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Campo.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar campo'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar campo: ${e.toString()}', 0);
    }
  }

  Future<Campo> criarCampo({
    required String formId,
    required String titulo,
    required String tipo,
    bool isObrigatorio = false,
    String? descricao,
    List<String>? opcoes,
  }) async {
    try {
      final campoData = {
        'titulo': titulo,
        'tipo': tipo,
        'isObrigatorio': isObrigatorio,
        if (descricao != null) 'descricao': descricao,
        if (opcoes != null && opcoes.isNotEmpty) 'opcoes': opcoes,
      };

      final response = await _apiClient.post(
        '/campos/add/$formId',
        body: json.encode(campoData),
        includeAuth: true,
      );

      if (response.statusCode == 201) {
        return Campo.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'criar campo'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao criar campo: ${e.toString()}', 0);
    }
  }

  Future<Campo> atualizarCampo({
    required String campoId,
    required String titulo,
    required String tipo,
    bool? isObrigatorio,
    String? descricao,
    List<String>? opcoes,
  }) async {
    try {
      final campoData = {
        'titulo': titulo,
        'tipo': tipo,
        if (isObrigatorio != null) 'isObrigatorio': isObrigatorio,
        if (descricao != null) 'descricao': descricao,
        if (opcoes != null) 'opcoes': opcoes,
      };

      final response = await _apiClient.put(
        '/campos/update/$campoId',
        body: json.encode(campoData),
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Campo.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'atualizar campo'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao atualizar campo: ${e.toString()}', 0);
    }
  }

  Future<void> removerCampo(String campoId) async {
    try {
      final response = await _apiClient.delete(
        '/campos/remove/$campoId',
        includeAuth: true,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          _getErrorMessage(response, 'remover campo'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao remover campo: ${e.toString()}', 0);
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
        return 'Recurso não encontrado';
      case 500:
        return 'Erro interno do servidor ao $operation';
      default:
        return 'Falha ao $operation: Status $statusCode';
    }
  }
}
