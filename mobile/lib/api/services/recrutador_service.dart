import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/recrutador.dart';

class RecrutadorService {
  final ApiClient _apiClient;

  RecrutadorService(this._apiClient);

  Future<Recrutador> criarRecrutador(
    String adminId,
    Recrutador recrutador,
  ) async {
    try {
      final response = await _apiClient.post(
        Endpoints.criarRecrutador,
        body: json.encode(recrutador.toJson()),
      );

      if (response.statusCode == 201) {
        return Recrutador.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Falha ao criar recrutador: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao criar recrutador: ${e.toString()}');
    }
  }

  Future<List<Recrutador>> listarPorAdmin(String adminId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.listarRecrutadoresPorAdmin(adminId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recrutador.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao listar recrutadores: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao listar recrutadores: ${e.toString()}');
    }
  }

  Future<void> removerRecrutador(String id) async {
    try {
      final response = await _apiClient.delete(Endpoints.removerRecrutador(id));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao remover recrutador: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao remover recrutador: ${e.toString()}');
    }
  }
}
