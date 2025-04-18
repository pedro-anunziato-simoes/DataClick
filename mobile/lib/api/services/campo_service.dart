import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/campo.dart';

class CampoService {
  static const String _baseUrl = 'localhost:8080';
  final ApiClient _apiClient;

  CampoService(this._apiClient);

  Future<List<Campo>> getCamposByFormId(String formId) async {
    try {
      final response = await _apiClient.get(
        '$_baseUrl/campos/findByFormId/$formId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Campo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get campos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting campos: ${e.toString()}');
    }
  }

  Future<Campo> getCampoById(String campoId) async {
    try {
      final response = await _apiClient.get(
        '$_baseUrl/campos/$campoId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Campo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get campo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting campo: ${e.toString()}');
    }
  }

  Future<Campo> alterarCampo(
    String campoId, {
    required String tipo,
    required String titulo,
  }) async {
    try {
      final response = await _apiClient.post(
        '$_baseUrl/campos/alterar/$campoId',
        body: json.encode({'tipo': tipo, 'titulo': titulo}),
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Campo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update campo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating campo: ${e.toString()}');
    }
  }

  Future<Campo> deletarCampo(String campoId) async {
    try {
      final response = await _apiClient.delete(
        '$_baseUrl/campos/remover/$campoId',
        includeAuth: true,
      );

      if (response.statusCode == 200) {
        return Campo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to delete campo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting campo: ${e.toString()}');
    }
  }

  Future<Campo> adicionarCampo(String formId, Campo campo) async {
    try {
      final response = await _apiClient.post(
        '$_baseUrl/campos/add/$formId',
        body: json.encode(campo.toJson()),
        includeAuth: true,
      );

      if (response.statusCode == 201) {
        return Campo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add campo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding campo: ${e.toString()}');
    }
  }
}
