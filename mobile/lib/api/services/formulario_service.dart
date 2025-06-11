import 'dart:convert';
import '../api_client.dart';
import '../models/formulario.dart';
import '../models/campo.dart';
import 'package:mobile/api/services/api_exception.dart';

class FormularioService {
  final ApiClient _apiClient;

  FormularioService(this._apiClient);

  Future<List<Formulario>> getFormulariosByEvento(String eventoId) async {
    try {
      final response = await _apiClient.get(
        '/formularios/formulario/evento/$eventoId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Formulario.fromJson(json)).toList();
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar formulários do evento'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro ao buscar formulários do evento: ${e.toString()}',
        0,
      );
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

  Future<Formulario> criarFormulario({
    required String titulo,
    required String eventoId,
    required List<Campo> campos,
  }) async {
    try {
      // Verifica se o evento existe antes de criar o formulário
      await _apiClient.get('/eventos/$eventoId');

      final formData = {
        'titulo': titulo,
        'eventoId': eventoId,
        'campos': campos.map((campo) => campo.toJson()).toList(),
      };

      final response = await _apiClient.post(
        '/formularios/add/$eventoId',
        body: json.encode(formData),
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

  Future<Formulario> alterarFormulario({
    required String formId,
    required String titulo,
    required List<Campo> campos,
  }) async {
    try {
      final formData = {
        'titulo': titulo,
        'campos': campos.map((campo) => campo.toJson()).toList(),
      };

      final response = await _apiClient.put(
        '/formularios/alterar/$formId',
        body: json.encode(formData),
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

  Future<void> removerFormulario(String id) async {
    try {
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

  Future<List<Formulario>> getFormulariosPreenchidos(String eventoId) async {
    try {
      final response = await _apiClient.get(
        '/formulariosPreenchidos/$eventoId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Formulario.fromJson(json)).toList();
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar formulários preenchidos'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro ao buscar formulários preenchidos: ${e.toString()}',
        0,
      );
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
        return 'Recurso não encontrado (Evento ou Formulário)';
      case 409:
        return 'Conflito ao tentar $operation';
      case 500:
        return 'Erro interno do servidor ao $operation';
      default:
        return 'Falha ao $operation: Status $statusCode';
    }
  }
}
