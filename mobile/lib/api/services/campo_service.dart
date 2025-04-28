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
      }
      throw ApiException.fromResponse(response, 'buscar campos do formulário');
    } catch (e) {
      throw ApiException.fromError(e, 'Erro ao buscar campos');
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
      }
      throw ApiException.fromResponse(response, 'buscar campo');
    } catch (e) {
      throw ApiException.fromError(e, 'Erro ao buscar campo');
    }
  }

  Future<Campo> updateCampo({
    required String campoId,
    required String tipo,
    required String titulo,
  }) async {
    try {
      final response = await _apiClient.put(
        '/campos/$campoId',
        body: json.encode({'tipo': tipo, 'titulo': titulo}),
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Campo.fromJson(json.decode(response.body));
      }
      throw ApiException.fromResponse(response, 'atualizar campo');
    } catch (e) {
      throw ApiException.fromError(e, 'Erro ao atualizar campo');
    }
  }

  Future<void> deleteCampo(String campoId) async {
    try {
      final response = await _apiClient.delete(
        '/campos/$campoId',
        includeAuth: true,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException.fromResponse(response, 'remover campo');
      }
    } catch (e) {
      throw ApiException.fromError(e, 'Erro ao remover campo');
    }
  }

  Future<Campo> createCampo({
    required String formId,
    required Campo campo,
  }) async {
    try {
      final response = await _apiClient.post(
        '/campos/$formId',
        body: json.encode(campo.toJson()),
        includeAuth: true,
      );

      if (response.statusCode == 201) {
        return Campo.fromJson(json.decode(response.body));
      }
      throw ApiException.fromResponse(response, 'criar campo');
    } catch (e) {
      throw ApiException.fromError(e, 'Erro ao criar campo');
    }
  }
}
