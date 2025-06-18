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
      if (eventoId.isEmpty) {
        throw ApiException('ID do evento é obrigatório', 400);
      }

      final response = await _apiClient.get(
        '/formularios/formulario/evento/$eventoId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Formulario.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw ApiException('Acesso negado. Verifique suas permissões.', 403);
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

  Future<Map<String, dynamic>?> buscarEventoPorId(String eventoId) async {
    try {
      // Validação básica
      if (eventoId.trim().isEmpty) {
        throw ApiException('ID do evento é obrigatório', 400);
      }

      // 1. Busca TODOS os eventos
      final response = await _apiClient.get('/eventos', includeAuth: true);

      if (response.statusCode == 200) {
        final List<dynamic> eventos = json.decode(response.body);

        // 2. Filtra o evento com o ID desejado
        final evento = eventos.firstWhere(
          (evento) => evento['eventoId'] == eventoId,
          orElse: () => null,
        );

        return evento as Map<String, dynamic>?;
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar evento'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar evento: ${e.toString()}', 0);
    }
  }

  Future<Formulario> criarFormulario({
    required String titulo,
    required String eventoId,
    required String adminId,
    required List<Campo> campos,
    String? descricao,
  }) async {
    try {
      // Validações básicas
      if (titulo.trim().isEmpty) {
        throw ApiException('Título do formulário é obrigatório', 400);
      }

      if (eventoId.isEmpty) {
        throw ApiException('ID do evento é obrigatório', 400);
      }

      if (adminId.isEmpty) {
        throw ApiException('ID do administrador é obrigatório', 400);
      }

      // Permitir criar formulário sem campos, pois os campos serão adicionados depois

      await _apiClient.get('/eventos');

      final formData = {
        'formularioTituloDto': titulo.trim(),
        'eventoId': eventoId,
        'adminId': adminId,
        'campos': campos.map((campo) => campo.toJson()).toList(),
        if (descricao != null) 'descricao': descricao,
      };

      // print('DEBUG: Título do formulário enviado: $titulo');
      // print('DEBUG: Dados enviados para o backend: $formData');

      final response = await _apiClient.post(
        '/formularios/add/$eventoId',
        body: json.encode(formData),
        includeAuth: true,
      );

      // print('DEBUG: Resposta do backend ao criar formulário: [32m${response.body}\u001b[0m');

      if (response.statusCode == 201 || response.statusCode == 200) {
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
      throw ApiException(
        'Erro ao criar formulário: [31m${e.toString()}\u001b[0m',
        0,
      );
    }
  }

  Future<Formulario> alterarFormulario({
    required String formId,
    required String titulo,
    required List<Campo> campos,
    String? descricao,
  }) async {
    try {
      if (titulo.trim().isEmpty) {
        throw ApiException('Título do formulário é obrigatório', 400);
      }

      if (campos.isEmpty) {
        throw ApiException('O formulário deve ter pelo menos um campo', 400);
      }

      final formData = {
        'titulo': titulo.trim(),
        'formularioTitulo': titulo.trim(),
        'campos': campos.map((campo) => campo.toJson()).toList(),
        if (descricao != null) 'descricao': descricao,
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

  Future<void> enviarRespostasFormulario({
    required String formId,
    required Map<String, dynamic> respostas,
  }) async {
    try {
      final response = await _apiClient.post(
        '/formulariosPreenchidos/add/$formId',
        body: json.encode(respostas),
        includeAuth: true,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          _getErrorMessage(response, 'enviar respostas do formulário'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao enviar respostas: ${e.toString()}', 0);
    }
  }

  Future<List<Formulario>> getFormulariosPreenchidos(String eventoId) async {
    try {
      final response = await _apiClient.get(
        '/formualriosPreenchidos/$eventoId',
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

  Future<void> adicionarFormulariosPreenchidos({
    required String eventoId,
    required List<Formulario> formularios,
  }) async {
    try {
      final body = {
        'formulariosPreenchidosDtoListForms':
            formularios.map((f) => f.toJson()).toList(),
      };

      final response = await _apiClient.post(
        '/formualriosPreenchidos/add',
        body: json.encode(body),
        includeAuth: true,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          _getErrorMessage(response, 'adicionar formulários preenchidos'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro ao adicionar formulários preenchidos: ${e.toString()}',
        0,
      );
    }
  }
}
