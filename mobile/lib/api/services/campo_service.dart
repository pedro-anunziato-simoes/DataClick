import 'dart:convert';
import '../api_client.dart';
import '../models/campo.dart';
import '../endpoints.dart';

class CampoService {
  final ApiClient _apiClient;

  CampoService(this._apiClient);

  Future<List<Campo>> listarCampos() async {
    try {
      final response = await _apiClient.get(Endpoints.campos);
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Campo.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao listar campos: ${e.toString()}');
    }
  }

  Future<Campo> adicionarCampo(String formId, Campo campo) async {
    try {
      final response = await _apiClient.post(
        Endpoints.adicionarCampo(formId),
        body: json.encode(campo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return Campo.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Falha ao adicionar campo: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao adicionar campo: ${e.toString()}');
    }
  }

  Future<void> preencherCampo(String campoId, String valor) async {
    try {
      final response = await _apiClient.post(
        Endpoints.preencherCampo(campoId),
        body: json.encode({'valor': valor}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao preencher campo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao preencher campo: ${e.toString()}');
    }
  }

  Future<List<Campo>> camposPorFormulario(String formId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.camposPorFormulario(formId),
      );
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Campo.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao listar campos do formulário: ${e.toString()}');
    }
  }

  Future<void> removerCampo(String campoId) async {
    try {
      final response = await _apiClient.delete(Endpoints.removerCampo(campoId));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao remover campo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao remover campo: ${e.toString()}');
    }
  }
}
