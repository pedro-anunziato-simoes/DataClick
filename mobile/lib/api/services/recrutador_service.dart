import 'dart:convert';
import '../api_client.dart';
import '../models/recrutador.dart';
import 'package:mobile/api/services/api_exception.dart';

class RecrutadorService {
  final ApiClient _apiClient;

  RecrutadorService(this._apiClient);

  Future<String> login(String email, String senha) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: json.encode({'email': email, 'senha': senha}),
        includeAuth: false,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['token'] as String;
      } else {
        throw ApiException(
          _getErrorMessage(response, 'fazer login'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao fazer login: ${e.toString()}', 0);
    }
  }

  Future<Recrutador> getRecrutadorByEmail(String email) async {
    try {
      final response = await _apiClient.get(
        '/recrutadores/por-email/$email',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Recrutador.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar recrutador por email'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro ao buscar recrutador por email: ${e.toString()}',
        0,
      );
    }
  }

  Future<Recrutador> getRecrutadorById(String recrutadorId) async {
    try {
      final response = await _apiClient.get(
        '/recrutadores/$recrutadorId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Recrutador.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar recrutador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar recrutador: ${e.toString()}', 0);
    }
  }

  Future<List<Recrutador>> getRecrutadores() async {
    try {
      final response = await _apiClient.get(
        '/recrutadores/list',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recrutador.fromJson(json)).toList();
      } else {
        throw ApiException(
          _getErrorMessage(response, 'listar recrutadores'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao listar recrutadores: ${e.toString()}', 0);
    }
  }

  Future<Recrutador> criarRecrutador(
    RecrutadorCreateDTO recrutadorCreateDTO, {
    required String nome,
    required String email,
    required String telefone,
    required String senha,
    required String adminId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/recrutadores',
        body: json.encode({
          'nome': nome,
          'email': email,
          'telefone': telefone,
          'senha': senha,
          'adminId': adminId,
        }),
        includeAuth: true,
      );

      if (response.statusCode == 201) {
        return Recrutador.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'criar recrutador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao criar recrutador: ${e.toString()}', 0);
    }
  }

  Future<Recrutador> alterarRecrutador({
    required String recrutadorId,
    required String nome,
    required String telefone,
    required String email,
  }) async {
    try {
      final response = await _apiClient.post(
        '/recrutadores/alterar/$recrutadorId',
        body: json.encode({'nome': nome, 'telefone': telefone, 'email': email}),
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Recrutador.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'alterar recrutador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao alterar recrutador: ${e.toString()}', 0);
    }
  }

  Future<void> excluirRecrutador(String recrutadorId) async {
    try {
      final response = await _apiClient.delete(
        '/recrutadores/remover/$recrutadorId',
        includeAuth: true,
      );

      if (response.statusCode != 200) {
        throw ApiException(
          _getErrorMessage(response, 'excluir recrutador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao excluir recrutador: ${e.toString()}', 0);
    }
  }

  Future<void> alterarEmail(String email, String recrutadorId) async {
    try {
      final response = await _apiClient.post(
        '/recrutadores/alterar/email',
        body: json.encode({'email': email, 'recrutadorId': recrutadorId}),
        includeAuth: true,
      );

      if (response.statusCode != 200) {
        throw ApiException(
          _getErrorMessage(response, 'alterar email do recrutador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao alterar email: ${e.toString()}', 0);
    }
  }

  Future<void> alterarSenha(String senha, String recrutadorId) async {
    try {
      final response = await _apiClient.post(
        '/recrutadores/alterar/senha',
        body: json.encode({'senha': senha, 'recrutadorId': recrutadorId}),
        includeAuth: true,
      );

      if (response.statusCode != 200) {
        throw ApiException(
          _getErrorMessage(response, 'alterar senha do recrutador'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao alterar senha: ${e.toString()}', 0);
    }
  }

  Future<Recrutador> getRecrutadorLogado() async {
    try {
      final response = await _apiClient.get(
        '/recrutadores/info',
        includeAuth: true,
      );
      if (response.statusCode == 200) {
        return Recrutador.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          _getErrorMessage(response, 'buscar recrutador logado'),
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Erro ao buscar recrutador logado: ${e.toString()}',
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
        return 'Não autorizado';
      case 403:
        return 'Acesso proibido';
      case 404:
        return 'Recurso não encontrado';
      case 500:
        return 'Erro interno do servidor';
      default:
        return 'Falha ao $operation: Status $statusCode';
    }
  }
}
