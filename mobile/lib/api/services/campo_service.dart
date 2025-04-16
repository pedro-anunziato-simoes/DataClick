import 'dart:convert';
import '../api_client.dart';
import '../models/campo.dart';
import '../models/resposta.dart';
import '../endpoints.dart';

class CampoService {
  final ApiClient _apiClient;

  CampoService(this._apiClient);

  Future<List<Campo>> listarCampos() async {
    try {
      final response = await _apiClient.get(Endpoints.campos);
      final data = json.decode(response.body);

      if (data is List) {
        return data.map((json) => Campo.fromJson(json)).toList();
      } else if (data['result'] is List) {
        return (data['result'] as List)
            .map((json) => Campo.fromJson(json))
            .toList();
      }
      throw Exception('Formato de resposta inesperado');
    } catch (e) {
      print('Erro ao listar campos: $e');
      rethrow;
    }
  }

  Future<Campo> adicionarCampo(String formId, Campo campo) async {
    try {
      final response = await _apiClient.post(
        Endpoints.adicionarCampo(formId),
        body: {
          'titulo': campo.titulo,
          'tipo': campo.tipo,
          'resposta': campo.resposta.toJson(),
        },
      );

      if (response.statusCode == 201) {
        return Campo.fromJson(json.decode(response.body));
      }
      throw Exception('Falha ao adicionar campo: ${response.statusCode}');
    } catch (e) {
      print('Erro ao adicionar campo: $e');
      rethrow;
    }
  }

  Future<Campo> alterarCampo(
    String campoId, {
    String? tipo,
    String? status,
  }) async {
    try {
      final body = {
        if (tipo != null) 'tipo': tipo,
        if (status != null) 'status': status,
      };

      final response = await _apiClient.post(
        Endpoints.alterarCampo(campoId),
        body: body,
      );

      if (response.statusCode == 200) {
        return Campo.fromJson(json.decode(response.body));
      }
      throw Exception('Falha ao alterar campo: ${response.statusCode}');
    } catch (e) {
      print('Erro ao alterar campo: $e');
      rethrow;
    }
  }

  Future<List<Campo>> camposPorFormulario(String formId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.camposPorFormulario(formId),
      );

      final data = json.decode(response.body);
      if (data is List) {
        return data.map((json) => Campo.fromJson(json)).toList();
      }
      throw Exception('Formato de resposta inesperado');
    } catch (e) {
      print('Erro ao listar campos do formulário: $e');
      rethrow;
    }
  }

  Future<void> removerCampo(String campoId) async {
    try {
      final response = await _apiClient.delete(Endpoints.removerCampo(campoId));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao remover campo: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao remover campo: $e');
      rethrow;
    }
  }
}
